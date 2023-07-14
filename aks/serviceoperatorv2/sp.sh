{
  "appId": "dd78857e-7a60-46b8-9481-ff2714046f3f",
  "displayName": "azure-service-operator",
  "password": "1Ee8Q~Ijp~mfV3FAz2UcQw3YGdmYAzmYCFVSLamP",
  "tenant": "edcf8722-9d07-4a3a-b131-7554ed252e53"
}

# --
helm upgrade --install aso2 aso2/azure-service-operator \
     --create-namespace \
     --namespace=azureserviceoperator-system \
     --set azureSubscriptionID=$AZURE_SUBSCRIPTION_ID \
     --set azureTenantID=$AZURE_TENANT_ID \
     --set azureClientID=$AZURE_CLIENT_ID \
     --set azureClientSecret=$AZURE_CLIENT_SECRET \
     --set crdPattern='documentdb.azure.com/*;resources.azure.com/*;containerservice.azure.com/*;keyvault.azure.com/*;managedidentity.azure.com/*;eventhub.azure.com/*'