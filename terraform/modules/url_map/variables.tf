variable "name" {
  description = "Name of the region URL map"
  type        = string
}

variable "default_service" {
  description = "The default backend service to use if none of the host rules match"
  type        = string
}