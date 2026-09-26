# Definition of a VM with all necessary configurations needed to run the xport application.
resource "google_compute_instance" "xport-vm-micro" {
  name         = "xport-vm-micro"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 10
      type  = "pd-standard"
    }
  }
  network_interface {
    network    = google_compute_network.xport_network_main.name
    subnetwork = google_compute_subnetwork.xport_subnet.name
    access_config {}
  }
  metadata = {
    enable_oslogin = "TRUE"
  }
  tags = ["xport-app"]
}

