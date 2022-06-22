module "vpc" {
  source = "./modules/vpc"
  vpc_name = "the-stocker-vpc"
}

module "subnets" {
  source = "./modules/subnets"
  subnets = local.subnets
  vpc_name = module.vpc.vpc_name
  region = var.region
  depends_on = [
    module.vpc
  ]
}

module "gcs" {
  source = "./modules/gcs"
  bucket_name = "www.the-stocker.com"
  storage_class = "STANDARD"
  resources = "./resources"
  certificate = local.ssl.certificate.filename
  key = local.ssl.key.filename
  region = var.region
  static_ip_name = "load-balancer-for-bucket-static-ip"
  objects = local.gcs.objects
}

module "cloud_run" {
  source = "./modules/cloud_run"
  services = local.cloud_run.services
  region = var.region
}

module "gateway" {
  source = "./modules/gateway"
  api_file_path = "./resources/gateway/api.yaml"
  static_ip_name = "load-balancer-for-gateway-static-ip"
  api_id = "api-gw"
  api_config_id = "api-gw-config"
  api_gw_id = "api-gw-gw"
  resources = "./resources"
  certificate = local.ssl.certificate.filename
  key = local.ssl.key.filename

  user_service_address = module.cloud_run.user_service_address
  post_service_address = module.cloud_run.post_service_address
  ama_service_address = module.cloud_run.ama_service_address
  feed_service_address = module.cloud_run.feed_service_address

  depends_on = [
    module.cloud_run
  ]
}

module "dns"{
  source = "./modules/dns"
  name = "the-stocker-dns-zone"
  dns_name = "the-stocker.com."
  dns_TTL = 300

  LB_bucket_static_ip = module.gcs.LB_static_ip

  depends_on = [
    module.gcs
  ]
}