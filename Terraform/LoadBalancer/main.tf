provider "aws" {
    region = "eu-north-1"
    access_key = var.aws_accses_key
    secret_key = var.aws_secret_key
}
resource "aws_security_group" "web" {
    name = "web"
    vpc_id = aws_vpc.main_vpc.id
    description = "example dynamic SG"
    dynamic "ingress" {
        for_each = ["80", "443", "8080", "22"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            cidr_blocks = ["0.0.0.0/0"]
            protocol = "tcp"
        }
    }   
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "terraform_SG"
    }
}
data "aws_ami" "zmazon_linux" {
    owners = ["amazon"]
    most_recent = true
    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}
resource "aws_launch_configuration" "web" {
    image_id = data.aws_ami.zmazon_linux.id
    instance_type = var.aws_instance_type
    security_groups = [aws_security_group.web.id]
    user_data = file("file1.sh")
}
resource "aws_autoscaling_group" "web" {
    name_prefix = "web"
    desired_capacity = 2
    max_size = 4
    min_size = 1
    vpc_zone_identifier = aws_subnet.public[*].id
    health_check_type = "EC2"
    default_cooldown = 300
    launch_configuration = aws_launch_configuration.web.name
    target_group_arns = [aws_lb_target_group.web.arn]
}
resource "aws_lb" "web" {
    internal = false
    security_groups = [aws_security_group.web.id]
    subnets = aws_subnet.public.*.id
    enable_deletion_protection = false  
}
resource "aws_lb_target_group" "web" {
    name = "web"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main_vpc.id
}
resource "aws_lb_listener" "web_end" {
    load_balancer_arn = aws_lb.web.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.web.arn
    }
}
resource "aws_autoscaling_attachment" "web" {
    autoscaling_group_name = aws_autoscaling_group.web.id
    lb_target_group_arn = aws_lb_target_group.web.arn
}
resource "aws_autoscaling_policy" "cpu_up" {
    name = "cpu_up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.web.name
}
resource "aws_cloudwatch_metric_alarm" "cpu_check" {
    alarm_name = "cpu_alarm_up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "2"
    dimensions = {
      AutoscalingGroupName = aws_autoscaling_group.web.name
    }
    alarm_description = "This metric for monitoring cpu"
    alarm_actions = [aws_autoscaling_policy.cpu_up.arn]
}
resource "aws_autoscaling_policy" "cpu_down" {
    name = "cpu_down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.web.name
}
resource "aws_cloudwatch_metric_alarm" "cpu_check_down" {
    alarm_name = "cpu_alarm_down"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "40"
    dimensions = {
      AutoscalingGroupName = aws_autoscaling_group.web.name
    }
    alarm_description = "This metric for monitoring cpu"
    alarm_actions = [aws_autoscaling_policy.cpu_down.arn]
}
