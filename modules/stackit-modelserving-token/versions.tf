terraform {
  required_version = ">= 1.6.0"

  required_providers {
    stackit = {
      source  = "stackitcloud/stackit"
      version = ">= 0.47.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.9.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.4.0"
    }
  }
}
