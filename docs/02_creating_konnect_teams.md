# Recipe 2: Creating Konnect Teams

This recipe demonstrates how to create a reusable Terraform module to manage
Teams in Kong Konnect and assign roles to them. Organizing users into teams is
a crucial step for managing access control and enforcing security policies
within your organization.

## Getting ready

Before you begin, ensure you have completed the previous recipes:

- [Recipe 0: Setting Up Your Project and Prerequisites](00_prerequisites.md)
- [Recipe 1: Creating a Konnect Control Plane](01_creating_control_plane.md)

You will also need to create the directory for the `konnect-teams` module:

```bash
mkdir -p modules/konnect-teams
touch modules/konnect-teams/main.tf
touch modules/konnect-teams/variables.tf
```

## How to do it…

1. First, define the `konnect_team` and `konnect_team_role` resources in
   `modules/konnect-teams/main.tf`.

    ```terraform
    resource "konnect_team" "team" {
      name        = var.name
      description = var.description
    }

    resource "konnect_team_role" "team_role" {
      for_each = toset(var.roles)
      team_id  = konnect_team.team.id
      role     = each.key
    }
    ```

2. Next, define the input variables for the module in
   `modules/konnect-teams/variables.tf`:

    ```terraform
    variable "name" {
      description = "The name of the Konnect Team."
      type        = string
    }

    variable "description" {
      description = "The description of the Konnect Team."
      type        = string
      default     = null
    }

    variable "roles" {
      description = "A list of roles to assign to the team."
      type        = list(string)
      default     = []
    }
    ```

3. In your `environments/dev/main.tf`, call the `konnect-teams` module using a
   `for_each` loop to create multiple teams:

    ```terraform
    module "konnect_teams" {
      source = "../../modules/konnect-teams"

      for_each = var.konnect_teams

      name        = each.key
      description = each.value.description
      roles       = each.value.roles
    }
    ```

4. Define the `konnect_teams` variable in your `environments/dev/variables.tf`
   as a map of objects:

    ```terraform
    variable "konnect_teams" {
      description = "A map of teams to create in Konnect."
      type = map(object({
        description = string
        roles       = list(string)
      }))
      default = {}
    }
    ```

5. In your `environments/dev/terraform.tfvars` file, define the teams you
   want to create:

    ```terraform
    konnect_teams = {
      "PlatformAdmins" = {
        description = "Team for managing the Konnect platform"
        roles       = ["Admin"]
      },
      "APIDevelopers" = {
        description = "Team for API developers"
        roles       = ["Viewer"]
      }
    }
    ```

6. Finally, run `terraform apply` from the `environments/dev` directory to
   create the teams:

    ```text
    cd environments/dev
    terraform apply

    # Expected Output Snippet
    module.konnect_teams["PlatformAdmins"].konnect_team.team: Creating...
    module.konnect_teams["APIDevelopers"].konnect_team.team: Creating...
    ```

## How it works…

This configuration uses a module to automate the creation of multiple teams and
their role assignments.

- **Steps 1-2:** These steps create a reusable module for managing Konnect
  teams and their associated roles.
- **Step 3:** The `module "konnect_teams"` block uses a `for_each` loop to
  iterate over the `var.konnect_teams` map. This allows you to create
  multiple teams with different properties from a single module block.
- **Steps 4-5:** The `variables.tf` and `terraform.tfvars` files are used to
  define and provide the necessary variables for the configuration.

## There's more…

- **Adding New Teams:** To add a new team, you simply need to add a new entry to
  the `konnect_teams` map in your `terraform.tfvars` file.
- **Centralized Team Management:** This modular approach allows you to manage all
  your teams from a central variable definition, making it easy to see and
  manage team structures.

## See also

- *Recipe 3: Uploading Custom Certificates*
- [Konnect RBAC Documentation](https://docs.konghq.com/konnect/org/teams-and-roles/rbac/)
