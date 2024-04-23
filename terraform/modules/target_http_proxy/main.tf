terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}
resource "google_compute_target_https_proxy" "target_http_proxy" {
  provider         = google-beta
  name             = var.name
  url_map          = var.url_map
  ssl_certificates = var.ssl_certificate_names
}