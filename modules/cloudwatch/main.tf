resource "aws_sns_topic" "cloudwatch_alert" {
  tags = merge(
    var.common_tags,
    {
      Name = "{var.name_prefix}-cloudwatch-alerts"
    }
  )
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.cloudwatch_alert.arn

  protocol = "email"
  endpoint = "var.notification_name"
}

#Scale out policy
resource "aws_autoscaling_policy" "scale_out" {

  name                   = "${var.name_prefix}-scale-out"
  autoscaling_group_name = var.asg_name

  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = "1"
}

#Scale in Policy
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.name_prefix}-scale-in"
  autoscaling_group_name = var.asg_name

  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = "-1"
}

#High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.name_prefix}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Average"
  threshold   = 80

  alarm_actions = [
    aws_autoscaling_policy.scale_out.arn,
    aws_sns_topic.cloudwatch_alert.arn
  ]

}

#Low CPU Alarm
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.name_prefix}-low-cpu"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  period      = 300
  statistic   = "Average"
  threshold   = 20

  alarm_actions = [
    aws_autoscaling_policy.scale_in.arn
  ]

}