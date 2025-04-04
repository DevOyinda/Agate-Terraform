resource "aws_vpc" "ecommerce_vpc" {
    cidr_block              = var.vpc_cidr
    enable_dns_support      = true
    enable_dns_hostnames    = true

    tags = {
        Name = "Ecommerce-VPC"
    }
}

# SUBNET    
resource "aws_subnet" "public" {
    count                       = length(var.public_subnets)
    vpc_id                      = aws_vpc.ecommerce_vpc.id
    cidr_block                  = var.public_subnets[count.index]
    availability_zone           = var.azs[count.index]
    map_public_ip_on_launch     = true

    tags = {
        Name = "Ecommerce-Public-${var.azs[count.index]}"
    }
}


resource "aws_subnet" "private" {
    count                       = length(var.private_subnets)
    vpc_id                      = aws_vpc.ecommerce_vpc.id
    cidr_block                  = var.private_subnets[count.index]
    availability_zone           = var.azs[count.index]
    map_public_ip_on_launch     = false

    tags = {
        Name = "Ecommerce-Private-${var.azs[count.index]}"
    }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "gateway" {
    vpc_id = aws_vpc.ecommerce_vpc.id

    tags = {
        Name = "Ecommerce-Internet-Gateway"
    }
}

# Public route table
resource "aws_route_table" "public" {
  count  = length(aws_subnet.public)
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Ecommerce-Public-rt-${var.azs[count.index]}"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}



# NAT Gateways (one per public subnet)
resource "aws_nat_gateway" "nat"{
  count         = length(aws_subnet.public)
  allocation_id = module.ec2.eip_public_ip[count.index].id   # aws_eip.ecommerce_eip.public_ip
  subnet_id     = aws_subnet.public[count.index].id
  connectivity_type  = "public"

  tags = {
    Name    = "Ecommerce-nat-${var.azs[count.index]}"
  }
}

# Create a private route table per private subnet using the NAT Gateway in the same AZ
resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id # Dynamically reference the NAT Gateway
  }

  tags = {
    Name = "Ecommerce-private-rt-${var.azs[count.index]}"
  }
}

# Associate private subnets with their route tables
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}



# security group
resource "aws_security_group" "app_sg" {
    vpc_id      = var.vpc_id
    name        = "app_sg"
    description = "Allow inbound traffic for the app"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "Allow HTTPs traffic from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "Ecommerce-Security-Group"
    }
}



