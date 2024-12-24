
resource "aws_security_group" "sg" {
  name  = "${var.tool_name}-sg"
  description = "Inbound allow for ${var.tool_name}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = var.sg_port
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.key
    }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.tool_name}-sg"
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
  root_block_device {
    volume_size = var.volume_size
  }
  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type = "persistent"
    }
  }
  iam_instance_profile = length(var.policy_list) > 0 ? aws_iam_instance_profile.instance_profile[0].name : null
}
#
# resource "null_resource" "ansible-pull" {
#   provisioner "remote-exec" {
#     connection {
#       type     = "ssh"
#       user     = data.vault_generic_secret.ssh.data["username"]
#       password = data.vault_generic_secret.ssh.data["password"]
#       host     = aws_instance.instance.private_ip
#     }
#     inline = [
#       "sudo labauto ansible",
#       "ansible-pull -i localhost, -U  https://github.com/roboshop-ansible roboshop.yml -e env=${var.env} -e app_name=${var.component_name}",
#
#     ]
#   }
# }
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

