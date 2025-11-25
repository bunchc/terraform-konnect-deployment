# Recipe 0: Setting Up Your Project and Prerequisites

This recipe walks you through setting up the necessary tools and the
foundational directory structure for your Terraform project. Completing these
steps is essential for following the subsequent recipes and successfully
managing your Kong Konnect environment.

## Getting ready

This section covers the required tools and accounts you'll need before you
start writing any Terraform code.

- **Terraform v1.0+:** The core tool for managing your infrastructure.
- **Kong Konnect Account:** You'll need an account to manage your Control
  Planes.
- **Kong Konnect Personal Access Token (PAT):** For authenticating with the
  Konnect API.
- **Microsoft Azure Account & CLI:** For creating and managing the AKS cluster
  for your Data Planes.
- **An existing AKS Cluster & `kubeconfig`:** The target Kubernetes
  environment.
- **OpenSSL:** For generating mTLS certificates.

## How to do it…

1. First, create the root directory for your project and the core module and
   environment directories:

    ```bash
    mkdir terraform-konnect-deployment
    cd terraform-konnect-deployment
    mkdir -p environments/dev modules
    ```

2. Next, create placeholder files in the root of your project. These will be
   populated in later recipes.

    ```bash
    touch main.tf variables.tf outputs.tf providers.tf terraform.tfvars
    ```

3. Finally, create the directory structure for the first module,
   `konnect-control-plane`:

    ```bash
    mkdir -p modules/konnect-control-plane
    touch modules/konnect-control-plane/main.tf
    touch modules/konnect-control-plane/variables.tf
    touch modules/konnect-control-plane/outputs.tf
    ```

## How it works…

This initial setup creates a modular Terraform project structure that separates
reusable components (modules) from environment-specific configurations
(environments).

- **`modules/`:** This directory will contain reusable modules for creating
  Konnect resources like Control Planes, Teams, and Data Planes.
- **`environments/`:** This directory contains the configuration for each of
  your environments (e.g., `dev`, `staging`, `prod`). Each environment will
  have its own `main.tf` to call the reusable modules.
- **Root files:** The files in the root of the project are used for top-level
  configuration and outputs.

## See also

- [Official Terraform Documentation](https://www.terraform.io/docs)
- [Kong Konnect Documentation](https://docs.konghq.com/konnect/)
