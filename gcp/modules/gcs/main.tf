resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = false // No permite borrar el bucket si tiene objetos dentro
  storage_class = var.storage_class

  versioning {
    enabled     = true
  }

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  cors {
    origin          = ["http://${var.bucket_name}"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 2
      with_state = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }

#   lifecycle_rule {
#     condition {
#       days_since_noncurrent_time = 7
#     }
#     action {
#       type = "Delete"
#     }
#   }
}

resource "google_storage_default_object_access_control" "public_rule" {
  #count = var.website ? 1 : 0
  bucket = google_storage_bucket.bucket.name
  role   = "READER"
  entity = "allUsers"
  depends_on = [
    google_storage_bucket.bucket
  ]
}

resource "google_storage_bucket_object" "gcs_object" {
  for_each = var.objects

  bucket        = google_storage_bucket.bucket.name
  name          = each.value.filename
  source        = format("${var.path}/%s", each.value.filename) # where is the file located
  content_type  = each.value.content_type

  depends_on = [
    google_storage_default_object_access_control.public_rule,
  ]
}
