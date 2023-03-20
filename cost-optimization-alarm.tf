provider "aws" {
  region = "us-east-1"
}

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
    Instance_id = "i-037614aea606f13a6"
  }

  alarm_description = "This alarm monitors the estimated charges for Amazon EC2 instances and triggers if the cost goes above $0.01 per day."

  alarm_actions = [
    "arn:aws:cloudwatch:us-east-1:415505551174:alarm:cost-optimization-alarm"
  ]

  ok_actions = [
    "arn:aws:cloudwatch:us-east-1:415505551174:alarm:cost-optimization-alarm"
  ]

 
}
