resource "google_compute_router" "router-us" {
  name    = "router-us"
  region  = "us-central1"
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat-us" {
  name                               = "router-nat-us"
  router                             = google_compute_router.router-us.name
  region                             = google_compute_router.router-us.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  log_config {
    enable = true
    filter = "ALL"
  }
}
resource "google_compute_router" "router-asia" {
  name    = "router-asia"
  region  = "asia-south2"
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat-asia" {
  name                               = "router-nat-asia"
  router                             = google_compute_router.router-asia.name
  region                             = google_compute_router.router-asia.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"

  log_config {
    enable = true
    filter = "ALL"
  }
}