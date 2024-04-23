terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}

resource "google_compute_managed_ssl_certificate" "ssl_cert" {
  provider = google-beta
  name     = var.name

  managed {
    domains = var.domains
  }
}