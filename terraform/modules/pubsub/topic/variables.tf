variable "name" {
  type        = string
  description = "The name of the topic"
}

variable "message_retention_duration" {
  type        = string
  description = "The duration in seconds that a message published to the topic is retained"
  default     = "604800s"
}

variable "project" {
  type        = string
  description = "The project in which the resource belongs"
}