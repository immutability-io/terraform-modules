# --- outputs the Amazon Resource Name for the ecs cluster
output "aws_ecs_cluster_id" {
  value = "${aws_ecs_cluster.base.id}"
}

output "aws_ecs_cluster_name" {
  value = "${aws_ecs_cluster.name}"
}
