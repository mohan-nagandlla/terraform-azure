terraform {

    backend "azurerm" {
    resource_group_name  = "Global"
    storage_account_name = "aksstorageaccountmoahn"
    container_name       = "akscontianer"
    key                  = "terraform.tfstate"
  }
}


provider "azurerm" {
    features {}
}