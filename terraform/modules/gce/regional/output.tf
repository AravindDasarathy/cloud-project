output "id" {
  value       = google_compute_region_instance_template.instance_template.id
  description = "The self link of the instance template"
}

# output "public_ip" {
#   value       = google_compute_region_instance_template.instance_template.network_interface[0].access_config[0].nat_ip
#   description = "The public IP of the instance"
# }