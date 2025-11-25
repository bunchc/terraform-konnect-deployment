terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "3.4.2"
    }
  }
}

provider "konnect" {
  personal_access_token = var.konnect_pat
}
