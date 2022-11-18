output "asg_target_group_id" {
  description = "ID of target group created by module"
  value       = aws_lb_target_group.this.id
}
