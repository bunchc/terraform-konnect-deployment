variable "name" {
  description = "The name of the Konnect team."
  type        = string
}

variable "description" {
  description = "The description of the Konnect team."
  type        = string
  default     = null
}

variable "roles" {
  description = "A list of roles to assign to the team."
  type        = list(string)
  default     = []
}

variable "control_plane_id" {
  description = "The ID of the control plane to which the team belongs."
  type        = string
}
