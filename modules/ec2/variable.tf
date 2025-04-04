variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "The security group IDs to assign to EC2 instances and load balancers"
  type        = list(string)
}


variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
