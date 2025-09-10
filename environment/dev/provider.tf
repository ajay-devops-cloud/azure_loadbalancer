terraform {
    backend "azurerm" {
      resource_group_name = "rg-it"
      storage_account_name = "itsolution2"
      container_name = "nextlevelcontainer"
      key = "myt.tfstate"
    }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.42.0"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  subscription_id = "c05900c4-9a99-417d-878e-413b907a6035"
}