region                  = "southafricanorth"
resource_group          = "platform-engineering-rg"
cluster_name            = "controlplane"
dns_prefix              = "controlplane"
container_registry_name = "platformengacr"
storage_account         = "platformengineeringsa"
container_name          = "platformengineeringcnt"
k8s_version             = "1.26.3"
machine_type            = "Standard_D3_v2"
min_node_count          = 2
