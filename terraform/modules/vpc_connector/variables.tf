variable "name" {
  type        = string
  description = "The name of the VPC connector"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC to connect to"
}

variable "ip_cidr_range" {
  type        = string
  description = "The IP range in CIDR notation that the VPC connector will connect to"
}

variable "region" {
  type        = string
  description = "The region of the VPC connector"
}

variable "machine_type" {
  type        = string
  description = "The machine type of the VPC connector"
}

variable "min_instances" {
  type        = number
  description = "The minimum number of instances for the VPC connector"
}

variable "max_instances" {
  type        = number
  description = "The maximum number of instances for the VPC connector"
}