resource "google_compute_global_forwarding_rule" "default" {
  name                  = var.name
  ip_protocol           = var.ip_protocol
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range
  target                = var.target_http_proxy
  ip_address            = var.address
}