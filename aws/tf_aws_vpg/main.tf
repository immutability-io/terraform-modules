# Virtual Private Gateway

## Set Terraform version constraint
terraform {
  required_version = "> 0.10.0"
}

data "aws_caller_identity" "current" {}


## Gateway configuration
resource "aws_vpn_gateway" "vpg" {
  availability_zone = "${var.availability_zone}"

  tags {
    application = "${var.stack_item_fullname}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    caller_arn = "${data.aws_caller_identity.current.arn}"
    caller_id  = "${data.aws_caller_identity.current.user_id}"
    terraform  = "true"
    Name        = "${var.stack_item_label}-vpg"
  }
}

resource "aws_vpn_gateway_attachment" "attach" {
  count = "${length(var.vpc_attach) > 0 && var.vpc_attach == "true" ? 1 : 0}"

  vpc_id         = "${var.vpc_id}"
  vpn_gateway_id = "${aws_vpn_gateway.vpg.id}"
}
