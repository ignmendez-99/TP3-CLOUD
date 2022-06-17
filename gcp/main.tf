module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./module/subnets"
}