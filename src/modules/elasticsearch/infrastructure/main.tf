resource "aws_lambda_function" "updateElasticsearchIndex" {
  function_name    = "updateElasticsearchIndex"
  filename         = "${path.module}/functions/updateElasticsearchIndex.zip"
  source_code_hash = filebase64sha256("${path.module}/functions/updateElasticsearchIndex.zip")
  handler          = "updateElasticsearchIndex.handler"
  runtime          = "nodejs12.x"
  role             = var.iam_role_arn
  environment {
     variables = {
       elasticsearch_url  = var.elasticsearch_url
       elasticsearch_auth = var.elasticsearch_auth
     }
  }
 }
 resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "Allow_Invocation_from_APIGW"
  action        = "lambda:InvokeFunction"
  function_name = "updateElasticsearchIndex"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.target_api.execution_arn}/*/*/*"
}