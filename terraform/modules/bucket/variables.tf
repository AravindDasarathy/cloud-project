variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "region" {
  description = "The region in which the bucket will be created"
  type        = string
}

variable "force_destroy" {
  description = "Whether to allow the bucket to be destroyed"
  type        = bool
}

variable "object_name" {
  description = "The name of the object"
  type        = string
}

variable "object_source" {
  description = "The path to the object"
  type        = string
}

variable "content_type" {
  description = "The content type of the object"
  type        = string
}

variable "encryption_key" {
  description = "The encryption key to use"
  type        = string
}