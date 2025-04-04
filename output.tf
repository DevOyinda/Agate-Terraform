output "aws_region" {
  value = "us-east-2"
}

output "ssh_private_key_file" {
    description = "SSH private key file for accessing the instance"
    value       = "Download your SSH key from: ./${var.key_name}.pem"
}

output "eip_public_ip" {
  value = module.ec2.eip_public_ip
}