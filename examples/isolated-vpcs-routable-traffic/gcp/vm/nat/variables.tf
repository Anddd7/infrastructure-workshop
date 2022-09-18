locals {
  metadata = {
    created = "terraform"
    purpose = "nat forward proxy"
  }
}

variable "name" { type = string }
variable "zone" { type = string }
variable "subnetwork" { type = string }
variable "network_tags" { type = list(string) }
