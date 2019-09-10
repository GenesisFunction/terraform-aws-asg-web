variable "asg_name" {
  description = "Unique string name of ALB to be created. Also prepends supporting resource names"
  type        = string
}

variable "asg_cloudformation" {
  description = "true/false to deploy the ASG using a nested CloudFormation. This is useful when doing Rolling ASG updates with immutable AMIs. Default is False"
  type        = bool
  default     = false
}

variable "asg_min" {
  description = "Minimum number of ASG Nodes"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of ASG Nodes"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired starting number of ASG Nodes"
  type        = number
  default     = 1
}

variable "placement_strategy" {
  description = "Placement strategy for instances. Current options are cluster, partition, and spread (spread is default)"
  type        = string
  default     = "spread"
}

variable "input_tags" {
  description = "Map of tags to apply to resources"
  type        = map(string)
  default = {
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
  }
}

variable "vpc_id" {
  description = "ID of VPC which the resource should be created in"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of Subnets which the alb should be attached to"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "True/false to override subnet setting for public IP attachment"
  type        = bool
  default     = null
}

variable "security_groups" {
  description = "IDs of security groups to attach to instances"
  type        = list(string)
}

variable "ami_id" {
  description = "ID of AMI which instances should use. Recommended to use a filter outside of module to find AMI and update automatically."
  type        = string
}

variable "instance_type" {
  description = "Type/size of instance to be created"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "ID of instance profile to attach to instances"
  type        = string
  default     = null
}

variable "ssh_key_name" {
  description = "ssh key to use for instances"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "User data for instances in base64 format"
  type        = string
  default     = null
}

variable "detailed_monitoring" {
  description = "True/false to enable detailed monitoring"
  type        = bool
  default     = false
}

variable "placement_tenancy" {
  description = "default(shared) or dedicated tenancy"
  type        = string
  default     = "default"
}

variable "cpu_credit_specification" {
  description = "Set cpu credit specification (standard or unlimited) - Default is unlimited"
  type        = string
  default     = "unlimited"
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for instances (stop or terminate, default is terminate)"
  type        = string
  default     = "terminate"
}

variable "ebs_optimized" {
  description = "True/false to enable ebs_optimized"
  type        = bool
  default     = null
}

variable "root_block_device" {
  description = "Map for settings of the root block device on the instance"
  type        = map
  default     = null
}

variable "ebs_block_device" {
  description = "list of maps for each additional ebs block device"
  type        = list(any)
  default     = null
}

variable "target_group_port" {
  description = "Port configuration for LB Target group"
  type        = number
  default     = 443
}

variable "target_group_protocol" {
  description = "Protocol configuration for LB Target group"
  type        = string
  default     = "HTTPS"
}

variable "target_group_health_interval" {
  description = "Interval for health checks"
  type        = number
  default     = 10
}

variable "target_group_health_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "target_group_health_response" {
  description = "Response code for health check to be deemed healthy. Default is 200"
  type        = number
  default     = 200
}
