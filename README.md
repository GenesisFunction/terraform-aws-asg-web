# asg-web
asg-web makes an auto-scaling group, and related scaling policies, as well as a target group which can be associated with a load balancer.

This module has the ability to provision the ASG using a nested CloudFormation stack. This can be especially helpful if you want to do rolling AMI upgrades using an immutable application AMI (made with something like Packer for instance).

TODO:
- Handle additional EBS Volumes beyond the root volume
- Support ephemeral volumes?
- Handle spot instance selection?
- Support elastic_gpu_specifications?
- Support elastic_inference_accelerator?
- Support overriding the default ebs volume size
- License manager license associations?
- Add support for lifecycle hooks
- Auto-Scaling rules

### Example Usage:
Create a default role with permissions for ssm and cloudwatch agent:
```
data "aws_ami" "my_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

module "asg-web" {
  source  = "GenesisFunction/asg-web/aws"
  version = "0.1.0"
  # source  = "github.com/GenesisFunction/terraform-aws-asg-web"

  #asg_cloudformation = true
  
  asg_name         = "${var.name_prefix}-app${local.name_suffix}"
  ami_id = "${data.aws_ami.my_ami.id}"
  instance_type    = "t3.small"
  ebs_optimized    = true
  ssh_key_name     = aws_key_pair.app.id
  asg_min          = 1
  asg_max          = 4
  desired_capacity = 1
  user_data_base64 = null

  iam_instance_profile_name = module.ec2_default_instance_profile.instance_profile_id
  

  vpc_id           = module.vpc_app.vpc_id
  subnet_ids       = module.vpc_app.public_subnets
  security_groups  = [
    module.alb_app_01.sg_alb_targets_id,
    aws_security_group.app_admins.id,
    aws_security_group.egress.id
  ]

  target_group_port = 80

  input_tags = merge(local.common_tags, {})
}
```
