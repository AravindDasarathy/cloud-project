variable "name" {
  description = "The name of the instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type to create"
  type        = string
  default     = "n1-standard-1"
}

variable "image_id" {
  description = "Custom image ID for the boot disk"
  type        = string
}

variable "boot_disk_size" {
  description = "The size of the boot disk in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "The type of the boot disk"
  type        = string
  default     = "pd-standard"
}

variable "vpc_name" {
  description = "The VPC to create the instance in"
  type        = string
}

variable "subnet_name" {
  description = "The subnet to create the instance in"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the instance"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database instance"
  type        = string
}

variable "db_host" {
  description = "The host of the database instance"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the user"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account to use for the instance"
  type        = string
}

variable "service_account_scopes" {
  description = "The scopes to apply to the service account"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "pubsub_topic_name" {
  description = "The name of the Pub/Sub topic"
  type        = string
}