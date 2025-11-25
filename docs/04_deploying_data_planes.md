# Recipe 4: Deploying a Kong Gateway Data Plane

This final recipe shows how to create a reusable Terraform module to deploy a
Kong Gateway Data Plane to an Azure Kubernetes Service (AKS) cluster. The
module wraps the official Kong Helm chart and configures the Data Plane to
connect to the Konnect Control Plane.

## Getting ready

Before you begin, ensure you have completed the previous recipes:

- [Recipe 0: Setting Up Your Project and Prerequisites](00_prerequisites.md)
- [Recipe 1: Creating a Konnect Control Plane](01_creating_control_plane.md)
- [Recipe 3: Uploading Custom Certificates](03_uploading_custom_certificates.md)

You will also need to create the directory for the `kong-data-plane-aks`
module:

```bash
mkdir -p modules/kong-data-plane-aks
touch modules/kong-data-plane-aks/main.tf
touch modules/kong-data-plane-aks/variables.tf
touch modules/kong-data-plane-aks/helm_values.yaml.tpl
```

## How to do it…

1. First, define the Kubernetes secret and Helm release in
   `modules/kong-data-plane-aks/main.tf`.

    ```terraform
    resource "kubernetes_secret" "konnect_dp_cert" {
      metadata {
        name      = "konnect-dp-cert"
        namespace = var.kubernetes_namespace
      }

      data = {
        "tls.crt" = var.dp_client_cert
        "tls.key" = var.dp_client_key
      }
    }

    resource "helm_release" "kong_gateway" {
      name       = "kong-gateway"
      repository = "https://charts.konghq.com"
      chart      = "kong"
      namespace  = var.kubernetes_namespace

      values = [
        templatefile("${path.module}/helm_values.yaml.tpl", {
          konnect_control_plane_id = var.konnect_control_plane_id
        })
      ]
    }
    ```

2. Next, define the input variables for the module in
   `modules/kong-data-plane-aks/variables.tf`:

    ```terraform
    variable "konnect_control_plane_id" {
      description = "The ID of the Konnect Control Plane."
      type        = string
    }

    variable "kubernetes_namespace" {
      description = "The Kubernetes namespace to deploy the Data Plane to."
      type        = string
    }

    variable "dp_client_cert" {
      description = "The client certificate for the Data Plane."
      type        = string
    }

    variable "dp_client_key" {
      description = "The client key for the Data Plane."
      type        = string
    }
    ```

3. Create the Helm values template in
   `modules/kong-data-plane-aks/helm_values.yaml.tpl`:

    ```yaml
    ---
    image:
      repository: kong/kong-gateway
      tag: "3.4"

    env:
      role: data_plane
      database: "off"
      cluster_cert: /etc/secrets/konnect-dp-cert/tls.crt
      cluster_cert_key: /etc/secrets/konnect-dp-cert/tls.key
      konnect_control_plane_id: ${konnect_control_plane_id}

    secretVolumes:
      - konnect-dp-cert
    ```

4. In your `environments/dev/main.tf`, call the `kong-data-plane-aks` module:

    ```terraform
    module "kong_data_plane_aks" {
      source = "../../modules/kong-data-plane-aks"

      konnect_control_plane_id = module.konnect_control_plane.id
      kubernetes_namespace     = var.kubernetes_namespace
      dp_client_cert           = file(var.dp_client_cert_path)
      dp_client_key            = file(var.dp_client_key_path)
    }
    ```

5. Finally, run `terraform apply` from the `environments/dev` directory to
   deploy the Data Plane:

    ```text
    cd environments/dev
    terraform apply

    # Expected Output Snippet
    module.kong_data_plane_aks.helm_release.kong_gateway: Creating…
    module.kong_data_plane_aks.helm_release.kong_gateway: Creation complete
    after 25s [id=kong-gateway]
    ```

## How it works…

This configuration uses a module to deploy the Kong Gateway as a Helm release
into your Kubernetes cluster.

- **Steps 1-3:** These steps create a reusable module that encapsulates the
  logic for creating the Kubernetes secret and deploying the Kong Helm chart.
- **Step 4:** The `module "kong_data_plane_aks"` block calls the reusable
  module, passing in the necessary variables from your environment.

## There's more…

- **Custom Helm Values:** The `helm_values.yaml.tpl` file within the module
  contains the specific configuration needed to run Kong in Konnect mode. You
  can add any other valid Kong Helm chart values to this file to customize
  your deployment further.
- **Multiple Data Planes:** You can deploy multiple Data Planes to different
  clusters or namespaces by calling this module multiple times with
  different variable values.

## See also

- [Official Kong Helm Chart](https://github.com/Kong/charts/tree/main/charts/kong)
- [Terraform Helm Provider Documentation](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
