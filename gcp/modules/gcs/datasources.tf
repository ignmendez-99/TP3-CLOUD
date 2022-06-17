data "google_dns_managed_zone" "public" {
  project = var.project
  name = "the-stocker-dns-managed-zone"
}