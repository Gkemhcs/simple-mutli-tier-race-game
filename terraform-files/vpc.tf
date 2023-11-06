
resource "google_compute_network" "network" {
  name                    = "network-race"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each                 = var.subnets
  name                     = each.value.name
  ip_cidr_range            = each.value.range
  region                   = each.value.region
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = var.proxy_subnet.name
  ip_cidr_range = var.proxy_subnet.range
  region        = var.proxy_subnet.region
  network       = google_compute_network.network.self_link
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}

output "network_name" {
  value = google_compute_network.network.name
}

output "subnets_info" {
  value = {
    for subnet_name, subnet in google_compute_subnetwork.subnet :
    subnet_name => {
      id     = subnet.id
      range  = subnet.ip_cidr_range
      region = subnet.region
    }
  }
}

output "subnet_proxy_info" {
  value = {
    id    = google_compute_subnetwork.proxy_subnet.id
    range = google_compute_subnetwork.proxy_subnet.ip_cidr_range
  }
}
resource "google_compute_global_address" "reserved_ip_range" {
  # Number of reserved IP address ranges
  project       = var.project
  address_type  = "INTERNAL"
  name          = "sql-range"
  purpose       = "VPC_PEERING"
  prefix_length = 16 # Specify the desired prefix length for each range (adjust as needed)

  network = google_compute_network.network.self_link
}

resource "google_service_networking_connection" "private_access" {
  provider                = google-beta
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.reserved_ip_range.name]
}