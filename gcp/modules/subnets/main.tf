resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets
  name = each.value.name
  ip_cidr_range = each.value.cidr_range
  network      = var.vpc_name
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}