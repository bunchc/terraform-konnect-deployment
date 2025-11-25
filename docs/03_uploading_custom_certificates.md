# Recipe 3: Uploading Custom Certificates

This recipe explains how to create a reusable Terraform module to upload a
custom client certificate to Kong Konnect. This is a critical step for
securing the communication between your Konnect Control Plane and your Data
Planes using mutual TLS (mTLS).

## Getting ready

Before you begin, ensure you have completed the previous recipes:

- [Recipe 0: Setting Up Your Project and Prerequisites](00_prerequisites.md)
- [Recipe 1: Creating a Konnect Control Plane](01_creating_control_plane.md)

You will also need to create the directory for the `konnect-certificates`
module:

```bash
mkdir -p modules/konnect-certificates
touch modules/konnect-certificates/main.tf
touch modules/konnect-certificates/variables.tf```

## How to do it…

1. First, define the `konnect_gateway_data_plane_client_certificate` resource
   in `modules/konnect-certificates/main.tf`.

    ```terraform
    resource "konnect_gateway_data_plane_client_certificate" "cert" {
      cert = var.certificate
    }
    ```

2. Next, define the input variables for the module in
   `modules/konnect-certificates/variables.tf`:

    ```terraform
    variable "certificate" {
      description = "The client certificate in PEM format."
      type        = string
    }
    ```

3. In your `environments/dev/main.tf`, call the `konnect-certificates`
   module:

    ```terraform
    module "konnect_certificates" {
      source = "../../modules/konnect-certificates"

      certificate = file(var.dp_client_cert_path)
    }
    ```

4. Define the `dp_client_cert_path` variable in your
   `environments/dev/variables.tf` file:

    ```terraform
    variable "dp_client_cert_path" {
      description = "Path to the Data Plane client certificate file (tls.crt)"
      type        = string
    }
    ```

5. Finally, run `terraform apply` from the `environments/dev` directory after
   setting the variable path in your `terraform.tfvars` file:

    ```text
    # In your environments/dev/terraform.tfvars file:
    dp_client_cert_path = "path/to/your/tls.crt"

    # Run apply
    cd environments/dev
    terraform apply
    ```

## How it works…

This configuration uses a module to read your local certificate file and
upload it to Konnect.

- **Steps 1-2:** These steps create a reusable module for uploading a client
  certificate to Konnect.
- **Step 3:** The `module "konnect_certificates"` block in your
  environment's `main.tf` calls the reusable module. It uses the `file()`
  function to read the contents of the certificate and pass it to the
  module.

## There's more…

- **Certificate Rotation:** To rotate a certificate, you can update the file
  path in your `terraform.tfvars` file to point to the new certificate, and
  then run `terraform apply`.

## See also

* *Recipe 4: Deploying Data Planes*
* [Terraform `file()` function documentation](https://www.terraform.io/language/functions/file)
