# Creates a /25 VPC
resource "aws_vpc" "test-tf-vpc" {
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "test-tf-vpc",
    Owner = "Zubayr"
  }
}

# Creates a public subnet within VPC above
resource "aws_subnet" "test-tf-subnet-az1" {
  vpc_id     = aws_vpc.test-tf-vpc.id
  cidr_block = aws_vpc.test-tf-vpc.cidr_block
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"

  tags = {
    Name = "test-tf-subnet-az1"
    Owner = aws_vpc.test-tf-vpc.tags.Owner
  }
} 

# Creates a Security Group for EC2 to use
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.test-tf-vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.test-tf-vpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = local.default
  ip_protocol       = "-1" # semantically equivalent to all ports
} 