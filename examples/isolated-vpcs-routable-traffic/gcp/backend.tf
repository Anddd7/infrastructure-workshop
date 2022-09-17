terraform {
  backend "gcs" {
    bucket = "tf-state_anddd7_github_com"
    prefix = "terraform/state"
  }
}
