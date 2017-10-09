# --- https://www.terraform.io/docs/providers/aws/d/caller_identity.html
# --- this does create resource updates whenever a plan is called.  I can live with it.
data "aws_caller_identity" "current" {}

# --- https://www.terraform.io/docs/providers/aws/r/ebs_volume.html
resource "aws_ebs_volume" "create_ebs_module" {
    encrypted         = "true"
    type              = "${var.ebs_volume_type}"
    size              = "${var.ebs_volume_size}"
    snapshot_id       = "${var.ebs_volume_snap_id}"
    availability_zone = "${var.ebs_volme_az}"
    tags {
      account_id = "${data.aws_caller_identity.current.account_id}"
      caller_arn = "${data.aws_caller_identity.current.arn}"
      caller_id  = "${data.aws_caller_identity.current.user_id}"
      terraform  = "true"
    }
}
