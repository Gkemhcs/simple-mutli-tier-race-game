

# Create a Managed Instance Group
resource "google_compute_instance_group_manager" "backend_asia" {
  name               = "backend-asia"
  base_instance_name = "backend"
   version {
    instance_template = google_compute_instance_template.backend_template_asia.id
    name              = "primary"
  }
  target_size        = 1
  zone               = "asia-south2-a"
  named_port {
    name   = "http"
    port   = 80
    
  }
}

# Create an Internal HTTP Load Balancer
resource "google_compute_region_backend_service" "backend_service" {
  name                  = "backend-bs"
  protocol              = "HTTP"
  port_name             = "http"
  region                = "asia-south2"
  project               = var.project
  load_balancing_scheme = "INTERNAL_MANAGED"

   backend {
    group           = google_compute_instance_group_manager.backend_asia.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
  timeout_sec           = 30
  health_checks         = ["${google_compute_region_health_check.backend.self_link}"]
}


resource "google_compute_region_health_check" "backend" {
  name               = "health-check-backend"
  
  region             = "asia-south2"
  timeout_sec        = 1
   http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
  
}


resource "google_compute_region_url_map" "backend_url_map" {
  name   = "backend-url-map"
  region = "asia-south2"
  
  default_service = google_compute_region_backend_service.backend_service.self_link
}

resource "google_compute_region_target_http_proxy" "proxy_backend" {
  name    = "proxy-backend"
  region  = "asia-south2"
  url_map = google_compute_region_url_map.backend_url_map.self_link
}

resource "google_compute_address" "backend_ip" {
  name         = "my-internal-address"
  subnetwork   = values(google_compute_subnetwork.subnet)[1].id
 
  address_type = "INTERNAL"

  region       = "asia-south2"
}
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  name                  = "backend-fw"
  ip_address               = google_compute_address.backend_ip.address
  region                = "asia-south2"
  depends_on            = [google_compute_subnetwork.proxy_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  allow_global_access   = true
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.proxy_backend.id
  network               = google_compute_network.network.id
  subnetwork            = values(google_compute_subnetwork.subnet)[1].id
  network_tier          = "PREMIUM"
}