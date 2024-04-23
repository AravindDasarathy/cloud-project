resource "google_pubsub_topic" "topic" {
  name                       = var.name
  project                    = var.project
  message_retention_duration = var.message_retention_duration
}