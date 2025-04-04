variable "aws_region" {
    description = "AWS region to deploy resources"
    default     = "us-east-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}


variable "ec2_instance_type" {
    description = "AWS EC2 instance type"
    default     = "t2.micro"
}

variable "ami_id" {
    description = "Amazon Linux 2023 AMI ID"
    default     = "ami-0efc43a4067fe9a3e"
}

variable "key_name" {
    description = " SSH key pair name"
    default     = " ecommerce-ssh-keypair"
}