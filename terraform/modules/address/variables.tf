variable "name" {
  description = "The name of the address"
  type        = string
}

variable "type" {
  description = "The type of address to reserve"
  type        = string
  default     = "EXTERNAL"
}

# variable "tier" {
#   description = "The network tier of the address"
#   type        = string
# }