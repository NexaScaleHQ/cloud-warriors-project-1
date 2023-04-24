variable "instance_type" {
  description = "The instance id to be monitored"
  type        = string
}

variable "alarm_actions" {
  type        = list(any)
  description = "List of actions to be triggered"
}
