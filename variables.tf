variable "konnect_pat" {
  description = "Kong Konnect Personal Access Token"
  type        = string
  sensitive   = true
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the AKS cluster"
  type        = string
  default     = "~/.kube/config"
}

variable "dp_client_cert_path" {
  description = "Path to the Data Plane client certificate file (tls.crt)"
  type        = string
}

variable "dp_client_key_path" {
  description = "Path to the Data Plane client key file (tls.key)"
  type        = string
}

variable "konnect_control_plane_name" {
  description = "Name for the new Konnect Control Plane"
  type        = string
  default     = "aks-dataplane-cp"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace to deploy the Kong Gateway into"
  type        = string
  default     = "kong"
}

variable "konnect_teams" {
  description = "A map of teams to create in Konnect."
  type = map(object({
    description = string
    roles       = list(string)
  }))
  default = {}
}

