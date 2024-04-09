<!-- BEGIN_TF_DOCS -->
<p align="center">                                                                                                                                            
                                                                                
  <img src="https://github.com/StratusGrid/terraform-readme-template/blob/main/header/stratusgrid-logo-smaller.jpg?raw=true" />
  <p align="center">                                                           
    <a href="https://stratusgrid.com/book-a-consultation">Contact Us Test</a> |                  
    <a href="https://stratusgrid.com/cloud-cost-optimization-dashboard">Stratusphere FinOps</a> |
    <a href="https://stratusgrid.com">StratusGrid Home</a> |
    <a href="https://stratusgrid.com/blog">Blog</a>
  </p>                    
</p>

 # terraform-aws-asg-web
 GitHub: [StratusGrid/terraform-aws-asg-web](https://github.com/StratusGrid/terraform-aws-asg-web)

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

 ## Example
 ```hcl
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
  version = "1.0.2"
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
 ## StratusGrid Standards we assume
 - All resource names and name tags shall use `_` and not `-`s
 - The old naming standard for common files such as inputs, outputs, providers, etc was to prefix them with a `-`, this is no longer true as it's not POSIX compliant. Our pre-commit hooks will fail with this old standard.
 - StratusGrid generally follows the TerraForm standards outlined [here](https://www.terraform-best-practices.com/naming)
 ## Repo Knowledge
 Repository for Module vmimport
 ## Documentation
 This repo is self documenting via Terraform Docs, please see the note at the bottom.
 ### `LICENSE`
 This is the standard Apache 2.0 License as defined [here](https://stratusgrid.atlassian.net/wiki/spaces/TK/pages/2121728017/StratusGrid+Terraform+Module+Requirements).
 ### `outputs.tf`
 The StratusGrid standard for Terraform Outputs.
 ### `README.md`
 It's this file! I'm always updated via TF Docs!
 ### `tags.tf`
 The StratusGrid standard for provider/module level tagging. This file contains logic to always merge the repo URL.
 ### `variables.tf`
 All variables related to this repo for all facets.
 One day this should be broken up into each file, maybe maybe not.
 ### `versions.tf`
 This file contains the required providers and their versions. Providers need to be specified otherwise provider overrides can not be done.
 ## Documentation of Misc Config Files
 This section is supposed to outline what the misc configuration files do and what is there purpose
 ### `.config/.terraform-docs.yml`
 This file auto generates your `README.md` file.
 ### `.github/workflows/pre-commit.yml`
 This file contains the instructions for Github workflows, in specific this file run pre-commit and will allow the PR to pass or fail. This is a safety check and extras for if pre-commit isn't run locally.
 ### `examples/*`
 The files in here are used by `.config/terraform-docs.yml` for generating the `README.md`. All files must end in `.tfnot` so Terraform validate doesn't trip on them since they're purely example files.
 ### `.gitignore`
 This is your gitignore, and contains a slew of default standards.
 ---
 ## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
 ## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.this_cf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudformation_stack.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_placement_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/placement_group) | resource |
| [null_resource.asg_tags](https://registry.terraform.io/providers/hashicorp/null/3.2.0/docs/resources/resource) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/id) | resource |
 ## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | ID of AMI which instances should use. Recommended to use a filter outside of module to find AMI and update automatically. | `string` | n/a | yes |
| <a name="input_asg_cloudformation"></a> [asg\_cloudformation](#input\_asg\_cloudformation) | true/false to deploy the ASG using a nested CloudFormation. This is useful when doing Rolling ASG updates with immutable AMIs. Default is False | `bool` | `false` | no |
| <a name="input_asg_max"></a> [asg\_max](#input\_asg\_max) | Maximum number of ASG Nodes | `number` | `2` | no |
| <a name="input_asg_min"></a> [asg\_min](#input\_asg\_min) | Minimum number of ASG Nodes | `number` | `1` | no |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Unique string name of ALB to be created. Also prepends supporting resource names | `string` | n/a | yes |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | True/false to override subnet setting for public IP attachment | `bool` | `null` | no |
| <a name="input_cpu_credit_specification"></a> [cpu\_credit\_specification](#input\_cpu\_credit\_specification) | Set cpu credit specification (standard or unlimited) - Default is unlimited | `string` | `"unlimited"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired starting number of ASG Nodes | `number` | `1` | no |
| <a name="input_detailed_monitoring"></a> [detailed\_monitoring](#input\_detailed\_monitoring) | True/false to enable detailed monitoring | `bool` | `false` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | True/false to enable ebs\_optimized | `bool` | `null` | no |
| <a name="input_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#input\_iam\_instance\_profile\_name) | ID of instance profile to attach to instances | `string` | `null` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to resources | `map(string)` | <pre>{<br>  "Developer": "GenesisFunction",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_instance_initiated_shutdown_behavior"></a> [instance\_initiated\_shutdown\_behavior](#input\_instance\_initiated\_shutdown\_behavior) | Shutdown behavior for instances (stop or terminate, default is terminate) | `string` | `"terminate"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type/size of instance to be created | `string` | n/a | yes |
| <a name="input_placement_strategy"></a> [placement\_strategy](#input\_placement\_strategy) | Placement strategy for instances. Current options are cluster, partition, and spread (spread is default) | `string` | `"spread"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | IDs of security groups to attach to instances | `list(string)` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | ssh key to use for instances | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs of Subnets which the alb should be attached to | `list(string)` | n/a | yes |
| <a name="input_target_group_health_interval"></a> [target\_group\_health\_interval](#input\_target\_group\_health\_interval) | Interval for health checks | `number` | `10` | no |
| <a name="input_target_group_health_path"></a> [target\_group\_health\_path](#input\_target\_group\_health\_path) | Path for health checks | `string` | `"/"` | no |
| <a name="input_target_group_health_response"></a> [target\_group\_health\_response](#input\_target\_group\_health\_response) | Response code for health check to be deemed healthy. Default is 200 | `number` | `200` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | Port configuration for LB Target group | `number` | `443` | no |
| <a name="input_target_group_protocol"></a> [target\_group\_protocol](#input\_target\_group\_protocol) | Protocol configuration for LB Target group | `string` | `"HTTPS"` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | User data for instances in base64 format | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of VPC which the resource should be created in | `string` | n/a | yes |
 ## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_tags"></a> [asg\_tags](#output\_asg\_tags) | ID of target group created by module |
| <a name="output_asg_tags_json"></a> [asg\_tags\_json](#output\_asg\_tags\_json) | ID of target group created by module |
| <a name="output_asg_target_group_id"></a> [asg\_target\_group\_id](#output\_asg\_target\_group\_id) | ID of target group created by module |
 ---
 Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->