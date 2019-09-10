resource "null_resource" "asg_tags" {
  count = length(keys(merge(var.input_tags, {})))

  triggers = {
    Key   = element(keys(var.input_tags), count.index)
    Value = element(values(var.input_tags), count.index)
    PropagateAtLaunch = "true"
  }
}

output "asg_tags" {
  value = null_resource.asg_tags.*.triggers
}

output "asg_tags_json" {
  value = jsonencode(null_resource.asg_tags.*.triggers)
}
