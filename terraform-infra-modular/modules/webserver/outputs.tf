output "output_webserver_ip_address" {
  value = aws_instance.cyber94_mod_lcooper_webserver_tf.*.public_ip
}
