resource "random_string" "main" {
  length  = 8
  special = false
  upper   = false
}
resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name != "" ? var.container_registry_name : "${random_string.main.result}"
  resource_group_name = var.resource_group
  admin_enabled       = true
  location            = var.region
  sku                 = "Premium"
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.main.object_id
  depends_on = [
    azurerm_container_registry.main,
    azuread_application.main
  ]
}

resource "azuread_application" "main" {
  # name = azurerm_kubernetes_cluster.main.name
  display_name = azurerm_kubernetes_cluster.main.name
}

resource "azuread_service_principal" "main" {
  application_id               = azuread_application.main.application_id
  app_role_assignment_required = false
}

data "azurerm_subscription" "main" {}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "KUBECONFIG=$PWD/kubeconfig az aks get-credentials --name ${var.cluster_name} --resource-group ${var.resource_group} --file $PWD/kubeconfig"
  }
  depends_on = [
    azurerm_kubernetes_cluster.main,
  ]
}

resource "null_resource" "destroy-kubeconfig" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f $PWD/kubeconfig"
  }
}


/*
  # azurerm_container_registry.main will be created
  + resource "azurerm_container_registry" "main" {
      + admin_enabled                 = true
      + admin_password                = (sensitive value)
      + admin_username                = (known after apply)
      + encryption                    = (known after apply)
      + export_policy_enabled         = true
      + id                            = (known after apply)
      + location                      = "eastus"
      + login_server                  = (known after apply)
      + name                          = "devopscatalogacr"
      + network_rule_bypass_option    = "AzureServices"
      + network_rule_set              = (known after apply)
      + public_network_access_enabled = true
      + resource_group_name           = "devops-catalog-aks"
      + retention_policy              = (known after apply)
      + sku                           = "Premium"
      + trust_policy                  = (known after apply)
      + zone_redundancy_enabled       = false
    }

  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "devops-catalog-aks"
    }

  # azurerm_role_assignment.acrpull_role will be created
  + resource "azurerm_role_assignment" "acrpull_role" {
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = "27dddc14-e989-4266-a987-3b55719ef8c9"
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "AcrPull"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = (known after apply)
    }

  # null_resource.kubeconfig will be created
  + resource "null_resource" "kubeconfig" {
      + id = (known after apply)
    }
*/
