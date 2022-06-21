resource "google_api_gateway_api" "api_gw" {
  api_id = var.api_id
  provider = google-beta
}

data "template_file" "data" {
  template = "${file(var.api_file_path)}"
  vars = {
    user_service_url  = var.user_service_address
    post_service_url  = var.post_service_address
    ama_service_url  = var.ama_service_address
    feed_service_url  = var.feed_service_address
  }
}

resource "google_api_gateway_api_config" "api_gw" {
  api = google_api_gateway_api.api_gw.api_id
  provider = google-beta
  api_config_id = var.api_config_id

  openapi_documents {
    document {
      path = var.api_file_path
      # contents = filebase64(var.api_file_path)
      contents = base64encode(data.template_file.data.rendered)
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
  gateway_id = var.api_gw_id
  depends_on = [
    google_api_gateway_api_config.api_gw
  ]
}

#########################
#      LB STATIC IP     #
#########################
resource "google_compute_global_address" "static_ip" {
  name        = var.static_ip_name
  description = "Static external IP address for load balancer"
  address_type  = "EXTERNAL"
}

#########################
#    SSL CERTIFICATE    #  (comentar para poder hacer el terraform apply, ya que no tenemos certificados)
#########################
# resource "google_compute_ssl_certificate" "ssl" {
#   name        = "${var.api_gw_id}-ssl-certificate"
#   private_key = file("${var.resources}/${var.key}")
#   certificate = file("${var.resources}/${var.certificate}")
#   depends_on = [
#     google_api_gateway_gateway.api_gw
#   ]
# }

resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "cloud-run-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  provider = google-beta
  serverless_deployment {
    platform = "apigateway.googleapis.com"
    resource = google_api_gateway_gateway.api_gw.id
  }
}

resource "google_compute_backend_service" "backend" {
  name      = "${var.api_gw_id}-backend-service"
  # protocol  = "HTTPS"
  # port_name = "https"
  # timeout_sec = 30
  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }
}

#########################
#     HTTPS URL_MAP     #  (comentar para poder hacer el terraform apply, ya que no tenemos certificados)
#########################
# resource "google_compute_url_map" "static_https" {
#   name        = "${var.api_gw_id}-url-map"
#   default_service = google_compute_backend_service.backend.id
#   depends_on = [
#     google_compute_backend_service.backend
#   ]
# }

#########################
#      HTTPS PROXY      #  (comentar para poder hacer el terraform apply, ya que no tenemos certificados)
#########################
# resource "google_compute_target_https_proxy" "static_https" {
#   name             = "${var.api_gw_id}-static-https-proxy"
#   url_map          = google_compute_url_map.static_https.id
#   ssl_certificates = [google_compute_ssl_certificate.ssl.id]
#   depends_on = [
#     google_compute_ssl_certificate.ssl,
#     google_compute_url_map.static_https
#   ]
# }

#########################
# HTTPS FORWARDING RULE #  (comentar para poder hacer el terraform apply, ya que no tenemos certificados)
#########################
# resource "google_compute_global_forwarding_rule" "static_https" {
#   name       = "${var.api_gw_id}-static-forwarding-rule-https"
#   target     = google_compute_target_https_proxy.static_https.id
#   port_range = "443"
#   ip_address = google_compute_global_address.static_ip.id
#   depends_on = [
#     google_compute_target_https_proxy.static_https,
#     google_compute_global_address.static_ip
#   ]
# }


#########################
#     HTTP URL_MAP      #
#########################
# Partial HTTP load balancer redirects to HTTPS
resource "google_compute_url_map" "static_http" {
  name = "${var.api_gw_id}-static-http-redirect"

  ##### BORRAR #####
  default_service = google_compute_backend_service.backend.id
  depends_on = [
    google_compute_backend_service.backend
  ]
  ##### BORRAR #####

  # default_url_redirect {
  #   https_redirect = true
  #   strip_query    = false
  # }
}

#########################
#      HTTP PROXY       #
#########################
resource "google_compute_target_http_proxy" "static_http" {
  name    = "${var.api_gw_id}-static-http-proxy"
  url_map = google_compute_url_map.static_http.id
  depends_on = [
    google_compute_url_map.static_http
  ]
}

#########################
# HTTP FORWARDING RULE  #
#########################
resource "google_compute_global_forwarding_rule" "static_http" {
  name       = "${var.api_gw_id}-static-forwarding-rule-http"
  target     = google_compute_target_http_proxy.static_http.id
  port_range = "80"
  ip_address = google_compute_global_address.static_ip.id
  depends_on = [
    google_compute_target_http_proxy.static_http,
    google_compute_global_address.static_ip
  ]
}