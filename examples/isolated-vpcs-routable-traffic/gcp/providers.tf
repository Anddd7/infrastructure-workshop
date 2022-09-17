provider "google" {
  # TODO modify the project after loading the playground
  project     = "playground-s-11-1e20b43e"
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  region      = "australia-southeast1"
}
