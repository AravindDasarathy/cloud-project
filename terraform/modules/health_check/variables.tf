variable "name" {
  description = "The name of the health check"
  type        = string
}

variable "check_interval_sec" {
  description = "How often (in seconds) to check the health of the service"
  type        = number
}

variable "timeout_sec" {
  description = "How long (in seconds) to wait for a response before considering the service unhealthy"
  type        = number
}

variable "healthy_threshold" {
  description = "How many successful checks before considering the service healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "How many failed checks before considering the service unhealthy"
  type        = number
}

variable "request_path" {
  description = "The path to check"
  type        = string
}

variable "port_specification" {
  description = "Specifies how the port is specified"
  type        = string
}

# variable "proxy_header" {
#   description = "The proxy header to append to the health check request"
#   type        = string
# }

variable "port" {
  description = "The port to check"
  type        = number
}