output "vpc_id" {
  value = aws_vpc.ecommerce_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "security_group_id" {
  value = aws_security_group.app_sg.id
}

output "eip_public_ip" {
  description = "Public IP of the Elastic IP allocated to the EC2 instance"
  value = aws_eip.ecommerce_eip.public_ip  # This will output the Elastic IP associated with the EC2 instance
}

