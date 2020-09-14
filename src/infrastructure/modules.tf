module "api-version" {
    source                = "./modules/api-version"
    target_api            = aws_api_gateway_rest_api.epcc
    api_version           = var.api_version
    api_deployed_at       = timestamp()
    iam_role_arn          = aws_iam_role.epcc_lambda_execution.arn
}
module "elasticsearch-integration" {
    source                = "./modules/elasticsearch"
    target_api            = aws_api_gateway_rest_api.epcc
    elasticsearch_url     = var.elasticsearch_url
    elasticsearch_auth    = var.elasticsearch_auth
    iam_role_arn          = aws_iam_role.epcc_lambda_execution.arn
}