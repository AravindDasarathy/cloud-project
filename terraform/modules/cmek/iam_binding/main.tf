terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}

resource "google_kms_crypto_key_iam_binding" "crypto_iam" {
  provider = google-beta

  for_each      = toset(var.roles)
  crypto_key_id = var.crypto_key_id
  role          = each.key
  members       = var.members
}

