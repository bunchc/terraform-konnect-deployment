variable "konnect_control_plane_name" {
  description = "Name for the new Konnect Control Plane"
  type        = string
}

variable "konnect_teams" {
  description = "A map of teams to create in Konnect."
  type = map(object({
    description = string
    roles       = list(string)
  }))
  default = {}
}

variable "dp_client_cert_path" {
  description = "Path to the client certificate for the data plane."
  type        = string
  default     = ""
}

variable "dp_client_key_path" {
  description = "Path to the client key for the data plane."
  type        = string
  default     = ""
}

variable "kubernetes_namespace" {
  description = "The Kubernetes namespace to deploy the data plane to."
  type        = string
  default     = "default"
}

variable "konnect_pat" {
  description = "Kong Konnect Personal Access Token"
  type        = string
  sensitive   = true
}

