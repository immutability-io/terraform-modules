provider "aws" {
  region = "us-east-1"
  profile = "${var.aws_profile}"
}

data "aws_ami" "nomad_consul" {
  most_recent = true

  # If we change the AWS Account in which test are run, update this value.
  owners = ["562637147889"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "is-public"
    values = ["true"]
  }

  filter {
    name   = "name"
    values = ["nomad-consul-ubuntu-*"]
  }
}

module "nomad_servers" {
  source  = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.4.1"

  cluster_name  = "${var.nomad_server_cluster_name}"
  instance_type = "t2.micro"

  # You should typically use a fixed size of 3 or 5 for your Nomad server cluster
  min_size         = "${var.num_nomad_servers}"
  max_size         = "${var.num_nomad_servers}"
  desired_capacity = "${var.num_nomad_servers}"

  ami_id    = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"
  user_data = "${data.template_file.user_data_nomad_server.rendered}"

  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = "${data.terraform_remote_state.vpc_remote_state.private_subnets}"

  # To make testing easier, we allow requests from any IP address here but in a production deployment, we strongly
  # recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = "${var.ssh_key_name}"
}

module "consul_iam_policies_servers" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.1"

  iam_role_id = "${module.nomad_servers.iam_role_id}"
}

data "template_file" "user_data_nomad_server" {
  template = "${file("${path.module}/user-data-nomad-server.sh")}"

  vars {
    num_servers       = "${var.num_nomad_servers}"
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.consul_cluster_name}"
  }
}

module "consul_servers" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-cluster?ref=v0.3.1"

  cluster_name  = "${var.consul_cluster_name}"
  cluster_size  = "${var.num_consul_servers}"
  instance_type = "t2.micro"

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = "${var.cluster_tag_key}"
  cluster_tag_value = "${var.consul_cluster_name}"

  ami_id    = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"
  user_data = "${data.template_file.user_data_consul_server.rendered}"

  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = "${data.terraform_remote_state.vpc_remote_state.private_subnets}"

  # To make testing easier, we allow Consul and SSH requests from any IP address here but in a production
  # deployment, we strongly recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = "${var.ssh_key_name}"
}

data "template_file" "user_data_consul_server" {
  template = "${file("${path.module}/user-data-consul-server.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.consul_cluster_name}"
  }
}

module "nomad_clients" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.0.1"
  source  = "github.com/hashicorp/terraform-aws-nomad//modules/nomad-cluster?ref=v0.4.1"

  cluster_name  = "${var.nomad_client_cluster_name}"
  instance_type = "t2.micro"

  # Give the clients a different tag so they don't try to join the server cluster
  cluster_tag_key   = "nomad-clients"
  cluster_tag_value = "${var.nomad_client_cluster_name}"

  # To keep the example simple, we are using a fixed-size cluster. In real-world usage, you could use auto scaling
  # policies to dynamically resize the cluster in response to load.

  min_size         = "${var.num_nomad_clients}"
  max_size         = "${var.num_nomad_clients}"
  desired_capacity = "${var.num_nomad_clients}"

  ami_id    = "${var.ami_id == "" ? data.aws_ami.nomad_consul.image_id : var.ami_id}"
  user_data = "${data.template_file.user_data_nomad_client.rendered}"

  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = "${data.terraform_remote_state.vpc_remote_state.private_subnets}"

  # To make testing easier, we allow Consul and SSH requests from any IP address here but in a production
  # deployment, we strongly recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = "${var.ssh_key_name}"
}

module "consul_iam_policies_clients" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.3.1"

  iam_role_id = "${module.nomad_clients.iam_role_id}"
}

data "template_file" "user_data_nomad_client" {
  template = "${file("${path.module}/user-data-nomad-client.sh")}"

  vars {
    cluster_tag_key   = "${var.cluster_tag_key}"
    cluster_tag_value = "${var.consul_cluster_name}"
  }
}

data "aws_vpc" "default" {
  default = false
  id      = "${data.terraform_remote_state.vpc_remote_state.vpc_id}"
}

data "aws_region" "current" {}

terraform {
  backend "s3" {
    bucket = "immutability-hashistack-state"
    key    = "nomad-consul/terraform.tfstate"
    region = "us-east-1"
    encrypt = "true"
  }
}

data "terraform_remote_state" "remote_state" {
  backend = "s3"

  config {
    profile = "${var.aws_profile}"
    bucket  = "immutability-hashistack-state"
    key     = "nomad-consul/terraform.tfstate"
    region  = "${var.aws_region}"
    encrypt = "true"
    acl     = "private"
  }
}

data "terraform_remote_state" "vpc_remote_state" {
  backend = "s3"

  config {
    profile = "${var.aws_profile}"
    bucket  = "openvpn-quickstart-state"
    key     = "terraform.tfstate"
    region  = "${var.aws_region}"
    encrypt = "true"
    acl     = "private"
  }
}