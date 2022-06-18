variable "subnet_for_load_balancer_name" {
  description = "Name of the subnet"
  type        = string
  default     = "the-stocker-subnet-for-load-balancer"
}

variable "cidr_range_subnet_for_load_balancer" {
  description = "CIDR range"
  type        = string
  default     = "10.0.0.0/27"
}

variable "subnet_for_cloud_sql_name" {
  description = "Name of the subnet"
  type        = string
  default     = "the-stocker-subnet-for-cloud-sql"
}

variable "cidr_range_subnet_for_cloud_sql" {
  description = "CIDR range"
  type        = string
  default     = "10.1.0.0/23"
}

variable "vpc_name" {
}

variable "region"{
}


