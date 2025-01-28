output "public-ip-address" {
  description = "The public IP address of the EC2 instance"
  value = aws_instance.EC2.public_ip
}