resource "aws_vpc" "vpc_assignment" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags       = {
        Name = "Assignment VPC"
    }
}

resource "aws_internet_gateway" "internet_gateway_assignment" {
    vpc_id = aws_vpc.vpc_assignment.id
}

resource "aws_subnet" "public_subnet_a_assignment" {
    vpc_id                  = aws_vpc.vpc_assignment.id
    cidr_block              = var.public_subnet_a_cidr
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = "true"
}

resource "aws_subnet" "public_subnet_b_assignment" {
    vpc_id                  = aws_vpc.vpc_assignment.id
    cidr_block              = var.public_subnet_b_cidr
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = "true"
}

resource "aws_route_table" "public_subnet_a_assignment" {
    vpc_id = aws_vpc.vpc_assignment.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway_assignment.id
    }
}

resource "aws_route_table" "public_subnet_b_assignment" {
    vpc_id = aws_vpc.vpc_assignment.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway_assignment.id
    }
}

resource "aws_route_table_association" "route_table_a_association_assignment" {
    subnet_id      = aws_subnet.public_subnet_a_assignment.id
    route_table_id = aws_route_table.public_subnet_a_assignment.id
}

resource "aws_route_table_association" "route_table_b_association_assignment" {
    subnet_id      = aws_subnet.public_subnet_b_assignment.id
    route_table_id = aws_route_table.public_subnet_b_assignment.id
}

resource "aws_security_group" "ecs_assignment" {
    name        = "Assignment Security Group"
    vpc_id      = aws_vpc.vpc_assignment.id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

}
