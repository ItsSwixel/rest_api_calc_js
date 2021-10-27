resource "aws_instance" "cyber94_mod_lcooper_webserver_tf" {
  ami = var.var_aws_ami_ubuntu_1804
  vpc_security_group_ids = [aws_security_group.cyber94_mod_lcooper_sg_webserver_tf.id]
  instance_type = "t2.micro"
  key_name = var.var_ssh_key_name
  subnet_id = var.var_web_subnet_id
  associate_public_ip_address = true
  count = 2

  user_data = templatefile("../init-scripts/docker-install.sh", {SPECIAL_ARG="This is an argument from terraform"})
  tags = {
    Name = "cyber94_mod_lcooper_webserver_${count.index}"
  }
}

resource "aws_route53_record" "cyber94_mod_lcooper_webserver_dns_tf" {
  zone_id = var.var_dns_zone_id
  name = "www"
  type = "A"
  ttl = "30"
  records = aws_instance.cyber94_mod_lcooper_webserver_tf.*.public_ip
}

resource "aws_security_group" "cyber94_mod_lcooper_sg_webserver_tf" {
    name = "cyber94_mod_lcooper_sg_webserver"
    vpc_id = var.var_aws_vpc_id

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "cyber94_mod_lcooper_sg_webserver"
    }
}
