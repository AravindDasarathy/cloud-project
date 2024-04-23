variable "name" {
  description = "Name of the firewall"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to which the firewall will be attached"
  type        = string
}

variable "protocol" {
  description = "The protocol to deny"
  type        = string
}

variable "ports" {
  description = "The ports to deny"
  type        = list(number)
}

variable "source_ranges" {
  description = "The source ranges to deny"
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