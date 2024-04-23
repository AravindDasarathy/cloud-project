resource "google_compute_firewall" "allow_application_traffic" {
  name    = var.name
  network = var.vpc_name

  dynamic "allow" {
    for_each = var.allow_traffic_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = var.source_ranges
  priority      = var.priority
  target_tags   = var.target_tags
}