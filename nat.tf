############ GET MY IP ############
data "external" "ipify" {
  program = ["curl", "-s", "https://api.ipify.org?format=json"]
}

############ SSH FROM MY IP SECURITY GROUP ############
resource "aws_security_group" "SSH" {
  name        = "SSH"
  description = "SSH Security Group"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${data.external.ipify.result.ip}/32"]
    description = "SSH From My IP"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############ NAT SECURITY GROUP ############
resource "aws_security_group" "NATSG" {
  name        = "NATSG"
  description = "NATSG Security Group"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Self Referencing"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############ AMAZON LINUX NAT AMI ############
data "aws_ami" "amazon-nat" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-2018.03*"]
  }
}

############ NAT EC2 ############
resource "aws_instance" "NAT" {
  ami           = data.aws_ami.amazon-nat.id
  instance_type = "t2.micro"
  tags = {
    Name = "NAT"
  }
  subnet_id                   = aws_subnet.dmz.id
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.NATSG.id, aws_security_group.SSH.id]
  user_data                   = <<-EOF
    #!/bin/bash
    sudo yum update -y && sudo yum upgrade -y
  EOF
}
