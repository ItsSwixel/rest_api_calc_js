output "output_aws_vpc_id" {
  value = aws_vpc.cyber94_mod_lcooper_vpc_tf.id
}

output "output_dns_zone_id" {
  value = aws_route53_zone.cyber94_mod_lcooper_vpc_dns_tf.zone_id
}
