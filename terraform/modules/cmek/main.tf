resource "random_id" "key_ring_suffix" {
  byte_length = 4
}

resource "google_kms_key_ring" "key_ring" {
  name     = "${var.name}-${random_id.key_ring_suffix.hex}"
  location = var.region
}

resource "google_kms_crypto_key" "vm_key" {
  name            = var.vm_key_name
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period
}

resource "google_kms_crypto_key" "cloud_sql_key" {
  name            = var.cloud_sql_key_name
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period
}

resource "google_kms_crypto_key" "bucket_key" {
  name            = var.bucket_key_name
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period
}

