variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "storage_class" {
  description = "Storage class"
  type        = string
}

variable "path" {
  description = "Path to website files"
  type        = string
}

variable "objects" {
  description = "Objects that will be added to the bucket"
  type        = map(any)
}

variable "region" {
  description = "Region of the bucket"
  type        = string
}
