variable "name" {
  description = "The name of the auto scaler"
  type        = string
}

variable "target_instance_group" {
  description = "The target instance group of the auto scaler"
  type        = string
}

variable "min_replicas" {
  description = "The minimum number of replicas"
  type        = number
}

variable "max_replicas" {
  description = "The maximum number of replicas"
  type        = number
}

variable "cooldown_period" {
  description = "The period of time to wait before starting another operation"
  type        = number
  default     = 60
}

variable "target_cpu_utilization" {
  description = "The CPU target"
  type        = number
}