output "id" {
  value       = google_compute_global_address.address.id
  description = "The unique identifier for the address"
}

output "ip" {
  value       = google_compute_global_address.address.address
  description = "The IP address of the compute address resource"
}