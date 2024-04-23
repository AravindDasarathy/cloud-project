variable "name" {
  description = "The name of the key ring"
  type        = string
}

variable "region" {
  description = "The location of the key ring"
  type        = string
}

variable "vm_key_name" {
  description = "The name of the VM key"
  type        = string
}

variable "cloud_sql_key_name" {
  description = "The name of the Cloud SQL key"
  type        = string
}

variable "bucket_key_name" {
  description = "The name of the bucket key"
  type        = string
}

variable "rotation_period" {
  description = "The rotation period of the key"
  type        = string
}