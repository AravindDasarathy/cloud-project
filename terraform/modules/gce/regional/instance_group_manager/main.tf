resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name               = var.name
  base_instance_name = var.base_name
  target_size        = var.target_size

  named_port {
    name = var.port_name
    port = var.port_number
  }

  version {
    instance_template = var.instance_template
  }

  auto_healing_policies {
    health_check      = var.health_check
    initial_delay_sec = var.initial_delay_sec
  }
}
