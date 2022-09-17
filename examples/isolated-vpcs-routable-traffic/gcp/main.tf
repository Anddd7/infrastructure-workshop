# public vpc
resource "google_compute_network" "public_vpc" {
  name                    = "public-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  ip_cidr_range = "10.1.0.0/16"
  region        = local.region
  network       = google_compute_network.public_vpc.id
}

resource "google_compute_network" "private_vpc" {
  name                    = "private-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_network_peering" "public_2_private" {
  name         = "public-2-private"
  network      = google_compute_network.public_vpc.self_link
  peer_network = google_compute_network.private_vpc.self_link
}

module "public_vm_1" {
  source = "./vm"
  input  = {
    name         = "public-vm-1"
    zone         = "${local.region}-a"
    subnetwork   = google_compute_subnetwork.public_subnet_1.self_link
    network_tags = ["public", "vm", "networking-test"]
    metadata     = {
      created = "terraform"
    }
  }
}

# private vpc
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  region        = local.region
  network       = google_compute_network.private_vpc.id
}
resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  ip_cidr_range = "10.3.0.0/16"
  region        = local.region
  network       = google_compute_network.private_vpc.id
}
resource "google_compute_network_peering" "private_2_public" {
  name         = "private-2-public"
  network      = google_compute_network.private_vpc.self_link
  peer_network = google_compute_network.public_vpc.self_link
}

module "private_vm_1" {
  source = "./vm"
  input  = {
    name         = "private-vm-1"
    zone         = "${local.region}-b"
    subnetwork   = google_compute_subnetwork.private_subnet_1.self_link
    network_tags = ["private", "vm", "networking-test"]
    metadata     = {
      created = "terraform"
    }
  }
}

module "private_vm_2" {
  source = "./vm"
  input  = {
    name         = "private-vm-2"
    zone         = "${local.region}-c"
    subnetwork   = google_compute_subnetwork.private_subnet_2.self_link
    network_tags = ["private", "vm", "networking-test"]
    metadata     = {
      created = "terraform"
    }
  }
}
