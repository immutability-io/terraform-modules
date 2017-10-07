# --- https://www.terraform.io/docs/providers/aws/d/caller_identity.html
# --- this does create resource updates whenever a plan is called.  I can live with it.
data "aws_caller_identity" "current" {}

# --- https://www.terraform.io/docs/providers/aws/r/ebs_volume.html
resource "aws_ebs_volume" "create_ebs_module" {
    encrypted         = "true"
    type              = "${var.mod_ebs_type}"
    size              = "${var.mod_ebs_size}"
    snapshot_id       = "${var.mod_ebs_use_snap}"
    availability_zone = "${var.mod_ebs_az}"
    tags {
      account_id = "${data.aws_caller_identity.current.account_id}"
      caller_arn = "${data.aws_caller_identity.current.arn}"
      caller_id  = "${data.aws_caller_identity.current.user_id}"
      terraform  = "true"
    }
}
