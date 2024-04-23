variable "name" {
  description = "The name of the database instance"
  type        = string
}

variable "region" {
  description = "The region of the database instance"
  type        = string
}

variable "deletion_protection" {
  description = "Whether the database should have delete protection enabled"
  type        = bool
  default     = false
}

variable "database_version" {
  description = "The database version to use"
  type        = string
}

variable "tier" {
  description = "The tier of the database"
  type        = string
  default     = "db-f1-micro"
}

variable "edition" {
  description = "The edition of the database"
  type        = string
  default     = "ENTERPRISE"
}

variable "availability_type" {
  description = "The availability type of the database"
  type        = string
  default     = "REGIONAL"
}

variable "disk_type" {
  description = "The type of disk to use"
  type        = string
  default     = "PD_SSD"
}

variable "disk_size" {
  description = "The size of the disk in GB"
  type        = number
  default     = 100
}

variable "ipv4_enabled" {
  description = "Whether the instance should be assigned a public IP address"
  type        = bool
  default     = false
}

variable "private_network" {
  description = "The VPC network to which peering should be established"
  type        = string
}

variable "deletion_policy" {
  description = "The deletion policy for the connection"
  type        = string
  default     = "ABANDON"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "cloud_computing"
}

variable "db_username" {
  description = "The name of the user"
  type        = string
}

variable "regional_compute_instance_name" {
  description = "The name of the gce instance"
  type        = string
}

variable "encryption_key" {
  description = "The encryption key to use for the database"
  type        = string
}