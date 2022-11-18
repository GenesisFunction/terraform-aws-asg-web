resource "aws_autoscaling_group" "this" {
  count = var.asg_cloudformation ? 0 : 1

  name_prefix      = var.asg_name
  min_size         = var.asg_min
  max_size         = var.asg_max
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  health_check_grace_period = 0
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.subnet_ids

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "this" {
  count = var.asg_cloudformation ? 0 : 1

  autoscaling_group_name = aws_autoscaling_group.this[0].id
  alb_target_group_arn   = aws_lb_target_group.this.arn
}
