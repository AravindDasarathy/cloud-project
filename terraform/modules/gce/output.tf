output "private_ip" {
  value       = google_compute_instance.instance.network_interface[0].network_ip
  description = "The private IP address of the instance"
}

output "public_ip" {
  value       = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the instance"
}