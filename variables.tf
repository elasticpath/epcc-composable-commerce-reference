variable "aws_region" {
    default = "us-west-2"
}
variable "create_deployment" {
  description   = "Whether to create an API deployment stage or not."
  type          = bool
  default       = false
}