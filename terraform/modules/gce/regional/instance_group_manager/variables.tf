variable "name" {
  description = "The name of the health check"
  type        = string
}

variable "base_name" {
  description = "The base name of the instances"
  type        = string
}

variable "instance_template" {
  description = "The instance template to use for the instance group manager"
  type        = string
}

variable "target_size" {
  description = "The target size of the instance group manager"
  type        = number
}

variable "port_name" {
  description = "The name of the port"
  type        = string
}

variable "port_number" {
  description = "The number of the port"
  type        = number
}

variable "health_check" {
  description = "The health check to use for the instance group manager"
  type        = string
}

variable "initial_delay_sec" {
  description = "The initial delay in seconds for the health check"
  type        = number
}