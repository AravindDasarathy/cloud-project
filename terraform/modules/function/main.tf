resource "google_cloudfunctions2_function" "default" {
  name     = var.name
  location = var.location

  build_config {
    runtime     = var.runtime
    entry_point = var.entry_point
    source {
      storage_source {
        bucket = var.source_bucket
        object = var.source_bucket_object
      }
    }
  }

  service_config {
    max_instance_count             = var.max_instance_count
    min_instance_count             = var.min_instance_count
    available_memory               = var.available_memory
    timeout_seconds                = var.timeout_seconds
    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = var.all_traffic_on_latest_revision
    vpc_connector                  = var.vpc_connector
    vpc_connector_egress_settings  = var.vpc_connector_egress_settings
    environment_variables          = var.environment_variables
  }

  event_trigger {
    trigger_region = var.trigger_region
    event_type     = var.event_type
    pubsub_topic   = var.pubsub_topic
    retry_policy   = var.retry_policy
  }
}