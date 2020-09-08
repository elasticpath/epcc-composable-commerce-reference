resource "aws_lambda_function" "getApiVersion" {
  function_name    = "getApiVersion"
  filename         = "${path.module}/functions/getApiVersion.zip"
  source_code_hash = filebase64sha256("${path.module}/functions/getApiVersion.zip")
  handler          = "getApiVersion.handler"
  runtime          = "nodejs12.x"
  role             = var.iam_role_arn
  environment {
     variables = {
       api_version  = var.api_version
       api_deployed_at = var.api_deployed_at
     }
  }
}
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "Allow_Invocation_from_APIGW"
  action        = "lambda:InvokeFunction"
  function_name = "getApiVersion"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.target_api.execution_arn}/*/*/*"
}