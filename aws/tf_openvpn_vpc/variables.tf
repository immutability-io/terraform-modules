variable "aws_profile" { default = "zambien" }
variable "aws_region" { default = "us-east-1" }
variable "vpn_name" { default = "default" }
variable "vpn_user" { default = "user1" }
variable "vpn_password" { default = "youmightwanttochangeit" }

variable "module_version" {
  type        = "string"
  description = "Identifies the version of the terraform module used for this stack. This value is used to create the 'module_version' resource tag for resources created by this stack item."
  default     = "0.0.1"
}

variable "stack_item_fullname" {
  type        = "string"
  description = "Long form descriptive name for this stack item. This value is used to create the 'application' resource tag for resources created by this stack item."
  default     = "OpenVPN VPC Quick Start"
}

variable "stack_item_label" {
  type        = "string"
  description = "Short form identifier for this stack. This value is used to create the 'Name' resource tag for resources created by this stack item, and also serves as a unique key for re-use."
  default     = "openvpn_qckstrt"
}

variable "keyfile_name" {
  type        = "string"
  description = "SSH keyfile name"
  default = "ec2-key"
}

variable "provision_test_instance" { default = "false" }