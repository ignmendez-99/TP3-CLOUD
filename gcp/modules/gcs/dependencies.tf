# ---------------------------------------------------------------------------------------------------------------------
# CREATE OPTIONAL CNAME ENTRY IN CLOUD DNS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "cname" {
  provider = google-beta
  count    = var.website ? 1 : 0

  project = var.project

  name         = "${var.bucket_name}."
  managed_zone = data.google_dns_managed_zone.public.name
  type         = "CNAME"
  ttl          = 3600
  rrdatas      = ["c.storage.googleapis.com."]
  depends_on = [google_storage_bucket.this]
}