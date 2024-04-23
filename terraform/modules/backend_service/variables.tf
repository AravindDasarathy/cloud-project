variable "name" {
  description = "The name of the backend service"
  type        = string
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme of the backend service"
  type        = string
}

variable "health_checkers" {
  description = "The health check of the backend service"
  type        = list(string)
}

variable "protocol" {
  description = "The protocol of the backend service"
  type        = string
}

variable "session_affinity" {
  description = "The session affinity of the backend service"
  type        = string
}

variable "timeout_sec" {
  description = "The timeout of the backend service"
  type        = number
}

variable "instance_group" {
  description = "The instance group of the backend service"
  type        = string
}

variable "balancing_mode" {
  description = "The balancing mode of the backend service"
  type        = string
}

variable "capacity_scaler" {
  description = "The capacity scaler of the backend service"
  type        = number
}

variable "max_utilization" {
  description = "The max utilization of the backend service"
  type        = number
}