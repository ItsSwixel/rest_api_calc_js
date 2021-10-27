resource "aws_subnet" "cyber94_mod_lcooper_subnet_web_tf" {
    vpc_id = var.var_aws_vpc_id
    cidr_block = "10.110.1.0/24"

    tags = {
      Name = "cyber94_mod_lcooper_subnet_web"
    }
}
