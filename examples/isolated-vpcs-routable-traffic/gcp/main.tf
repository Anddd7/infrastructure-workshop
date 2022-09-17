# vpc & subnets
resource "google_compute_network" "public_vpc" {
  name                    = "public-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "public-subnet-1"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = google_compute_network.public_vpc.id
}
resource "google_compute_network" "private_vpc" {
  name                    = "private-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "private_subnet_1" {
  name          = "private-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.private_vpc.id
}
resource "google_compute_subnetwork" "private_subnet_2" {
  name          = "private-subnet-2"
  ip_cidr_range = "10.3.0.0/16"
  region        = var.region
  network       = google_compute_network.private_vpc.id
}

# firewalls

resource "google_compute_firewall" "public_firewall_alltraffic" {
  name      = "public-firewall-alltraffic"
  network   = google_compute_network.public_vpc.name
  direction = "INGRESS"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-alltraffic"]
}

resource "google_compute_firewall" "private_firewall_alltraffic" {
  name      = "private-firewall-alltraffic"
  network   = google_compute_network.private_vpc.name
  direction = "INGRESS"

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-alltraffic"]
}

# pairing

resource "google_compute_network_peering" "public_2_private" {
  name         = "public-2-private"
  network      = google_compute_network.public_vpc.self_link
  peer_network = google_compute_network.private_vpc.self_link
}
resource "google_compute_network_peering" "private_2_public" {
  name         = "private-2-public"
  network      = google_compute_network.private_vpc.self_link
  peer_network = google_compute_network.public_vpc.self_link
}

# vms

module "public_vm_1" {
  source      = "./vm"
  access_type = "public"
  input       = {
    name         = "public-vm-1"
    zone         = "${var.region}-a"
    subnetwork   = google_compute_subnetwork.public_subnet_1.self_link
    network_tags = ["allow-alltraffic"]
  }
}

module "private_vm_1" {
  source      = "./vm"
  access_type = "private"
  input       = {
    name         = "private-vm-1"
    zone         = "${var.region}-b"
    subnetwork   = google_compute_subnetwork.private_subnet_1.self_link
    network_tags = ["allow-alltraffic"]
  }
}

module "private_vm_2" {
  source      = "./vm"
  access_type = "private"
  input       = {
    name         = "private-vm-2"
    zone         = "${var.region}-c"
    subnetwork   = google_compute_subnetwork.private_subnet_2.self_link
    network_tags = ["allow-alltraffic"]
  }
}

# nat

resource "google_compute_router" "public_router" {
  name    = "public-router"
  network = google_compute_network.public_vpc.id
  region  = google_compute_subnetwork.public_subnet_1.region

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "public_nat" {
  name                               = "public-router-nat"
  router                             = google_compute_router.public_router.name
  region                             = google_compute_router.public_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
