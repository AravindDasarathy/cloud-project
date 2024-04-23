terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}

resource "google_project_service_identity" "service_identity" {
  provider = google-beta
  service  = var.service
}