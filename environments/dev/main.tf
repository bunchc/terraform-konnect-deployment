module "konnect_control_plane" {
  source = "../../modules/konnect-control-plane"

  providers = {
    konnect = konnect
  }

  name        = var.konnect_control_plane_name
  description = "Development Control Plane"
}

module "konnect_teams" {
  source = "../../modules/konnect-teams"

  providers = {
    konnect = konnect
  }

  for_each = var.konnect_teams

  name             = each.key
  description      = each.value.description
  roles            = each.value.roles
  control_plane_id = module.konnect_control_plane.id
}

module "konnect_certificates" {
  source = "../../modules/konnect-certificates"

  providers = {
    konnect = konnect
  }

  certificate      = file(var.dp_client_cert_path)
  control_plane_id = module.konnect_control_plane.id
}

module "kong_data_plane_aks" {
  source = "../../modules/kong-data-plane-aks"

  konnect_control_plane_id = module.konnect_control_plane.id
  kubernetes_namespace     = var.kubernetes_namespace
  dp_client_cert           = file(var.dp_client_cert_path)
  dp_client_key            = file(var.dp_client_key_path)
}

