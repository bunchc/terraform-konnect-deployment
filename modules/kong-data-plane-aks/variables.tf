variable "konnect_control_plane_id" {
  description = "The ID of the Konnect Control Plane to connect to."
  type        = string
}

variable "kubernetes_namespace" {
  description = "The Kubernetes namespace to deploy into."
  type        = string
  default     = "kong"
}

variable "dp_client_cert" {
  description = "The client certificate for the Data Plane."
  type        = string
}

variable "dp_client_key" {
  description = "The client key for the Data Plane."
  type        = string
  sensitive   = true
}
