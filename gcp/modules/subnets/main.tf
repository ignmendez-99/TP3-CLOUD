resource "google_compute_subnetwork" "subnet_for_load_balancer" {
  name          =  var.subnet_for_load_balancer_name
  ip_cidr_range = var.cidr_range_subnet_for_load_balancer
  network      = var.vpc_name
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "subnet_for_cloud_sql" {
  name          =  var.subnet_for_cloud_sql_name
  ip_cidr_range = var.cidr_range_subnet_for_cloud_sql
  network      = var.vpc_name
  region        = var.region

  log_config {
    aggregation_interval = "INTERVAL_30_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}