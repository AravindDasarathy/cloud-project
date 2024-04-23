output "db_instance_name" {
  value       = google_sql_database_instance.postgres_instance.name
  description = "The name of the database instance"
}

output "db_host" {
  value       = google_sql_database_instance.postgres_instance.private_ip_address
  description = "The host of the database instance"
}

output "db_name" {
  value       = google_sql_database.app_db.name
  description = "The name of the database"
}

output "db_username" {
  value       = google_sql_user.app_user.name
  description = "The username for the app user"
}

output "db_password" {
  value       = google_sql_user.app_user.password
  description = "Password for the app user"
}