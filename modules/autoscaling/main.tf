resource "aws_autoscaling_group" "app" {

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {

    key = "Name"

    value = "${var.name_prefix}-app-server"

    propagate_at_launch = true

  }
}