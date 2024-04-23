terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.5.0"
    }
  }
}

resource "random_id" "db_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "postgres_instance" {
  provider            = google-beta
  name                = "${var.name}-${random_id.db_suffix.hex}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = var.deletion_protection
  encryption_key_name = var.encryption_key

  settings {
    tier              = var.tier
    edition           = var.edition
    availability_type = var.availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size

    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled
      private_network = var.private_network
    }
  }
}

resource "google_sql_database" "app_db" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres_instance.name
}

resource "random_id" "random_password" {
  byte_length = 16
}

resource "google_sql_user" "app_user" {
  name            = var.db_username
  password        = random_id.random_password.hex
  instance        = google_sql_database_instance.postgres_instance.name
  deletion_policy = var.deletion_policy
}
