resource "aws_instance" "app_instance" {

    ami                     = var.ami_id
    instance_type           = var.ec2_instance_type
    subnet_id               = var.public_subnets[0]
    vpc_security_group_ids  = var.security_group_ids
    associate_public_ip_address = false  # Disable auto public IP (we'll use EIP)
    key_name                = var.key_name

    user_data = file("user_data.sh")

    tags = {
        Name = "Ecommerce-App-Instance"
    }
}

resource "aws_eip" "ecommerce_eip" {
    count         = length(aws_subnet.public)  # Number of EIPs = Number of public subnets
    instance      = aws_instance.app_instance.id # Attach EIP to EC2 instance

  tags = {
    Name = "Ecommerce-eip-${var.azs[count.index]}"
  }
}
resource "tls_private_key" "ssh_key" {
    algorithm   = "RSA"
    rsa_bits    = 2048
}

resource "aws_key_pair" "generated_key" {
    key_name    = var.key_name
    public_key  = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
    content     = tls_private_key.ssh_key.private_key_pem
    filename    = "${var.key_name}.pem"
}

# tls_private_key.ssh_key generates an RSA key pair.

# aws_key_pair.generated_key uploads the public key to AWS under the name "ecommerce-ssh-key".

# local_file.private_key saves the private key locally (ecommerce-ssh-key.pem), but AWS doesn't use this file.

output "private_key" {
  value = local_file.private_key.filename
}