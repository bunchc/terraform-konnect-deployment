# helm_values.yaml
env:
  KONG_ROLE: "data_plane"
  KONG_DATABASE: "off"
  KONG_CLUSTER_CERT: "/etc/secrets/kong-dp-client-mtls/tls.crt"
  KONG_CLUSTER_CERT_KEY: "/etc/secrets/kong-dp-client-mtls/tls.key"
  KONG_KONNECT_MODE: "on"
  KONG_KONNECT_CONTROL_PLANE_ID: "${konnect_control_plane_id}"
  KONG_KONNECT_TLS_CLIENT_CERT_FILE: "/etc/secrets/kong-dp-client-mtls/tls.crt"
  KONG_KONNECT_TLS_CLIENT_KEY_FILE: "/etc/secrets/kong-dp-client-mtls/tls.key"

secretVolumes:
  - kong-dp-client-mtls

ingressController:
  enabled: true
  installCRDs: false
