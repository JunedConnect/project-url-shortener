resource "aws_security_group" "this" {
  name        = var.name
  description = var.name
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc" "this" {
  cidr_block = var.vpc-cidr-block

  enable_dns_support   = var.enable-dns-support
  enable_dns_hostnames = var.enable-dns-hostnames
}


resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.publicsubnet1-cidr-block
  map_public_ip_on_launch = var.subnet-map-public-ip-on-launch
  availability_zone       = var.availability-zone-1

}


resource "aws_subnet" "publicsubnet2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.publicsubnet2-cidr-block
  map_public_ip_on_launch = var.subnet-map-public-ip-on-launch
  availability_zone       = var.availability-zone-2

}


resource "aws_subnet" "privatesubnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.privatesubnet1-cidr-block
  availability_zone = var.availability-zone-1

}


resource "aws_subnet" "privatesubnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.privatesubnet2-cidr-block
  availability_zone = var.availability-zone-2

}

# the below nat-gateway is no longer needed as I have set up VPC Endpoints that will handle internal access to AWS Services
# resource "aws_nat_gateway" "ng" {
#   subnet_id     = aws_subnet.publicsubnet1.id
#   allocation_id = aws_eip.eip.id
# }

# the below eip is no longer needed as I have set up VPC Endpoints that will handle internal access to AWS Services
# resource "aws_eip" "eip" {
# }


resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.this.id
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = var.route-cidr-block
    gateway_id = aws_internet_gateway.ig.id
  }
}


resource "aws_route_table_association" "public-rta1" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "public-rta2" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.this.id
  # the below route is no longer needed as I have set up VPC Endpoints that will handle internal access to AWS Services
  # route {
  #   cidr_block = var.route-cidr-block
  #   gateway_id = aws_nat_gateway.ng.id
  # }
}


resource "aws_route_table_association" "private-rta1" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_route_table_association" "private-rta2" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_security_group" "vpc-endpoint" {
  name        = "vpc-endpoint"
  description = "vpc-endpoint"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.this.id]
  }
}
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-west-2.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private-rt.id]
}
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private-rt.id]
}
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-west-2.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privatesubnet1.id, aws_subnet.privatesubnet2.id]
  security_group_ids = [aws_security_group.vpc-endpoint.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-west-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privatesubnet1.id, aws_subnet.privatesubnet2.id]
  security_group_ids = [aws_security_group.vpc-endpoint.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-west-2.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.privatesubnet1.id, aws_subnet.privatesubnet2.id]
  security_group_ids = [aws_security_group.vpc-endpoint.id]
  private_dns_enabled = true
}