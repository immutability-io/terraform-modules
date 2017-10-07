# --- https://www.terraform.io/docs/providers/aws/d/caller_identity.html
# --- this does create resource updates whenever a plan is called.  I can live with it.
data "aws_caller_identity" "current" {}

# --- https://www.terraform.io/docs/providers/aws/r/instance.html
# --- http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html
# --- http://docs.aws.amazon.com/cli/latest/reference/ec2/index.html
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  tags {
    account_id = "${data.aws_caller_identity.current.account_id}"
    caller_arn = "${data.aws_caller_identity.current.arn}"
    caller_id  = "${data.aws_caller_identity.current.user_id}"
  }
}

# --- https://www.terraform.io/docs/providers/aws/d/ami.html
# --- filters: http://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
