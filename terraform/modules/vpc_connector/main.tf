resource "google_vpc_access_connector" "connector" {
  name          = var.name
  network       = var.vpc_name
  region        = var.region
  ip_cidr_range = var.ip_cidr_range
  machine_type  = var.machine_type
  min_instances = var.min_instances
  max_instances = var.max_instances
}