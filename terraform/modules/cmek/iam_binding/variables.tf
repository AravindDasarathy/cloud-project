variable "crypto_key_id" {
  description = "The ID of the crypto key to bind the roles to"
  type        = string
}

variable "roles" {
  description = "The roles to bind to the members"
  type        = list(string)
}

variable "members" {
  description = "The members to bind to the roles"
  type        = list(string)
}