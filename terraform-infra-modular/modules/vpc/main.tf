resource "aws_vpc" "cyber94_mod_lcooper_vpc_tf" {
    cidr_block = "10.110.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "cyber94_mod_lcooper_vpc"
    }
}

resource "aws_internet_gateway" "cyber94_mod_lcooper_IG_tf" {
  vpc_id = aws_vpc.cyber94_mod_lcooper_vpc_tf.id
  tags = {
    Name = "cyber94_mod_lcooper_IG"
  }
}

resource "aws_route_table" "cyber94_mod_lcooper_routing_tf" {
  vpc_id = aws_vpc.cyber94_mod_lcooper_vpc_tf.id

  tags = {
    Name = "cyber94_mod_lcooper_routing"
  }
}

resource "aws_route" "cyber94_mod_lcooper_internet_route_tf" {
    route_table_id = aws_route_table.cyber94_mod_lcooper_routing_tf.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cyber94_mod_lcooper_IG_tf.id
}

resource "aws_route53_zone" "cyber94_mod_lcooper_vpc_dns_tf" {
  name = "cyber-lcooper.sparta"

  vpc {
    vpc_id = aws_vpc.cyber94_mod_lcooper_vpc_tf.id
  }
}
