# Peering Connection

## Set Terraform version constraint
terraform {
  required_version = "> 0.10.0"
}

data "aws_caller_identity" "current" {}

## Provisions VPC peering
resource "aws_vpc_peering_connection" "peer" {
  count = "${length(var.vpc_peering_connection_id) > 0 ? "0" : "1"}"

  auto_accept   = "${length(var.accepter_owner_id) > 0 ? "false" : "true"}"
  peer_owner_id = "${var.accepter_owner_id}"
  peer_vpc_id   = "${var.accepter_vpc_id}"
  vpc_id        = "${var.requester_vpc_id}"

  accepter {
    allow_classic_link_to_remote_vpc = "${var.accepter_allow_classic_link_to_remote}"
    allow_remote_vpc_dns_resolution  = "${var.accepter_allow_remote_dns}"
    allow_vpc_to_remote_classic_link = "${var.accepter_allow_to_remote_classic_link}"
  }

  requester {
    allow_classic_link_to_remote_vpc = "${var.requester_allow_classic_link_to_remote}"
    allow_remote_vpc_dns_resolution  = "${var.requester_allow_remote_dns}"
    allow_vpc_to_remote_classic_link = "${var.requester_allow_to_remote_classic_link}"
  }

  tags {
    module_version = "${var.module_version}"
    application = "${var.stack_item_fullname}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    caller_arn = "${data.aws_caller_identity.current.arn}"
    caller_id  = "${data.aws_caller_identity.current.user_id}"
    terraform  = "true"
    Name        = "${var.stack_item_label}-peer"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  count = "${length(var.vpc_peering_connection_id) > 0 ? "1" : "0"}"

  auto_accept               = "${var.accepter_auto_accept}"
  vpc_peering_connection_id = "${var.vpc_peering_connection_id}"

  accepter {
    allow_classic_link_to_remote_vpc = "${var.accepter_allow_classic_link_to_remote}"
    allow_remote_vpc_dns_resolution  = "${var.accepter_allow_remote_dns}"
    allow_vpc_to_remote_classic_link = "${var.accepter_allow_to_remote_classic_link}"
  }

  requester {
    allow_classic_link_to_remote_vpc = "${var.requester_allow_classic_link_to_remote}"
    allow_remote_vpc_dns_resolution  = "${var.requester_allow_remote_dns}"
    allow_vpc_to_remote_classic_link = "${var.requester_allow_to_remote_classic_link}"
  }

  tags {
    module_version = "${var.module_version}"
    application = "${var.stack_item_fullname}"
    account_id = "${data.aws_caller_identity.current.account_id}"
    caller_arn = "${data.aws_caller_identity.current.arn}"
    caller_id  = "${data.aws_caller_identity.current.user_id}"
    terraform  = "true"
    Name        = "${var.stack_item_label}-peer"
  }
}
