resource "aws_vpc" "grumlin" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "grumlin" {
  vpc_id = aws_vpc.grumlin.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.grumlin.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.grumlin.id
}

resource "aws_subnet" "grumlin1" {
  vpc_id                  = aws_vpc.grumlin.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
}

resource "aws_subnet" "grumlin2" {
  vpc_id                  = aws_vpc.grumlin.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1b"
}

resource "aws_neptune_subnet_group" "grumlin" {
  name       = "grumlin"
  subnet_ids = [aws_subnet.grumlin1.id, aws_subnet.grumlin2.id]
}

resource "aws_security_group" "grumlin" {
  name   = "grumlin"
  vpc_id = aws_vpc.grumlin.id

  ingress {
    from_port = 8182
    to_port   = 8182
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}