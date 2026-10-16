variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Name used to identify the EC2 Heartbeat resources"
  type        = string
  default     = "ec2-heartbeat"
}

variable "web_port" {
  description = "Port used by the Heartbeat web application"
  type        = number
  default     = 5000
}