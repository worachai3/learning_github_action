provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_key_pair" "default-ec2-public" {
  key_name   = "default-ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLzRi9/hdhI2FGGiNAlFSc9z3Gchw2XiwXu1uyDGtp50iwWx4jLawU6vQv1z9sAjsYn88g7NTlsy5AgIqobEjxbQuFqWriTddIGblguDK7Zebkq3wr3niVPnqhhwuVrAmQ5NG5MUyOFnFf/SkOQ0/2M/OkMQiSK6DBdKt7+RPPjWE9xI2zSQQ1PEMPNr14Ptx+tGWCG9CuwqyGtkqUOlAELIroVe4CvqDelxQEDFQpS4J33v2G48ge+BOAoUYBxUCqxdTgj2Rc8t1hDqhmPl8Iz/jcBJoZzET5xM6S7HdozqSg/d2xewy+Rknml94qPh/D1U3w/iGNBeuiRCBAWg4tkRowVO2nRKIOTU4cMWMl8BY7Uk+c1cx1MPgL18YcrvCyFNOyWgY8bPFpHQ6uM6dfFGgtXDEyGLUXomknC29jnojdE081nTUndtDKUk3gZRb+FkTCAamI9Gx92CtSOTFZYzqGoANKQOzRCqp6o8NkeeuIUa5nGZFzm8gxb0DTQjc= worachai.wuttiworachairung@TXM092215A"
}

// HTTP Server -> SG
// SG -> -> 80 TCP, SSH -> 22 TCP, CIDR ["0.0.0.0/0"] means allow all

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http_server_sg"
  }
}


resource "aws_security_group" "elb_sg" {
  name   = "elb_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "elb" {
  name            = "elb"
  subnets         = data.aws_subnets.default_subnets.ids
  security_groups = [aws_security_group.elb_sg.id]
  instances       = values(aws_instance.http_server).*.id

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]

  for_each  = toset(data.aws_subnets.default_subnets.ids)
  subnet_id = each.value
  # subnet_id = data.aws_subnets.default_subnets.ids[0]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_private_key)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                                //install httpd
      "sudo service httpd start",                                                                                 //start httpd
      "echo Welcome to in28minutes - Virtual Server is at ${self.public_dns} | sudo tee /var/www/html/index.html" //copy a file
    ]
  }
}

