variable "name" {
  type    = string
  default = "webapp-vpc"
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "routing_mode" {
  type    = string
  default = "REGIONAL"
}

variable "delete_default_routes_on_create" {
  type    = bool
  default = true
}