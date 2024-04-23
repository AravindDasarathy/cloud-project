# Test comment
packer {
  required_plugins {
    googlecompute = {
      version = "~> 1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "account_file" {
  type    = string
  default = env("GCP_PACKER_SERVICE_ACCOUNT_CREDENTIALS")
}

locals {
  timestamp = "${formatdate("YYYY-MM-DD-HH-mm-ss", timestamp())}"
}

source "googlecompute" "centos8" {
  project_id          = var.project_id
  source_image_family = var.source_image_family
  image_name          = "${var.image_name}-${local.timestamp}"
  zone                = var.zone
  ssh_username        = var.ssh_username
}

build {
  name    = "packer-build"
  sources = ["source.googlecompute.centos8"]

  provisioner "file" {
    source      = "webapp.zip"
    destination = "/tmp/webapp.zip"
  }

  provisioner "file" {
    source      = "webappd.service"
    destination = "/tmp/webappd.service"
  }

  provisioner "file" {
    source      = "logger-config.yaml"
    destination = "/tmp/logger-config.yaml"
  }

  provisioner "shell" {
    script = "setup.sh"
  }
}
