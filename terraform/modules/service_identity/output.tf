output "email" {
  description = "The email of the service account"
  value       = google_project_service_identity.service_identity.email
}