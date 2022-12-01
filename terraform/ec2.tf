data "aws_ami" "bastion" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_key_pair" "auth" {
  public_key = file(var.public_key_path)
}


resource "aws_instance" "grumlin" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.bastion.id
  key_name      = aws_key_pair.auth.id

  vpc_security_group_ids = [aws_security_group.grumlin.id]
  subnet_id              = aws_subnet.grumlin1.id
}
