resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "frontend-fw"
  target     = google_compute_target_http_proxy.proxy_frontend.id
   load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "proxy_frontend" {
  name        = "frontend-fw"
  description = "a description"
  url_map     = google_compute_url_map.frontend_url_map.id
}

resource "google_compute_url_map" "frontend_url_map" {
  name            = "frontend-url-map"
  description     = "a description"
  default_service = google_compute_backend_service.frontend_service.id

  
}

resource "google_compute_backend_service" "frontend_service" {
  name        = "frontend-bs"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"
  health_checks = [google_compute_http_health_check.frontend_health_check.id]
   backend {
    group           = google_compute_instance_group_manager.frontend_asia.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
   backend {
    group           = google_compute_instance_group_manager.frontend_us.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_http_health_check" "frontend_health_check" {
  name               = "check-backend"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port= 80
}
resource "google_compute_instance_group_manager" "frontend_asia" {
  name = "frontend-asia"

  base_instance_name = "us-front"
  zone               = "us-central1-a"

  version {
    instance_template  = google_compute_instance_template.frontend_template_asia.self_link_unique
  }
  target_size  = 2

  named_port {
    name = "http"
    port = 80
  }

}
resource "google_compute_instance_group_manager" "frontend_us" {
  name = "frontend-us"

  base_instance_name = "asia-front"
  zone               = "asia-south2-a"

  version {
    instance_template  = google_compute_instance_template.frontend_template_us.self_link_unique
  }
  target_size  = 2

  named_port {
    name = "http"
    port = 80
  }

}

output "IP_ADDRESS"{
  value=google_compute_global_forwarding_rule.frontend.ip_address
}