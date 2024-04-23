output "name" {
  description = "The name of the SSL certificate"
  value       = google_compute_managed_ssl_certificate.ssl_cert.name
}