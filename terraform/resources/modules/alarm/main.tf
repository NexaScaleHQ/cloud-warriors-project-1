resource "aws_cloudwatch_metric_alarm" "cost-optimization-alarm" {
  alarm_name          = "cost-optimization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "21600"
  statistic           = "Maximum"
  threshold           = "0.1"

  dimensions = {
    ServiceName = "Amazon Elastic Compute Cloud - Compute",
    Currency    = "USD",
    Instance_id =  var.instance_type
  }

  alarm_description = "This alarm monitors the estimated charges for Amazon EC2 instances and triggers if the cost goes above $0.01 per day."

  alarm_actions = var.alarm_action
 
}
