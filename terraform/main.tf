provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "platform-engineering-sg"
    storage_account_name = "platformengineeringsa" 
    container_name       = "platformengineeringcnt"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.region
  resource_group_name = var.resource_group
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.k8s_version
  default_node_pool {
    name                = var.cluster_name
    vm_size             = var.machine_type
    enable_auto_scaling = true
    max_count           = var.max_node_count
    min_count           = var.min_node_count
  }
  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_storage_account" "state" {
#   name                     = var.storage_account
#   resource_group_name      = var.resource_group
#   location                 = var.region
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   # allow_blob_public_access = true
# }

# resource "azurerm_storage_container" "state" {
#   name                  = var.container_name
#   storage_account_name  = azurerm_storage_account.state.name
#   container_access_type = "blob"
# }

# resource "azurerm_resource_group" "main" {
#   name     = var.resource_group != "" ? var.resource_group : "${random_string.main.result}"
#   location = var.region
# }