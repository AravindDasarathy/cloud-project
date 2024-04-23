resource "google_compute_instance" "instance" {
  name         = var.name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image_id
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    access_config {}
  }

  metadata_startup_script = templatefile("${path.module}/startup.sh", {
    db_host        = var.db_host
    db_name        = var.db_name
    db_username    = var.db_username
    db_password    = var.db_password
    gce_project_id = var.project_id
    gce_topic_name = var.pubsub_topic_name
  })

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  tags = var.tags
}
