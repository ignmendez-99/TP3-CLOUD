module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_name = module.vpc.vpc_name
  region = var.region
  depends_on = [
    module.vpc
  ]
}