resource "aws_instance" "ansible_server" {
  ami                         = "ami-0d3c032f5934e1b41"
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_1_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = "ansible-key"

  tags = {
    Name = "ansible-server"
  }
}
