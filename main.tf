provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  ami           = "ami-03fa4afc89e4a8a09"
  instance_type = "t2.micro"
  subnet_id     = "subnet-fd0257b1"
  key_name      = "awskey"
  vpc_security_group_ids = [aws_security_group.tf-sg-demo.id]
  user_data =  <<-EOF
                 #! /bin/bash
                 yum update -y
                 yum install -y httpd
                 systemctl start httpd.service
                 systemctl enable httpd.service
                 echo "Welcome to ec2 Terraform Demo" >/var/www/html/index.html
                 EOF
}

resource "aws_security_group" "tf-sg-demo" {
  name = "tf-sg-demo"
}


resource "aws_security_group_rule" "allow-http" {
  type        = "ingress"
  from_port   = "80"
  to_port     = "80"
  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "TCP"
  security_group_id = aws_security_group.tf-sg-demo.id  
}


resource "aws_security_group_rule" "allow-all"{
    type = "egress"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
    security_group_id = aws_security_group.tf-sg-demo.id
}


resource "aws_security_group_rule" "allow-ssh"{
    type = "ingress"
    from_port = "22"
    to_port = "22"
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.tf-sg-demo.id
}


output "public_ip"{
    value = aws_instance.ec2.public_ip
}