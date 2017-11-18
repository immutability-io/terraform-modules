# --- https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html
resource "aws_ecs_cluster" "base" {
  name = "${var.ecs_cluster_name}"
}
