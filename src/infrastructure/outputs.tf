output "api_endpoint" {
  value = "${var.create_deployment ? aws_api_gateway_deployment.epcc_dev_deployment[0].invoke_url : "(pending)"}"
}