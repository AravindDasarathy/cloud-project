variable "name" {
  description = "Name of the firewall"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to which the firewall will be attached"
  type        = string
}

variable "allow_traffic_rules" {
  description = "List of protocol and ports objects for application traffic"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
}

variable "source_ranges" {
  description = "The source ranges to allow"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_tags" {
  description = "The target tags to apply to the firewall rule"
  type        = list(string)
}

variable "priority" {
  description = "The priority of the rule"
  type        = number
  default     = 1000
}