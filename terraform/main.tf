resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC - Control Tower"
  }
}

resource "aws_security_group" "default-sg" {
  name        = "DEFAULT-SG-ATF"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

## Multi-Region

resource "aws_default_vpc" "default_eu-west-3" {
  provider = aws.eu-west-3
  tags = {
    Name = "Default VPC - Control Tower"
  }
}

resource "aws_security_group" "default-sg-eu-west-3" {
  provider    = aws.eu-west-3
  name        = "DEFAULT-SG-ATF"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default_eu-west-3.id

  ingress {
    description       = "Allow Inner Traffic"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    self              = true
    security_groups   = [aws_security_group.default-sg-eu-west-3.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
