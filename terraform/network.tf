# Define the main network for the VPC
resource "google_compute_network" "xport_network_main" {
  name                    = "xport-network-main"
  auto_create_subnetworks = false
}

# Define the subnetwork for the VPC
resource "google_compute_subnetwork" "xport_subnet" {
  name          = "xport-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.xport_network_main.name
}

# Create a firewall rule to allow internal traffic within the VPC
resource "google_compute_firewall" "firewall-port-5500" {
  name    = "xport-firewall"
  network = google_compute_network.xport_network_main.name

  allow {
    protocol = "tcp"
    ports    = ["5500"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["xport-app"]
}

resource "google_compute_firewall" "firewall-port-22" {
  name    = "xport-firewall-ssh"
  network = google_compute_network.xport_network_main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["187.188.58.28/20"]
  target_tags   = ["xport-app"]
}
