# ================================================================================
# REQUIRED PARAMETERS
# ================================================================================
variable "target_api" {
  description = "Existing target API to attach new API resources to"
  type        = object({
                  id = string
                  root_resource_id = string
                  execution_arn = string
                })
}
variable "api_version" {
  description = "The API version"
  type        = string
}
variable "api_deployed_at" {
  description = "Timestamp (or similar) of last API deployment"
  type        = string
}
variable "iam_role_arn" {
  description = "The IAM role's ARN to execute the lambda function with."
  type        = string
}