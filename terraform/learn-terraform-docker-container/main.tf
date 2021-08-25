# terraform setting
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # hostname/namespace of the provider, e.g. registry.terraform.io/kreuzwerker/docker
      version = "~> 2.13.0"
    }
  }
}

# the specific provider you are using
provider "docker" {}

# component of the infra 
# resource "<resource type>" "<resource name>" {}
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  # reference to another resource
  image = docker_image.nginx.latest
  name  = var.container_name
  ports {
    internal = 80
    external = 8080
  }
}
