# ================================================================================
# REQUIRED PARAMETERS
# ================================================================================
variable "target_api" {
  description   = "Existing target API to attach new API resources to"
  type          = object({
                    id = string
                    root_resource_id = string
                    execution_arn = string
                  })
}
variable "elasticsearch_url" {
    description = "Elasticsearch cluster HTTPS endpoint"
    type        = string
}
variable "elasticsearch_auth" {
    description = "Authorization header value for Elasticsearch ('user:passw0rd' must be Base64 encoded), e.g. 'Basic aHpDYlg5cmF4azhaG7GhsgFTjdUSmNqYlgyd0Fz'"
    type        = string
}
variable "iam_role_arn" {
  description   = "The IAM role's ARN to execute the lambda functions with."
  type          = string
}

# ================================================================================
# OPTIONAL PARAMETERS
# ================================================================================
# None