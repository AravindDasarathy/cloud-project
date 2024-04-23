resource "google_dns_record_set" "dns_record" {
  name         = var.name
  type         = var.type
  ttl          = var.ttl
  managed_zone = var.managed_zone
  rrdatas      = var.rrdatas
}