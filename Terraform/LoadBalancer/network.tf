resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "My terraform vpc"
    }
}
variable "public_subnet_ciders" {
    default = [
        "10.0.1.0/24",
        "10.0.2.0/24"
    ]
}
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
        Name = "My terraform geteway"
    }
}
resource "aws_subnet" "public" {
    count = length(var.public_subnet_ciders)
    cidr_block = element(var.public_subnet_ciders, count.index)
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.main_vpc.id 
    tags = {
        Name = "My terraform subnet"
    } 
}
resource "aws_route_table" "public" {
    count = length(var.public_subnet_ciders)
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "My terraform route"
    }
}
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_ciders)
    route_table_id = aws_route_table.public[count.index].id
    subnet_id = element(aws_subnet.public[*].id, count.index)
}
data "aws_availability_zones" "available" {
  
}
