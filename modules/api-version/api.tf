resource "aws_api_gateway_resource" "version_resource" {
  rest_api_id = var.target_api.id
  parent_id   = var.target_api.root_resource_id
  path_part   = "_version"
}
resource "aws_api_gateway_method" "version_get" {
  rest_api_id   = var.target_api.id
  resource_id   = aws_api_gateway_resource.version_resource.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "version_integration" {
  rest_api_id             = var.target_api.id
  resource_id             = aws_api_gateway_resource.version_resource.id
  http_method             = aws_api_gateway_method.version_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getApiVersion.invoke_arn
}