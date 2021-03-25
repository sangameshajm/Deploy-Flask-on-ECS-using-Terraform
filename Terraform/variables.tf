variable "aws_region" {
  description = "Region for the Assignment VPC"
  default = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "192.168.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for the public subnet"
  default = "192.168.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for the private subnet"
  default = "192.168.2.0/24"
}

variable "ecs_cluster_name" {
    description = "Name of the ECS cluster"
    default = "assignment_cluster"
}

variable "ami_id" {
    description = "AMI ID for ECS Cluster"
    default = "ami-05fece3209ae18166"
}

variable "instance_type" {
    description = "ECS Instance Type"
    default = "t2.micro"
}