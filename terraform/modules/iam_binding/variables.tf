variable "project_id" {
  description = "value of the project_id"
  type        = string
}

variable "roles" {
  description = "value of the role"
  type        = list(string)
}

variable "members" {
  description = "value of the members"
  type        = list(string)
}