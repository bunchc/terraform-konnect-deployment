resource "konnect_team" "team" {
  name        = var.name
  description = var.description
}

resource "konnect_team_role" "team_role" {
  for_each         = toset(var.roles)
  team_id          = konnect_team.team.id
  role_name        = each.value
  entity_id        = var.control_plane_id
  entity_type_name = "Control Planes"
  entity_region    = "*"
}
