resource "google_compute_health_check" "health_check" {
  name                = var.name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    request_path       = var.request_path
    port_specification = var.port_specification
    # proxy_header       = var.proxy_header
    port = var.port
  }
}
