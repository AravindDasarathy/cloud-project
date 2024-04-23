variable "name" {
  description = "The name of the DNS record"
  type        = string
}

variable "type" {
  description = "The type of the DNS record"
  type        = string
}

variable "ttl" {
  description = "The TTL of the DNS record"
  type        = number
  default     = 300
}

variable "managed_zone" {
  description = "The managed zone to create the DNS record in"
  type        = string
}

variable "rrdatas" {
  description = "The data of the DNS record"
  type        = list(string)
}