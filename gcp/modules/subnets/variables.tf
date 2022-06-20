variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "region"{
  description = "Region of the subnets"
  type        = string
}


variable subnets {
  description = "Subnets object with properties"
  type = map(object({
          name = string
          cidr_range = string
        }))
}