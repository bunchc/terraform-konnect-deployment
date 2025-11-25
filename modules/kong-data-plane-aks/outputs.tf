output "helm_release_status" {
  description = "The status of the Helm release."
  value       = helm_release.kong_gateway.status
}
