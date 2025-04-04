output "ec2_instance_id" {
    description = "Instance ID of the deployed EC2 instance"
    value       = aws_instance.app_instance.id
}


output "eip_public_ip" {
  description = "Public IP of the Elastic IP allocated to the EC2 instance"
  value = aws_eip.ecommerce_eip.public_ip  # This will output the Elastic IP associated with the EC2 instance
}

/*
output "alb_sg_id" {
  value = aws_security_group.app_sg.id
}
*/