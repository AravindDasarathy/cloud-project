variable "name" {
  description = "Name of the target HTTP proxy"
  type        = string
}

variable "url_map" {
  description = "The URL map to use for this target HTTP proxy"
  type        = string
}

variable "ssl_certificate_names" {
  description = "The names of the SSL certificates to use for this target HTTP proxy"
  type        = list(string)
}