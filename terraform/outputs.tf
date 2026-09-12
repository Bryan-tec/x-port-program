output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_name}"
}

