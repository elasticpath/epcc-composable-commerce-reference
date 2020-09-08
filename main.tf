# ================================================================================
# AWS
# ================================================================================
provider "aws" {
   region = var.aws_region
}
data "aws_caller_identity" "current" {}

# ================================================================================
# IAM
# ================================================================================
resource "aws_iam_role" "epcc_lambda_execution" {
  name = "EPCC-Lambda-Execution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole", 
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# ================================================================================
# API GATEWAY
# ================================================================================
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