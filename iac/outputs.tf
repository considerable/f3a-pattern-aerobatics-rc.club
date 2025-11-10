output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.f3a_microservice.id
}

output "instance_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.f3a_microservice.public_ip
}

output "instance_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.f3a_microservice.public_dns
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.f3a_microservice.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = var.key_name != null ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.f3a_microservice.public_ip}" : "No SSH key configured"
}

output "microservice_url" {
  description = "Microservice URL"
  value       = var.create_dns_record ? "http://app.${var.domain_name}:30080" : "http://${aws_instance.f3a_microservice.public_ip}:30080"
}

output "api_url" {
  description = "API URL"
  value       = var.create_api_dns_record ? "http://api.${var.domain_name}:30080" : "http://${aws_instance.f3a_microservice.public_ip}:30080"
}
