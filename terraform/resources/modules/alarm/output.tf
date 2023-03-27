output "alarm_arn" {
    value=aws_cloudwatch_metric_alarm.cost-optimization-alarm.arn
}