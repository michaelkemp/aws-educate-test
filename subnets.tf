############ DEFAULT VPC ############
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

############ INTERNET GATEWAY DATA ############
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

############ DMZ SUBNET ############
resource "aws_subnet" "dmz" {
  vpc_id               = aws_default_vpc.default.id
  availability_zone    = "us-east-1a"
  cidr_block           = "172.31.128.0/24"
  tags = {
    Name = "DMZ"
  }
}

############ PRIVATE SUBNET ############
resource "aws_subnet" "private" {
  vpc_id               = aws_default_vpc.default.id
  availability_zone    = "us-east-1b"
  cidr_block           = "172.31.129.0/24"
  tags = {
    Name = "Private"
  }
}

############ DMZ ROUTE ############
resource "aws_route_table" "dmz" {
  vpc_id = aws_default_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
  tags = {
    Name = "dmz"
  }
}
resource "aws_route_table_association" "dmz" {
  subnet_id      = aws_subnet.dmz.id
  route_table_id = aws_route_table.dmz.id
}

############ PRIVATE ROUTE ############
resource "aws_route_table" "private" {
  vpc_id = aws_default_vpc.default.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.NAT.id
  }
  tags = {
    Name = "private"
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
