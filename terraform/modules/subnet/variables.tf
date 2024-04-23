variable "name" {
  description = "The name of the subnet"
  type        = string
}

variable "ip_cidr_range" {
  description = "The IP address range of the subnet"
  type        = string
}

variable "region" {
  description = "The region of the subnet"
  type        = string
}

variable "vpc_name" {
  description = "VPC that the subnet belongs to"
  type        = string
}

variable "purpose" {
  description = "The purpose of the subnet"
  type        = string
  default     = "PRIVATE_RFC_1918"
}

variable "role" {
  description = "The role of the subnet"
  type        = string
}