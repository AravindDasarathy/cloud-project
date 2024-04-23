resource "google_compute_firewall" "deny_traffic" {
  name    = var.name
  network = var.vpc_name

  deny {
    protocol = var.protocol
    ports    = var.ports
  }

  source_ranges = var.source_ranges
  priority      = var.priority
  target_tags   = var.target_tags
}
