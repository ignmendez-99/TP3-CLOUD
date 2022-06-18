variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "the-stocker-2022"
}

variable "region" {
  description = "Region where every regional resource will be"
  type        = string
  default     = "us-central1"
}

# variable "gcp_credentials" {
#   type = string
#   sensitive = true
#   description = "Google Cloud service account credentials"
# }