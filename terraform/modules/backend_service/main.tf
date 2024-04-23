resource "google_compute_backend_service" "backend_service" {
  name                  = var.name
  load_balancing_scheme = var.load_balancing_scheme
  health_checks         = var.health_checkers
  protocol              = var.protocol
  session_affinity      = var.session_affinity
  timeout_sec           = var.timeout_sec
  backend {
    group           = var.instance_group
    balancing_mode  = var.balancing_mode
    capacity_scaler = var.capacity_scaler
    max_utilization = var.max_utilization
  }
}