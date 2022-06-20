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
  path = "./resources/html"
  region = var.region
  objects = local.gcs.objects
}

module "dns"{ 
  source = "./modules/dns"
  name = "the-stocker-dns-zone"
  dns_name = "the-stocker.com."
  dns_TTL = 300
  depends_on = [
    module.gcs
  ]
}