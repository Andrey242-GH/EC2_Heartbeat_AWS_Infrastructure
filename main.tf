terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# --------------------------------------------------
# Amazon Linux 2023 AMI
# --------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# --------------------------------------------------
# Security Group
# --------------------------------------------------

resource "aws_security_group" "heartbeat" {
  name        = "${var.project_name}-sg"
  description = "Security group for EC2 Heartbeat application"

  ingress {
    description = "Heartbeat web application"
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-sg"
    ManagedBy = "Terraform"
  }
}


# --------------------------------------------------
# EC2
# --------------------------------------------------

resource "aws_instance" "heartbeat" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.heartbeat.id
  ]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name        = "${var.project_name}-server"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}