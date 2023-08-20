terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.70.0"
    }
  }
}

provider "azurerm" {
  # subscription_id = "e162899f-c381-4b35-b365-7bb62c579153"
	# tenant_id = "276c04a4-9964-4437-9690-331b175c05f0"
	# client_id = "0e38939d-d22e-4144-b325-0f4ee2664944"
	# client_secret = "hdo8Q~-mx9XugyTjVFnY1ih11bcyn0Ko5AyPtb9T"

	features {}
}

resource "azurerm_resource_group" "appgrp" {
	name = "app-grp"
	location = "West Europe"
}