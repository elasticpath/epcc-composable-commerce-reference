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