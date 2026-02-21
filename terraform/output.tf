output "instance_ip" {
  value       = aws_instance.app-server.public_ip
  description = "The public IP address of the EC2 instance"
}
