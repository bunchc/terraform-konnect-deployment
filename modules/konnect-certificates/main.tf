resource "konnect_gateway_data_plane_client_certificate" "cert" {
  cert             = var.certificate
  control_plane_id = var.control_plane_id
}
