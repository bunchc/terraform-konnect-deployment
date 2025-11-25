# Recipe 1: Creating a Konnect Control Plane

This recipe walks you through creating a reusable Terraform module to provision
a Kong Konnect Control Plane. A Control Plane is the central management point
for your API gateways, and using a module is the foundational step for
managing your services in a scalable and maintainable way.

## Getting ready

Before you begin, ensure you have completed the steps in the prerequisites
guide to set up your project structure and tools:

- [Recipe 0: Setting Up Your Project and Prerequisites](00_prerequisites.md)

## How to do it…

1. First, define the `konnect_gateway_control_plane` resource in your
   `modules/konnect-control-plane/main.tf` file. This will be the core of your
   reusable module.

    ```terraform
    resource "konnect_gateway_control_plane" "cp" {
      name        = var.name
      description = var.description
    }
    ```

2. Next, define the input variables for the module in
   `modules/konnect-control-plane/variables.tf`:

    ```terraform
    variable "name" {
      description = "The name of the Konnect Control Plane."
      type        = string
    }

    variable "description" {
      description = "The description of the Konnect Control Plane."
      type        = string
      default     = null
    }
    ```

3. Define the output for the module in
   `modules/konnect-control-plane/outputs.tf`. This will expose the ID of the
   created control plane.

    ```terraform
    output "id" {
      description = "The ID of the Konnect Control Plane."
      value       = konnect_gateway_control_plane.cp.id
    }
    ```

4. Now, in your `environments/dev/main.tf`, call the `konnect-control-plane`
   module to create the control plane in your development environment.

    ```terraform
    module "konnect_control_plane" {
      source = "../../modules/konnect-control-plane"

      name        = var.konnect_control_plane_name
      description = "Development Control Plane"
    }
    ```

5. Define the necessary variables in your `environments/dev/variables.tf`
   file:

    ```terraform
    variable "konnect_pat" {
      description = "Kong Konnect Personal Access Token"
      type        = string
      sensitive   = true
    }

    variable "konnect_control_plane_name" {
      description = "Name for the new Konnect Control Plane"
      type        = string
    }
    ```

6. Create a `terraform.tfvars` file in the `environments/dev` directory and
   add your Konnect PAT and the desired control plane name:

    ```terraform
    konnect_pat                = "your-konnect-pat"
    konnect_control_plane_name = "dev-aks-cp"
    ```

7. Finally, run `terraform apply` from the `environments/dev` directory to
   create the resource:

    ```text
    cd environments/dev
    terraform init
    terraform apply

    # Expected Output Snippet
    module.konnect_control_plane.konnect_gateway_control_plane.cp: Creating...
    module.konnect_control_plane.konnect_gateway_control_plane.cp: Creation
    complete after 1s [id=your-cp-id]
    ```

## How it works…

This Terraform configuration uses a module to abstract the creation of a
Konnect Control Plane, making it reusable across different environments.

- **Steps 1-3:** These steps create a self-contained, reusable module for the
  Konnect Control Plane. It defines the necessary resource, input variables,
  and outputs.
- **Step 4:** The `module "konnect_control_plane"` block in your
  environment's `main.tf` calls the reusable module, passing in
  environment-specific values.
- **Steps 5-6:** The `variables.tf` and `terraform.tfvars` files are used to
  define and provide the necessary variables for the development
  environment.

## Troubleshooting

- **401 Unauthorized Error:** If you encounter a `401 Unauthorized` error, it
  means your `konnect_pat` is invalid or lacks the necessary permissions.
  Generate a new token in the Konnect UI and update your `terraform.tfvars`
  file.

## See also

- [Official Konnect Provider Documentation](https://registry.terraform.io/providers/kong/konnect/latest/docs)
