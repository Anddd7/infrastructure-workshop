variable "input" {
  type = object({
    name         = string
    zone         = string
    subnetwork   = string
    network_tags = list(string)
    metadata     = object({})
  })
}
