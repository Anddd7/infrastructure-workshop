# https://cloud.google.com/architecture/deploying-nat-gateways-in-a-hub-and-spoke-architecture-using-vpc-network-peering-and-routing

# 1 hub vpc

resource "google_compute_network" "hub-vpc" {
  name                    = "hub-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "hub-subnet" {
  name          = "hub-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.hub-vpc.id
}

# 2 spoke vpcs

resource "google_compute_network" "spoke1-vpc" {
  name                    = "spoke1-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke1-subnet" {
  name          = "spoke1-subnet"
  ip_cidr_range = "192.168.1.0/24"
  region        = var.region
  network       = google_compute_network.spoke1-vpc.id
}

resource "google_compute_network" "spoke2-vpc" {
  name                    = "spoke2-vpc"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "spoke2-subnet" {
  name          = "spoke2-subnet"
  ip_cidr_range = "192.168.2.0/24"
  region        = var.region
  network       = google_compute_network.spoke2-vpc.id
}

# 3 firewalls

resource "google_compute_firewall" "hub-vpc-web-ping-dns" {
  name    = "hub-vpc-web-ping-dns"
  network = google_compute_network.hub-vpc.name

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "udp"
    ports    = [53]
  }

  source_ranges = [
    google_compute_subnetwork.hub-subnet.ip_cidr_range,
    google_compute_subnetwork.spoke1-subnet.ip_cidr_range,
    google_compute_subnetwork.spoke2-subnet.ip_cidr_range,
  ]
}


resource "google_compute_firewall" "spoke1-vpc-web-ping-dns" {
  name    = "spoke1-vpc-web-ping-dns"
  network = google_compute_network.spoke1-vpc.name

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "udp"
    ports    = [53]
  }

  source_ranges = [
    google_compute_subnetwork.hub-subnet.ip_cidr_range,
    google_compute_subnetwork.spoke1-subnet.ip_cidr_range,
  ]
}

resource "google_compute_firewall" "spoke2-vpc-web-ping-dns" {
  name      = "spoke2-vpc-web-ping-dns"
  network   = google_compute_network.spoke2-vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "udp"
    ports    = [53]
  }

  source_ranges = [
    google_compute_subnetwork.hub-subnet.ip_cidr_range,
    google_compute_subnetwork.spoke2-subnet.ip_cidr_range,
  ]
}

# 4 allow ssh from iap (console ssh

resource "google_compute_firewall" "vpc-iap" {
  for_each = toset([
    google_compute_network.hub-vpc.name,
    google_compute_network.spoke1-vpc.name,
    google_compute_network.spoke2-vpc.name,
  ])

  name    = "${each.key}-iap"
  network = each.key

  allow {
    protocol = "tcp"
    ports    = [22]
  }
  source_ranges = ["35.235.240.0/20"]
}

# 5 allow health check for nat vms

resource "google_compute_firewall" "hub-vpc-health-check" {
  name    = "hub-vpc-health-check"
  network = google_compute_network.hub-vpc.name

  allow {
    protocol = "tcp"
    ports    = [443]
  }
  target_tags   = ["nat-gw"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

# ----------------------------------------------------------------- #

# 1. create instance template
# 2. create health check
# 3. create instance group
# 1,2,3 -> create nat vm instead

module "hub-nat-gtw-1" {
  source = "./vm/nat"

  name         = "hub-nat-gtw-1"
  zone         = "${var.region}-a"
  subnetwork   = google_compute_subnetwork.hub-subnet.name
  network_tags = ["nat-gtw"]
}

module "hub-nat-gtw-2" {
  source = "./vm/nat"

  name         = "hub-nat-gtw-2"
  zone         = "${var.region}-b"
  subnetwork   = google_compute_subnetwork.hub-subnet.name
  network_tags = ["nat-gtw"]
}

# 4 delete default route in hub-vpc

resource "null_resource" "drop-hub-default-route" {
  provisioner "local-exec" {
    command = <<-EOF
export hub_default_route=$(gcloud compute routes list \
    --format="value(name)" --filter="network:${google_compute_network.hub-vpc.name} AND nextHopGateway:default-internet-gateway"  | head -n 1)

gcloud compute routes delete $hub_default_route -q
EOF
  }
}

# 5 create nat route
resource "google_compute_route" "hub-default-tagged" {
  name             = "hub-default-tagged"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.hub-vpc.name
  next_hop_gateway = "default-internet-gateway"
  tags             = ["nat-gtw"]
  priority         = 700
}

resource "google_compute_route" "nat-gtw-route-1" {
  depends_on = [module.hub-nat-gtw-1]

  name                   = "nat-gtw-route-1"
  dest_range             = "0.0.0.0/0"
  network                = google_compute_network.hub-vpc.name
  next_hop_instance      = module.hub-nat-gtw-1.instance_id
  next_hop_instance_zone = module.hub-nat-gtw-1.zone
  priority               = 800
}
resource "google_compute_route" "nat-gtw-route-2" {
  depends_on = [module.hub-nat-gtw-2]

  name                   = "nat-gtw-route-2"
  dest_range             = "0.0.0.0/0"
  network                = google_compute_network.hub-vpc.name
  next_hop_instance      = module.hub-nat-gtw-2.instance_id
  next_hop_instance_zone = module.hub-nat-gtw-2.zone
  priority               = 800
}

# 6 delete default route in spoke-vpc

resource "null_resource" "drop-spoke-default-route" {
  provisioner "local-exec" {
    command = <<-EOF
export spoke1_default_route=$(gcloud compute routes list \
    --format="value(name)" \
    --filter="network:${google_compute_network.spoke1-vpc.name} AND nextHopGateway:default-internet-gateway")

gcloud compute routes delete $spoke1_default_route -q

export spoke2_default_route=$(gcloud compute routes list \
    --format="value(name)" \
    --filter="network:${google_compute_network.spoke2-vpc.name} AND nextHopGateway:default-internet-gateway")

gcloud compute routes delete $spoke2_default_route -q
EOF
  }
}

# 7 vm in spoke vpc for testing
module "spoke1-client" {
  source = "./vm"

  access_type  = "private"
  name         = "spoke1-client"
  zone         = "${var.region}-b"
  subnetwork   = google_compute_subnetwork.spoke1-subnet.name
  network_tags = []
}

module "spoke2-client" {
  source = "./vm"

  access_type  = "private"
  name         = "spoke2-client"
  zone         = "${var.region}-c"
  subnetwork   = google_compute_subnetwork.spoke2-subnet.name
  network_tags = []
}

# ----------------------------------------------------------------- #

# 1,2,3 pairing

resource "google_compute_network_peering" "hub-2-spoke1" {
  name                 = "hub-2-spoke1"
  network              = google_compute_network.hub-vpc.self_link
  peer_network         = google_compute_network.spoke1-vpc.self_link
  export_custom_routes = true
}
resource "google_compute_network_peering" "hub-2-spoke2" {
  name                 = "hub-2-spoke2"
  network              = google_compute_network.hub-vpc.self_link
  peer_network         = google_compute_network.spoke2-vpc.self_link
  export_custom_routes = true
}
resource "google_compute_network_peering" "spoke1-2-hub" {
  name                 = "spoke1-2-hub"
  network              = google_compute_network.spoke1-vpc.self_link
  peer_network         = google_compute_network.hub-vpc.self_link
  import_custom_routes = true
}
resource "google_compute_network_peering" "spoke2-2-hub" {
  name                 = "spoke2-2-hub"
  network              = google_compute_network.spoke2-vpc.self_link
  peer_network         = google_compute_network.hub-vpc.self_link
  import_custom_routes = true
}
