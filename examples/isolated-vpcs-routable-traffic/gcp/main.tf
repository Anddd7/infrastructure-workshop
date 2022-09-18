# 1 networks

resource "google_compute_network" "public_vpc" {
  name                    = "public-vpc"
  #  routing_mode            = "GLOBAL"
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
  #  routing_mode            = "GLOBAL"
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

# 2 firewalls, allow to ssh and ping (don't do it at production)

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

# 3 vms (for testing)

module "public_vm_1" {
  source      = "./vm"
  access_type = "private"
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

# 4 pairing (test internal connection)

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

# 5 nat (test public internet connection)

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

# 6 vpc (route private egress to public

resource "google_compute_router" "private_router" {
  name    = "private-router"
  network = google_compute_network.private_vpc.id

  bgp {
    asn = 64515
  }
}
resource "google_compute_ha_vpn_gateway" "public_ha_gateway" {
  region  = var.region
  name    = "public-ha-gateway"
  network = google_compute_network.public_vpc.id
}
resource "google_compute_ha_vpn_gateway" "private_ha_gateway" {
  region  = var.region
  name    = "private-ha-gateway"
  network = google_compute_network.private_vpc.id
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                  = "ha-vpn-tunnel1"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.public_ha_gateway.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.private_ha_gateway.id
  shared_secret         = "a secret message"
  router                = google_compute_router.public_router.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                  = "ha-vpn-tunnel2"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.public_ha_gateway.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.private_ha_gateway.id
  shared_secret         = "a secret message"
  router                = google_compute_router.public_router.id
  vpn_gateway_interface = 1
}

resource "google_compute_vpn_tunnel" "tunnel3" {
  name                  = "ha-vpn-tunnel3"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.private_ha_gateway.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.public_ha_gateway.id
  shared_secret         = "a secret message"
  router                = google_compute_router.private_router.id
  vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "tunnel4" {
  name                  = "ha-vpn-tunnel4"
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.private_ha_gateway.id
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.public_ha_gateway.id
  shared_secret         = "a secret message"
  router                = google_compute_router.private_router.id
  vpn_gateway_interface = 1
}

resource "google_compute_router_interface" "router1_interface1" {
  name       = "router1-interface1"
  router     = google_compute_router.public_router.name
  region     = var.region
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "router1_peer1" {
  name                      = "router1-peer1"
  router                    = google_compute_router.public_router.name
  region                    = var.region
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface1.name
}

resource "google_compute_router_interface" "router1_interface2" {
  name       = "router1-interface2"
  router     = google_compute_router.public_router.name
  region     = var.region
  ip_range   = "169.254.1.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "router1_peer2" {
  name                      = "router1-peer2"
  router                    = google_compute_router.public_router.name
  region                    = var.region
  peer_ip_address           = "169.254.1.1"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router1_interface2.name
}

resource "google_compute_router_interface" "router2_interface1" {
  name       = "router2-interface1"
  router     = google_compute_router.private_router.name
  region     = var.region
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3.name
}

resource "google_compute_router_peer" "router2_peer1" {
  name                      = "router2-peer1"
  router                    = google_compute_router.private_router.name
  region                    = var.region
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = 64514
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router2_interface1.name
}

resource "google_compute_router_interface" "router2_interface2" {
  name       = "router2-interface2"
  router     = google_compute_router.private_router.name
  region     = var.region
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel4.name
}

resource "google_compute_router_peer" "router2_peer2" {
  name                      = "router2-peer2"
  router                    = google_compute_router.private_router.name
  region                    = var.region
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64514
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router2_interface2.name
}
