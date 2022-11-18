resource "random_id" "this" {
  keepers = {
    name     = var.asg_name
    port     = var.target_group_port
    protocol = var.target_group_protocol
    vpc_id   = var.vpc_id
    target_type = "instance"
  }
  byte_length = 2
}


resource "aws_lb_target_group" "this" {
  name     = "${var.asg_name}-${random_id.this.hex}"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  target_type = "instance"
  health_check {
    enabled  = true
    protocol = var.target_group_protocol
    path     = var.target_group_health_path
    interval = var.target_group_health_interval
    matcher  = var.target_group_health_response
  }

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}
