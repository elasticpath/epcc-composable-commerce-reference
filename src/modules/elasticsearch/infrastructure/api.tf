data "aws_api_gateway_resource" "store_id" {
  rest_api_id = var.target_api.id
  path        = "/{store_id}"
}
resource "aws_api_gateway_resource" "searches" {
  rest_api_id = var.target_api.id
  parent_id   = data.aws_api_gateway_resource.store_id.id
  path_part   = "searches"
}
resource "aws_api_gateway_resource" "searches_resource_name" {
  rest_api_id = var.target_api.id
  parent_id   = aws_api_gateway_resource.searches.id
  path_part   = "{resource_name}"
}
resource "aws_api_gateway_resource" "searches_resource_name_proxy" {
  rest_api_id = var.target_api.id
  parent_id   = aws_api_gateway_resource.searches_resource_name.id
  path_part   = "{proxy+}"
}
resource "aws_api_gateway_method" "searches_resource_name_proxy_any" {
  rest_api_id         = var.target_api.id
  resource_id         = aws_api_gateway_resource.searches_resource_name_proxy.id
  http_method         = "ANY"
  authorization       = "NONE"
  request_parameters  = {
                          "method.request.path.store_id" = true
                          "method.request.path.resource_name" = true
                          "method.request.path.proxy" = true
                        }
}
resource "aws_api_gateway_integration" "searches_resource_name_proxy_any_integration" {
  rest_api_id             = var.target_api.id
  resource_id             = aws_api_gateway_resource.searches_resource_name_proxy.id
  http_method             = aws_api_gateway_method.searches_resource_name_proxy_any.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "${var.elasticsearch_url}/epcc_{store_id}_{resource_name}/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters      = {
                              "integration.request.path.store_id"         = "method.request.path.store_id"
                              "integration.request.path.resource_name"    = "method.request.path.resource_name"
                              "integration.request.path.proxy"            = "method.request.path.proxy"
                              "integration.request.header.Authorization"  = "'${var.elasticsearch_auth}'"
                            }
}
data "aws_api_gateway_resource" "webhooks" {
  rest_api_id = var.target_api.id
  path        = "/{store_id}/webhooks"
}
resource "aws_api_gateway_resource" "webhooks_search" {
  rest_api_id = var.target_api.id
  parent_id   = data.aws_api_gateway_resource.webhooks.id
  path_part   = "search"
}
resource "aws_api_gateway_resource" "webhooks_search_resource_name" {
  rest_api_id = var.target_api.id
  parent_id   = aws_api_gateway_resource.webhooks_search.id
  path_part   = "{resource_name}"
}
resource "aws_api_gateway_method" "webhooks_search_resource_name_post" {
  rest_api_id         = var.target_api.id
  resource_id         = aws_api_gateway_resource.webhooks_search_resource_name.id
  http_method         = "POST"
  authorization       = "NONE"
  request_parameters  = {
                          "method.request.path.store_id" = true
                          "method.request.path.resource_name" = true
                        }
}
resource "aws_api_gateway_integration" "webhooks_search_resource_name_post_integration" {
  rest_api_id             = var.target_api.id
  resource_id             = aws_api_gateway_resource.webhooks_search_resource_name.id
  http_method             = aws_api_gateway_method.webhooks_search_resource_name_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.updateElasticsearchIndex.invoke_arn
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_parameters      = {
                              "integration.request.path.store_id"         = "method.request.path.store_id"
                              "integration.request.path.resource_name"    = "method.request.path.resource_name"
                            }
}