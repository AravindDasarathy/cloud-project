resource "google_compute_subnetwork" "subnet" {
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = var.vpc_name
  purpose       = var.purpose
  role          = var.role == "" ? null : var.role
}