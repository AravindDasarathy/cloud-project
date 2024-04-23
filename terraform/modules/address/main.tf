resource "google_compute_global_address" "address" {
  name         = var.name
  address_type = var.type
  # network_tier = var.tier
}