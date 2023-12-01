terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
  }
    backend "s3" {
    bucket = "digger-s3backend-demo-dynamic-env-vars"              # Change if a different S3 bucket name was used for the backend 
    region = "us-east-1"
  }
}

variable "sg_cidr" {}


provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_vpc" "vpc_network" {
  cidr_block = "11.0.0.0/16"
  tags = {
    Name = "digger-demo-project-dependencies-network"
  }
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id                  = aws_vpc.vpc_network.id
  cidr_block              = "11.0.1.0/24"
  availability_zone       = "us-east-1a"  
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-subnet"
  }
}


resource "aws_security_group" "security_group" {
  vpc_id      = aws_vpc.vpc_network.id
  name_prefix = "terraform-"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
  }
}

output "vpc_id" {
    value = aws_vpc.vpc_network.id
}

output "subnet_id" {
    value = aws_subnet.vpc_subnet.id
}

output "sg_id" {
    value = aws_security_group.security_group.id
}
