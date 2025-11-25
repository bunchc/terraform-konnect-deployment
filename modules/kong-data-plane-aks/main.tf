resource "kubernetes_secret" "dp_tls_secret" {
  metadata {
    name      = "kong-dp-client-mtls"
    namespace = var.kubernetes_namespace
  }

  data = {
    "tls.crt" = base64encode(var.dp_client_cert)
    "tls.key" = base64encode(var.dp_client_key)
  }

  type = "kubernetes.io/tls"
}

resource "helm_release" "kong_gateway" {
  name       = "kong-gateway"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  namespace  = var.kubernetes_namespace
  create_namespace = true

  values = [
    templatefile("${path.module}/helm_values.yaml.tpl", {
      konnect_control_plane_id = var.konnect_control_plane_id,
      dp_tls_secret_name       = kubernetes_secret.dp_tls_secret.metadata.0.name
    })
  ]

  depends_on = [kubernetes_secret.dp_tls_secret]
}
