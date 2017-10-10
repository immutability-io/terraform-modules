# DHCP Options

## Set Terraform version constraint
terraform {
  required_version = "> 0.10.0"
}

data "aws_caller_identity" "current" {}

## Provisions DHCP options
resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name          = "${var.domain_name}"
  domain_name_servers  = ["${compact(var.name_servers)}"]
  netbios_name_servers = ["${compact(var.netbios_name_servers)}"]
  netbios_node_type    = "${var.netbios_node_type}"
  ntp_servers          = ["${compact(var.ntp_servers)}"]

  tags {
    module_version = "${var.module_version}"
    application = "${var.stack_item_fullname}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    caller_arn = "${data.aws_caller_identity.current.arn}"
    caller_id  = "${data.aws_caller_identity.current.user_id}"
    terraform  = "true"
    Name        = "${var.stack_item_label}-dhcp"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp.id}"
  vpc_id          = "${var.vpc_id}"
}
