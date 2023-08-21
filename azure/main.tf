terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
	skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "appgrp" {
	name = "app-grp"
	location = "West Europe"
}

resource "azurerm_storage_account" "appstorewrc" {
  name                     = "appstorewrc"
  resource_group_name      = azurerm_resource_group.appgrp.name
  location                 = azurerm_resource_group.appgrp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.appstorewrc.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "maintf.tf"
  storage_account_name   = azurerm_storage_account.appstorewrc.name
  storage_container_name = azurerm_storage_container.data.name
  type                   = "Block"
  source                 = "main.tf"
}