resource "aws_api_gateway_rest_api" "epcc" {
  name        = "EPCC"
  body        = templatefile("api/epcc-proxy-swagger.yaml", {
                  # Define variables here if needed:
                  # aws_region = var.aws_region
                })
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}
resource "aws_api_gateway_deployment" "epcc_dev_deployment" {
  count = var.create_deployment ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.epcc.id
  stage_name  = "dev"
  lifecycle {
    create_before_destroy = true
  }
}