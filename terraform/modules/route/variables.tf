variable "name" {
  description = "The name of the route"
  type        = string
}

variable "dest_range" {
  description = "The destination range of outgoing packets that this route applies to"
  type        = string
}

variable "next_hop" {
  description = "The next hop to the destination network"
  type        = string
}

variable "vpc_name" {
  description = "The vpc network that this route applies to"
  type        = string
}