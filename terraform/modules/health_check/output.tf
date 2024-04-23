output "id" {
  value       = google_compute_health_check.health_check.self_link
  description = "The ID of the health check"
}