resource "google_service_account" "this" {
  account_id   = "${var.input.name}-sa"
  display_name = "Service Account of ${var.input.name}"
}

resource "google_compute_instance" "this" {
  name         = var.input.name
  machine_type = "e2-medium"
  zone         = var.input.zone
  tags         = var.input.network_tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.input.subnetwork

    dynamic "access_config" {
      for_each = local.access_config
      content {
        // Ephemeral public IP
      }
    }
  }

  metadata = local.metadata

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    email  = google_service_account.this.email
    scopes = ["cloud-platform"]
  }
}
