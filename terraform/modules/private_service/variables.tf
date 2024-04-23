variable "project" {
  description = "The project ID to deploy the database instance"
  type        = string
}

variable "region" {
  description = "The region of the database instance"
  type        = string
}

variable "name" {
  description = "The name of global address(es)"
  type        = string
}

variable "purpose" {
  description = "The purpose of the address"
  type        = string
  default     = "VPC_PEERING"
}

variable "address_type" {
  description = "The type of address to reserve"
  type        = string
  default     = "INTERNAL"
}

variable "prefix_length" {
  description = "The prefix length of the IP range"
  type        = number
}

variable "service" {
  description = "The service to connect to the VPC network"
  type        = string
}

variable "network" {
  description = "The VPC network to reserve the address for"
  type        = string
}

variable "deletion_policy" {
  description = "The deletion policy for the connection"
  type        = string
  default     = "ABANDON"
}