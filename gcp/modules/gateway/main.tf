resource "google_api_gateway_api" "api_gw" {
  api_id = "api-gw"
  provider = google-beta
}

resource "google_api_gateway_api_config" "api_gw" {
  api = google_api_gateway_api.api_gw.api_id
  provider = google-beta
  api_config_id = "api-gw-config"

  openapi_documents {
    document {
      path = var.api_file_path
      contents = filebase64(var.api_file_path)
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    google_api_gateway_api.api_gw
  ]
}

resource "google_api_gateway_gateway" "api_gw" {
  api_config = google_api_gateway_api_config.api_gw.id
  provider = google-beta
  gateway_id = "api-gw-gw"
  depends_on = [
    google_api_gateway_api_config.api_gw
  ]
}