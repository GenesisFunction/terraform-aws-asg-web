#References: https://github.com/travis-ci/terraform-config/blob/b7584146cfd2b4978def7a87c5f034994cc94766/modules/aws_asg/main.tf#L134-L221
############ https://github.com/hashicorp/terraform/issues/1552#issuecomment-190864512
resource "aws_cloudformation_stack" "this" {
  count = var.asg_cloudformation ? 1 : 0

  name          = var.asg_name
  template_body = <<EOF
{
  "Resources": {
    "AutoScalingGroup": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "Cooldown": 300,
        "HealthCheckType": "EC2",
        "HealthCheckGracePeriod": 0,
        "TargetGroupARNs": ["${aws_lb_target_group.this.arn}"],
        "LaunchTemplate": {
          "LaunchTemplateId" : "${aws_launch_template.this.id}",
          "Version" : "${aws_launch_template.this.latest_version}"
        },
        "MaxSize": "${var.asg_max}",
        "MetricsCollection": [
          {
            "Granularity": "1Minute",
            "Metrics": [
              "GroupMinSize",
              "GroupMaxSize",
              "GroupDesiredCapacity",
              "GroupInServiceInstances",
              "GroupPendingInstances",
              "GroupStandbyInstances",
              "GroupTerminatingInstances",
              "GroupTotalInstances"
            ]
          }
        ],
        "MinSize": "${var.asg_min}",
        "Tags": ${jsonencode(null_resource.asg_tags[*].triggers)},
        "TerminationPolicies": [
          "OldestLaunchConfiguration",
          "OldestInstance",
          "Default"
        ],
        "VPCZoneIdentifier": ${jsonencode(var.subnet_ids)}
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.asg_min}",
          "MaxBatchSize": "2",
          "PauseTime": "PT0S"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
      "Value": {
        "Ref": "AutoScalingGroup"
      }
    }
  }
}
EOF
}

resource "aws_autoscaling_attachment" "this_cf" {
  count = var.asg_cloudformation ? 1 : 0

  autoscaling_group_name = aws_cloudformation_stack.this[0].outputs["AsgName"]
  alb_target_group_arn   = aws_lb_target_group.this.arn
}

