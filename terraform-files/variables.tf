variable "project" {
  type    = string

}
variable "subnets" {
  description = "Map of subnets with name, range, and region"
  type = map(object({
    name   = string
    range  = string
    region = string
  }))
}

variable "proxy_subnet" {
  description = "Proxy subnet configuration"
  type = object({
    name   = string
    range  = string
    region = string
  })
}
variable "storage_bucket_name" {
  type = string
}