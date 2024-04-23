variable "account_id" {
  description = "The account id of the service account"
  type        = string
}

variable "display_name" {
  description = "The display name of the service account"
  type        = string
}

variable "project_id" {
  description = "The project id where the service account will be created"
  type        = string
}

variable "create_ignore_already_exists" {
  description = "If set to true, the service account will not be created if it already exists"
  type        = bool
  default     = true
}