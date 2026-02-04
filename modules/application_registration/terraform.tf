terraform {
  required_providers {
    azuread = {
      source  = "glueckkanja/azuread"
      version = ">= 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}
