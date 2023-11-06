resource "google_service_account" "compute_sa" {
  account_id   = "compute-sa"
  project      = var.project
  display_name = "Compute Service Account"
}

# Grant the service account necessary roles (for example, compute engine roles)
resource "google_project_iam_binding" "sa_iam_binding" {
  project = var.project
  role    = "roles/storage.admin"
  
  members = [
    "serviceAccount:${google_service_account.compute_sa.email}"
  ]
}

resource "google_compute_instance_template" "frontend_template_us" {
  name    = "template-frontend-us"
  region  = "us-central1"
  project = var.project
  machine_type="n1-standard-1"
  metadata = {
    startup-script = file("../frontend-startup-script.sh")
    backend        = google_compute_address.backend_ip.address
  }
  tags           = ["lb-vm"]
  can_ip_forward = false
   service_account {
    email = google_service_account.compute_sa.email
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = values(google_compute_subnetwork.subnet)[0].self_link

  }
}


resource "google_compute_instance_template" "frontend_template_asia" {
  name    = "template-frontend-asia"
  region  = "asia-south2"
  project = var.project
  machine_type="n1-standard-1"
  service_account {
    email = google_service_account.compute_sa.email
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  metadata = {
    startup-script = file("../frontend-startup-script.sh")
    backend        = google_compute_address.backend_ip.address
  }
  tags           = ["lb-vm"]
  can_ip_forward = false
  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = values(google_compute_subnetwork.subnet)[2].self_link

  }
}

resource "google_compute_instance_template" "backend_template_asia" {
  name    = "template-backend"
  region  = "asia-south2"
  project = var.project
   machine_type="n1-standard-1"
   service_account {
    email = google_service_account.compute_sa.email
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  metadata = {
    startup-script = file("../backend-startup-script.sh")
    database       = google_sql_database_instance.instance.private_ip_address
  }
  tags           = ["lb-vm"]
  can_ip_forward = false
  scheduling {
    preemptible         = false
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    subnetwork = values(google_compute_subnetwork.subnet)[1].self_link

  }
}
