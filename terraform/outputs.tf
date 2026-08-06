output "linux_public_ip" {
  description = "Public IP of the Linux EC2 instance"
  value       = aws_instance.linux_server.public_ip
}

output "windows_public_ip" {
  description = "Public IP of the Windows EC2 instance"
  value       = aws_instance.windows_server.public_ip
}

output "linux_instance_id" {
  description = "Linux EC2 Instance ID"
  value       = aws_instance.linux_server.id
}

output "windows_instance_id" {
  description = "Windows EC2 Instance ID"
  value       = aws_instance.windows_server.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}