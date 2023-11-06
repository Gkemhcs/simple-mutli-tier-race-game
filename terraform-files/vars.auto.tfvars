project= PROJECT_ID
storage_bucket_name=BUCKET_NAME
subnets = {
  
  "frontend-us" = {
    name   = "frontend-us"
    region = "us-central1"
    range  = "192.168.1.0/24"
  },
  "backend-asia" = {
    name   = "backend-asia"
    region = "asia-south2"
    range  = "192.168.2.0/24"
  },
  "frontend-asia" = {
    name   = "frontend-asia"
    region = "asia-south2"
    range  = "192.168.0.0/24"
  }
}
proxy_subnet = {
  name   = "proxy-lb-asia"
  region = "asia-south2"
  range  = "192.168.3.0/24"
}

