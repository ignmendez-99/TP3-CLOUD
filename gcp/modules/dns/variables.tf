variable "name" {
  description = "DNS zone name"
  type        = string
}

variable "dns_name" {
  description = "DNS zone name"
  type        = string
}

variable "dns_TTL" {
  description = "DNS time to live"
}

variable "LB_static_ip" {
  description = "Static IP´of the LB"
  type = string
}