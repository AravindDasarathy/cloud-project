variable "name" {
  type        = string
  description = "The name of the function"
}

variable "location" {
  type        = string
  description = "The location of the function"
}

variable "runtime" {
  type        = string
  description = "The runtime of the function"
  default     = "nodejs20"
}

variable "entry_point" {
  type        = string
  description = "The entry point of the function"
  default     = "processPubSubMessage"
}

variable "environment_variables" {
  type        = map(string)
  description = "The environment variables of the function"
}

variable "source_bucket" {
  type        = string
  description = "The source bucket of the function"
}

variable "source_bucket_object" {
  type        = string
  description = "The source object of the function"
}

variable "max_instance_count" {
  type        = number
  description = "The max instance count of the function"
  default     = 3
}

variable "min_instance_count" {
  type        = number
  description = "The min instance count of the function"
  default     = 1
}

variable "available_memory" {
  type        = string
  description = "The available memory of the function"
  default     = "256M"
}

variable "timeout_seconds" {
  type        = number
  description = "The timeout seconds of the function"
  default     = 20
}

variable "ingress_settings" {
  type        = string
  description = "The ingress settings of the function"
  default     = "ALLOW_ALL"
}

variable "all_traffic_on_latest_revision" {
  type        = bool
  description = "The all traffic on latest revision of the function"
  default     = true
}

variable "vpc_connector" {
  type        = string
  description = "The VPC connector of the function"
}

variable "vpc_connector_egress_settings" {
  type        = string
  description = "The VPC connector egress settings of the function"
  default     = "PRIVATE_RANGES_ONLY"
}

variable "trigger_region" {
  type        = string
  description = "The trigger region of the function"
}

variable "event_type" {
  type        = string
  description = "The event type of the function"
  default     = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "pubsub_topic" {
  type        = string
  description = "The pubsub topic of the function"
}

variable "retry_policy" {
  type        = string
  description = "The retry policy of the function"
  default     = "RETRY_POLICY_RETRY"
}