resource "aws_security_group" "Hitachi-DEV" {
  name        = "Hitachi-DEV"
  description = "Hitachi-DEV"
  vpc_id      = "vpc-0258ea71d4876575b"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
	cidr_blocks      = ["0.0.0.0/0"]
  description      = "internal VPC"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Hitachi-DEV"
Environment = "DEV"
Application_Owner = "Hitachi"
Cost_Center = "DEV"
Application_Name = "Web"
Partner_Name = "Hitachi-India"
Department = "Infra"
}
}
