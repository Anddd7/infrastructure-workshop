
provider "google" {
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  project     = "playground-s-11-9b98f7af"
  region      = "AUSTRALIA-SOUTHEAST1"
}
