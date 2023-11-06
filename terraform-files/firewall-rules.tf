resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["lb-vm"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fw_allow_health_check" {
  name    = "fw-allow-health-check"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = []
  }
  target_tags   = ["lb-vm"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

resource "google_compute_firewall" "fw_allow_proxies" {
  name    = "fw-allow-proxies"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "8080"]
  }
  target_tags   = ["lb-vm"]
  source_ranges = [google_compute_subnetwork.proxy_subnet.ip_cidr_range]
}
