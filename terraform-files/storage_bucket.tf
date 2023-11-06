resource "google_storage_bucket" "bucket" {
  name     = var.storage_bucket_name
  location = "US"
}

locals {
  files_to_upload = fileset("../", "**/*")
}

resource "google_storage_bucket_object" "example_objects" {
  for_each = local.files_to_upload

  name   = each.key
  bucket = google_storage_bucket.bucket.name
  source = "../${each.key}"
}
resource "null_resource" "replace_storage_bucket_name" {
  triggers = {
    bucket_name = var.storage_bucket_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      sed -i "s|BUCKET_NAME|${self.triggers.bucket_name}|g" ../frontend-startup-script.sh;
      sed -i "s|BUCKET_NAME|${self.triggers.bucket_name}|g" ../backend-startup-script.sh;
    EOT
  }
}