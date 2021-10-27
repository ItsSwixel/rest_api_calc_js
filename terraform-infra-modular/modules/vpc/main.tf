resource "aws_vpc" "cyber94_mod_lcooper_vpc_tf" {
    cidr_block = "10.110.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      Name = "cyber94_mod_lcooper_vpc"
    }
}

resource "aws_route53_zone" "cyber94_mod_lcooper_vpc_dns_tf" {
  name = "cyber-110.sparta"

  vpc {
    vpc_id = aws_vpc.cyber94_mod_lcooper_vpc_tf.id
  }
}
