# --- variables used in module
variable "instance_type" {
  description = "Type of instance to start. default (t2.micro)"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The key name to use for the instance."
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument."
}

variable "module_version" {
  type        = "string"
  description = "Identifies the version of the terraform module used for this stack. This value is used to create the 'module_version' resource tag for resources created by this stack item."
}
