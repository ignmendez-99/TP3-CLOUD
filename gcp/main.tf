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
  static_ip_name = "load-balancer-static-ip"
  objects = local.gcs.objects
}

module "dns"{
  source = "./modules/dns"
  name = "the-stocker-dns-zone"
  dns_name = "the-stocker.com."
  dns_TTL = 300

  LB_static_ip = module.gcs.LB_static_ip

  depends_on = [
    module.gcs
  ]
}

module "cloud_run" {
  source = "./modules/cloud_run"
  services = local.cloud_run.services
  region = var.region
}

module "gateway" {
  source = "./modules/gateway"
  api_file_path = "./resources/gateway/api.yaml"
}