resource "aws_security_group" "sg" {
  name              = "${var.component_name}-${var.env}-sg"
  ingress {
    from_port        = var.app_port
    to_port          = var.app_port
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
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "${var.component_name}-${var.env}"
  }
}

  //using self beacuse we are provisioning in the same resource
# provisioner "local-exec" {
#   command = <<EOL
#   cd /home/ec2-user/roboshop-ansible
#   ansible-playbook -i ${self.private_ip},-e ansible_user=ec2-user ansible_password=DevOps321 -e app_name=${var.component_name} -e env=${var.env} roboshop.yml
#    EOL
#   }

resource "null_resource" "ansible-pull"{
  provisioner "remote-exec" {
      connection {
        type     = "ssh"
        user     = "ec2-user"
        password = "DevOps321"
        host     = aws_instance.instance.private_ip
      }
      inline = [
        "sudo labauto ansible",
        "ansible-pull -i localhost, -U https://github.com/shivanandhan/roboshop-terraform/tree/main/roboshop-ansible main.yml -e env=${var.env} -e app_name=${var.component_name}"
      ]
    }
  }

resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = "${var.component_name}-${var.env}.${var.domain_name}"
  type    = "A"
  ttl     = "30"
  records = [aws_instance.instance.private_ip]
}






