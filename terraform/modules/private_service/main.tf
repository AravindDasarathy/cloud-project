terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}


resource "google_compute_global_address" "private_services_range" {
  name          = var.name
  purpose       = var.purpose
  address_type  = var.address_type
  prefix_length = var.prefix_length
  network       = var.network
}

# Reason for using google-beta provider - https://github.com/hashicorp/terraform-provider-google/issues/16275#issuecomment-1825752152
# If the deletion policy is not set to ABANDON, the private service connection will not be deleted when the resource is destroyed.
resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = var.network
  service                 = var.service
  reserved_peering_ranges = [google_compute_global_address.private_services_range.name]
  deletion_policy         = var.deletion_policy
}