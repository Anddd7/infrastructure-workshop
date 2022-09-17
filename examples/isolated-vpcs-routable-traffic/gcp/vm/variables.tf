locals {
  access_config = var.access_type == "public" ? [true] : []
  metadata      = {
    created = "terraform"
  }
}

variable "input" {
  type = object({
    name         = string
    zone         = string
    subnetwork   = string
    network_tags = list(string)
  })
}

variable "access_type" {}
