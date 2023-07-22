export CUSTOM_BP_PATH="https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/blueprints/argo-blueprints.json"
export CONFIG_YAML_URL="https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/templates/argo-kubernetes_v1_config.yaml"

export CLUSTER_NAME="my-cluster"
export PORT_CLIENT_ID="my-port-client-id"
export PORT_CLIENT_SECRET="my-port-client-secret"
curl -s https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/install.sh | bash