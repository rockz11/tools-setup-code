terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
resource "aws_security_group" "sg" {
  name  = "${var.tool_name}-sg"
  description = "Inbound allow for ${var.tool_name}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = var.sg_port
    to_port          = var.sg_port
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "instance" {
  # count deals with the list and for_each deals with the map.
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = var.tool_name

  }
}

#resource "null_resource" "ansible-pull" {

 # provisioner "remote-exec" {
  #  connection {
   #   type = "ssh"
    #  user = "ec2-user"
     # password = "DevOps321"
      #host = aws_instance.instance.private_ip
    #}
    #inline = [
     # "sudo labauto ansible",
     # "ansible-pull -i localhost, -U  https://github.com/roboshop-ansible roboshop.yml -e env=${var.env} -e app_name=${var.component_name}",

  #  ]
  #}

resource "aws_route53_record" "record-public" {
  zone_id = var.zone_id
  ttl     = "30"
  name    = "${var.tool_name}.${var.domain_name}"
  records = [aws_instance.instance.public_ip]
  type    = "A"
}
resource "aws_route53_record" "record-internal" {
  zone_id = var.zone_id
  ttl     = "30"
  name    = "${var.tool_name}-internal.${var.domain_name}"
  records = [aws_instance.instance.private_ip]
  type    = "A"

}

