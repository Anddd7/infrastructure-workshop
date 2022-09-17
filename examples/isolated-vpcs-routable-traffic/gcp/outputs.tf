output "backend_bucket" {
  value = "the backend: ${data.google_storage_bucket.backend_bucket.name} has been activated."
}
