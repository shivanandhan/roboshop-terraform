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
  //using self beacuse we are provisioning in the same resource
provisioner "local-exec" {
  command = <<EOL
  cd /home/ec2-user/roboshop-ansible
  ansible-playbook -i ${self.private_ip},-e ansible_user=ec2-user ansible_password=DevOps321 -e app_name=${var.component_name} -e env=${var.env} main.yml
   EOL
  }
}


