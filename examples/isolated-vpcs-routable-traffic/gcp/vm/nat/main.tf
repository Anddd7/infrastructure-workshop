module "nat-gtw" {
  source = "../../vm"

  name                    = var.name
  zone                    = var.zone
  subnetwork              = var.subnetwork
  network_tags            = var.network_tags
  access_type             = "public"
  can_ip_forward          = true
  metadata_startup_script = file("${path.module}/startup_script.sh")
}

output "hostname" {
  value = module.nat-gtw.hostname
}
output "instance_id" {
  value = module.nat-gtw.instance_id
}
output "zone" {
  value = var.zone
}
