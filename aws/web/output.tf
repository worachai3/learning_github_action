output "aws_instance_http_server_details" {
  value = aws_elb.elb.dns_name
}