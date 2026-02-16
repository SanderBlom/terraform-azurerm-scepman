terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0, < 4.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.42, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}
