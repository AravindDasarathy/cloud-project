resource "google_compute_region_autoscaler" "autoscaler" {
  name   = var.name
  target = var.target_instance_group

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = var.cooldown_period

    cpu_utilization {
      target = var.target_cpu_utilization
    }
  }
}
