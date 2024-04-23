variable "name" {
  description = "The name of the SSL certificate"
  type        = string
}

variable "domains" {
  description = "The domains for which the SSL certificate will be issued"
  type        = list(string)
}