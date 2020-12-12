############ AMI ############
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

############ PRIVATE INSTANCE ############
resource "aws_instance" "linux" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t2.micro"
  tags = {
    Name = "Private-Linux"
  }
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.NATSG.id]
  user_data                   = <<-EOF
    #!/bin/bash
    sudo yum update -y && sudo yum upgrade -y
  EOF
}

############ OUTPUT NAT CONNECTION INFO ############
output "information" {
  value = <<-EOF

    # Change key security and log into NAT Instance
    chmod 400 ${aws_key_pair.generated_key.key_name}.pem
    ssh -i ${aws_key_pair.generated_key.key_name}.pem ec2-user@${aws_instance.NAT.public_ip}

    # Open Tunnel through NAT Instance to Private Linux
    ssh -i ${aws_key_pair.generated_key.key_name}.pem ec2-user@${aws_instance.NAT.public_ip} -N -L 10000:${aws_instance.linux.private_ip}:22

    # Use Tunnel
    ssh -i ${aws_key_pair.generated_key.key_name}.pem -p 10000 ec2-user@127.0.0.1

    # SSH to Private Linux Through Tunnel - single command
    ssh -f -i ${aws_key_pair.generated_key.key_name}.pem ec2-user@${aws_instance.NAT.public_ip} -L 10000:${aws_instance.linux.private_ip}:22 sleep 5; \
    ssh -i ${aws_key_pair.generated_key.key_name}.pem -p 10000 ec2-user@127.0.0.1

  EOF
}
