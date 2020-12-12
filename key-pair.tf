############ CREATE KEY ############
resource "tls_private_key" "my-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

############ CREATE KEY PAIR ############
resource "aws_key_pair" "generated_key" {
  key_name   = "my-key"
  public_key = tls_private_key.my-key.public_key_openssh
}

############ DOWNLOAD PEM ############
resource "local_file" "write-key" {
  content  = tls_private_key.my-key.private_key_pem
  filename = "${path.module}/my-key.pem"
}
