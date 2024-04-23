output "vm_key_id" {
  value = google_kms_crypto_key.vm_key.id
}

output "cloud_sql_key_id" {
  value = google_kms_crypto_key.cloud_sql_key.id
}

output "bucket_key_id" {
  value = google_kms_crypto_key.bucket_key.id
}

output "key_ring_id" {
  value = google_kms_key_ring.key_ring.id
}