provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "cyber94-calc-lcooper-bucket"
    key = "tfstate/calc/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "cyber94_calc_lcooper_dynamodb_table_lock"
    encrypt = true
  }
}

# VPC
# @component CalcApp:VPC (#vpc)
resource "aws_vpc" "cyber94_mini_lcooper_vpc_tf" {
    cidr_block = "10.110.0.0/16"

    tags = {
      Name = "cyber94_mini_lcooper_vpc"
    }
}

# Internet gateway
resource "aws_internet_gateway" "cyber94_mini_lcooper_IG_tf" {
  vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id
  tags = {
    Name = "cyber94_mini_lcooper_IG"
  }
}

# Subnets
# @component CalcApp:VPC:Subnet (#subnet)
# @connects #vpc to #subnet with Network
# @connects #subnet to #web_server with Network
# @connects #subnet to #web_server2 with Network
# @connects #subnet to #proxy with Network
resource "aws_subnet" "cyber94_mini_lcooper_subnet_app_tf" {
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id
    cidr_block = "10.110.1.0/24"

    tags = {
      Name = "cyber94_mini_lcooper_subnet_app"
    }
}

# Routing
resource "aws_route_table" "cyber94_mini_lcooper_routing_tf" {
  vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id

  tags = {
    Name = "cyber94_mini_lcooper_routing"
  }
}

resource "aws_route" "cyber95_mini_lcooper_internet_route_tf" {
    route_table_id = aws_route_table.cyber94_mini_lcooper_routing_tf.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_mini_lcooper_IG_tf.id
}

resource "aws_route_table_association" "cyber94_mini_lcooper_app-association_tf" {
    subnet_id = aws_subnet.cyber94_mini_lcooper_subnet_app_tf.id
    route_table_id = aws_route_table.cyber94_mini_lcooper_routing_tf.id
}


# Security Groups
resource "aws_security_group" "cyber94_mini_lcooper_sg_app_tf" {
    name = "cyber94_mini_lcooper_sg_app"
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "cyber94_mini_lcooper_sg_app"
    }
}

resource "aws_security_group" "cyber94_mini_lcooper_sg_proxy_tf" {
    name = "cyber94_mini_lcooper_sg_proxy"
    vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id

    ingress {
      from_port = 80
      to_port = 80
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
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "cyber94_mini_lcooper_sg_proxy"
    }
}

# NACLs
resource "aws_network_acl" "cyber94_mini_lcooper_nacl_app_tf" {
  vpc_id = aws_vpc.cyber94_mini_lcooper_vpc_tf.id
  subnet_ids = [aws_subnet.cyber94_mini_lcooper_subnet_app_tf.id]

  ingress {
    rule_no = 100
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  ingress {
    rule_no = 200
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  ingress {
    rule_no = 300
    protocol = "tcp"
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  egress {
    rule_no = 100
    protocol = "tcp"
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  egress {
    rule_no = 200
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  egress {
    rule_no = 300
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    action = "allow"
  }

  egress {
    rule_no = 400
    protocol = "tcp"
    from_port = 3306
    to_port = 3306
    cidr_block = "10.110.2.0/24"
    action = "allow"
  }

  tags = {
    Name = "cyber94_mini_lcooper_nacl_app"
  }
}


# Instances
# @component CalcApp:Web:Server:App (#web_server)
# @component CalcApp:Web:Server:App2 (#web_server2)


# @threat SQL Injection (#sqli)
# @exposes #web_server to #sqli with not validating inputs
# @control Input Validation (#iv)
# @mitigates #web_server against #sqli with #iv

# @threat Cross-site Scripting (#xss)
# @exposes #web_server to #xss with embedding input data into the HTML or JavaScript
# @mitigates #web_server against #xss with #iv

# @exposes #web_server2 to #sqli with not validating inputs
# @mitigates #web_server2 against #sqli with #iv

# @exposes #web_server2 to #xss with embedding input data into the HTML or JavaScript
# @mitigates #web_server2 against #xss with #iv

resource "aws_instance" "cyber94_mini_lcooper_app_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cyber94_mini_lcooper_sg_app_tf.id]
  subnet_id = aws_subnet.cyber94_mini_lcooper_subnet_app_tf.id
  associate_public_ip_address = true
  key_name = "cyber94-lcooper"

  tags = {
    Name = "cyber94_mini_lcooper_app"
  }

  lifecycle {
    create_before_destroy = true
  }

  # Just to make sure that terraform won't continue to local-exec before the server is up
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-lcooper.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "pwd"
    ]
  }

  provisioner "local-exec" {
    working_dir = "../ansible"
    command = "ansible-playbook -i ${self.public_ip}, -u ubuntu app-playbook.yaml"
  }subnet

/*
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/kali/.ssh/cyber94-lcooper.pem")
  }

  provisioner "file" {
    source = "../init-scripts/docker-install.sh"
    destination = "/home/ubuntu/docker-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 777 /home/ubuntu/docker-install.sh",
      "/home/ubuntu/docker-install.sh"
    ]
  }*/
}

# @component CalcApp:Web:Server:Proxy (#proxy)
# @connects #proxy to #calcpage with HTTPS/GET-Request
# @connects #calcpage to #proxy with HTTPS/GET-Response
resource "aws_instance" "cyber94_mini_lcooper_proxy_tf" {
  ami = "ami-0943382e114f188e8"
  instance_type = "t2.micro"
  key_name = "cyber94-lcooper"
  vpc_security_group_ids = [aws_security_group.cyber94_mini_lcooper_sg_proxy_tf.id]
  subnet_id = aws_subnet.cyber94_mini_lcooper_subnet_app_tf.id
  associate_public_ip_address = true

  tags = {
    Name = "cyber94_mini_lcooper_proxy"
  }
}

# @component External:Developer Browser (#browser)
# @component CICD:Service:Jenkins (#jenkins)
# @connects #browser to #jenkins with HTTPS/GET-Request
# @connects #jenkins to #browser with HTTP/GET-Response
# @component GitHub (#git)
# @component Dockerhub (#docker)
# @connects #jenkins to #git with HTTP/GET-Request
# @connects #git to #jenkins with HTTP/GET-Response
# @connects #jenkins to #docker with Docker Push HTTP
# @connects #docker to #web_server with HTTP/GET-Request
# @connects #web_server to #docker with HTTP/GET-Response
# @connects #docker to #web_server2 with HTTP/GET-Request
# @connects #web_server2 to #docker with HTTP/GET-Response
