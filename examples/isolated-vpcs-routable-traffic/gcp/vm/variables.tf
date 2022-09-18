locals {
  access_config = var.access_type == "public" ? [true] : []
}

variable "name" { type = string }
variable "zone" { type = string }
variable "subnetwork" { type = string }
variable "network_tags" { type = list(string) }
variable "access_type" { type = string }

// defaults

variable "metadata" {
  default = {
    created = "terraform"
  }
}
variable "metadata_startup_script" {
  default = "echo hi > /test.txt"
}
variable "can_ip_forward" {
  default = false
}
