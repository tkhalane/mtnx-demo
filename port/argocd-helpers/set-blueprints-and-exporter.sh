# export CUSTOM_BP_PATH="https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/blueprints/argo-blueprints.json"
export CUSTOM_BP_PATH="https://raw.githubusercontent.com/tkhalane/mtnx-demo/main/port/argocd-helpers/argo-blueprints.json"
export CONFIG_YAML_URL="https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/templates/argo-kubernetes_v1_config.yaml"
# export CONFIG_YAML_URL="https://raw.githubusercontent.com/tkhalane/mtnx-demo/main/port/argocd-helpers/exporter-config.yaml"

export CLUSTER_NAME="docker-desktop"
# export PORT_CLIENT_ID="ds"
# export PORT_CLIENT_SECRET="sd"
curl -s https://raw.githubusercontent.com/port-labs/template-assets/main/kubernetes/install.sh | bash