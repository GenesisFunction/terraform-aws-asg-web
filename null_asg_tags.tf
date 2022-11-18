locals {
  asg_tags = merge(local.common_tags, {
    Name = var.asg_name
  })
}

resource "null_resource" "asg_tags" {
  count = length(keys(local.asg_tags))

  triggers = {
    Key   = element(keys(local.asg_tags), count.index)
    Value = element(values(local.asg_tags), count.index)
    PropagateAtLaunch = "true"
  }
}

output "asg_tags" {
  value = null_resource.asg_tags.*.triggers
}

output "asg_tags_json" {
  value = jsonencode(null_resource.asg_tags.*.triggers)
}
