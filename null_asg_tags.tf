locals {
  asg_tags = merge(var.input_tags, {
    Name = var.asg_name
  })
}

resource "null_resource" "asg_tags" {
  count = length(keys(local.asg_tags))

  triggers = {
    Key               = element(keys(local.asg_tags), count.index)
    Value             = element(values(local.asg_tags), count.index)
    PropagateAtLaunch = "true"
  }
}

output "asg_tags" {
  description = "ID of target group created by module"
  value       = null_resource.asg_tags[*].triggers
}

output "asg_tags_json" {
  description = "ID of target group created by module"
  value       = jsonencode(null_resource.asg_tags[*].triggers)
}
