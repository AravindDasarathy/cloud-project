resource "google_storage_bucket" "cloud_webapp_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = var.force_destroy
  encryption {
    default_kms_key_name = var.encryption_key
  }
}

resource "google_storage_bucket_object" "bucket_object" {
  name         = var.object_name
  source       = var.object_source
  content_type = var.content_type
  bucket       = google_storage_bucket.cloud_webapp_bucket.id
}
