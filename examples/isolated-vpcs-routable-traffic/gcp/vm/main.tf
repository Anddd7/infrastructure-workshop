resource "google_service_account" "this" {
  account_id   = "${var.name}-sa"
  display_name = "Service Account of ${var.name}"
}

resource "google_compute_instance" "this" {
  name                    = var.name
  machine_type            = "e2-medium"
  zone                    = var.zone
  tags                    = var.network_tags
  metadata                = var.metadata
  metadata_startup_script = var.metadata_startup_script
  can_ip_forward          = var.can_ip_forward

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = local.access_config
      content {
        // Ephemeral public IP
      }
    }
  }

  service_account {
    email  = google_service_account.this.email
    scopes = ["compute-rw", "cloud-platform",]
  }
}

output "hostname" {
  value = google_compute_instance.this.hostname
}
output "instance_id" {
  value = google_compute_instance.this.instance_id
}
