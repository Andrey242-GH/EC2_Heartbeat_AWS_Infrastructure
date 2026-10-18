output "instance_id" {
  description = "ID of the Heartbeat EC2 instance"
  value       = aws_instance.heartbeat.id
}

output "public_ip" {
  description = "Public IP address of the Heartbeat EC2 instance"
  value       = aws_instance.heartbeat.public_ip
}

output "application_url" {
  description = "URL for the Heartbeat web application"
  value       = "http://${aws_instance.heartbeat.public_ip}:${var.web_port}"
}

output "health_check_url" {
  description = "Health endpoint for the Heartbeat application"
  value       = "http://${aws_instance.heartbeat.public_ip}:${var.web_port}/health"
}