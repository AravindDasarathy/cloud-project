resource "google_compute_region_instance_template" "instance_template" {
  name         = var.name
  machine_type = var.machine_type

  disk {
    source_image = var.image_id
    auto_delete  = var.should_auto_delete
    boot         = var.is_boot_disk
    disk_size_gb = var.boot_disk_size
    disk_type    = var.boot_disk_type
    disk_encryption_key {
      kms_key_self_link = var.kms_key
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
