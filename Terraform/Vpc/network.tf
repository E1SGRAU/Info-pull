resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "My terraform vpc"
    }
}
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
        Name = "My terraform geteway"
    }
}
resource "aws_subnet" "public" {
    cidr_block = "10.0.10.0/24"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.main_vpc.id 
    tags = {
        Name = "My terraform subnet"
    } 
}
resource "aws_route_table" "public" {
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
    route_table_id = aws_route_table.public.id
    subnet_id = (aws_subnet.public.id)
}
