locals {
  project_name = "playground-s-11-663b4362"
  bucket_name  = "tf-state_${local.project_name}"
  region       = "australia-southeast1"
}

inputs = {
  backend_bucket_name = local.bucket_name
  region              = local.region
}

remote_state {
  backend  = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket   = local.bucket_name
    project  = local.project_name
    location = local.region
    prefix   = "terraform/state"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "google" {
  project     = "${local.project_name}"
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  region      = "${local.region}"
}
EOF
}
