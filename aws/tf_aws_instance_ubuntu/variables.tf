# --- variables used in module
variable "instance_type" {
  description = "Type of instance to start. default (t2.micro)"
  default     = "t2.micro"
}


# --- variables for providers
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
