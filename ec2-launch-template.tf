resource "aws_placement_group" "this" {
  name     = var.asg_name
  strategy = var.placement_strategy
}

resource "aws_launch_template" "this" {
  name = var.asg_name

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = var.cpu_credit_specification
  }

  disable_api_termination = false

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  image_id = var.ami_id

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  instance_type = var.instance_type

  key_name = var.ssh_key_name

  monitoring {
    enabled = var.detailed_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = var.security_groups
  }

  placement {
    group_name = aws_placement_group.this.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.input_tags, {})
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.input_tags, {})
  }

  user_data = var.user_data_base64
}
