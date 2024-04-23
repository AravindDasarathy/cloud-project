output "id" {
  value       = google_compute_region_instance_group_manager.instance_group_manager.self_link
  description = "The ID of the instance group manager"
}

output "instance_group" {
  value       = google_compute_region_instance_group_manager.instance_group_manager.instance_group
  description = "The instance group managed by the instance group manager"
}