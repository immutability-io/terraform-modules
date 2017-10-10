# --- variables used in module
variable "ebs_volume_type" {
  description = "The type of EBS volume. Can be standard, gp2, io1, sc1, or st1 (Default: "standard")."
  default     = "standard"
}

variable "ebs_volume_size" {
  description = "The size of the drive in GiBs."
}

variable "ebs_volume_snap_id" {
  description = "A snapshot to base the EBS volume off of."
}

variable "module_version" {
  type        = "string"
  description = "Identifies the version of the terraform module used for this stack. This value is used to create the 'module_version' resource tag for resources created by this stack item."
}
