terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.0.1"
    }
  }


  backend "azurerm" {
    resource_group_name  = "RG-Dheeru39"
    storage_account_name = "stddheeru39"
    container_name       = "tfstate-container"
    key                  = "Dev.terraform.tfstate"
  }


}

provider "azurerm" {
  features {}
}
