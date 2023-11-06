resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name             = "sql-race-game"
  region           = "asia-south2"
  database_version = "MYSQL_5_7"
  root_password    = "gkem1234"
  depends_on       = [google_service_networking_connection.private_access]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = true
      private_network                               = google_compute_network.network.id
      enable_private_path_for_google_cloud_services = true
    }
  }
}
resource "google_sql_database" "database" {
  name     = "race_game"
  instance = google_sql_database_instance.instance.name
}
resource "google_sql_user" "iam_user" {
  name     = "root"
  instance = google_sql_database_instance.instance.name
  type     = "BUILT_IN"
}