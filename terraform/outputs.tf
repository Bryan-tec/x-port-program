output "artifact_registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_name}"
}

output "vm_instance_name" {
  value = google_compute_instance.xport-vm-micro.name
}

output "vm_public_ip" {
  value = google_compute_instance.xport-vm-micro.network_interface[0].access_config[0].nat_ip
}

