####  commands to help create and query Azure resources ####

# create role assignment between acr and aks
az aks update -n docatalog -g devops-catalog-aks --attach-acr devopscatalogaks

# destroy targeted resources only
terraform destroy --var k8s_version=<version> --target azurerm_kubernetes_cluster.primary
## AZURE ACR ##
az acr create --resource-group devops-catalog-aks --name devopscatalogaks --sku Basic


docker push devopscatalogaks.azurecr.io/go-demo-9:latest
docker tag randmeth:latest devopscatalogaks.azurecr.io/randmeth:latest
az acr build --image azure-vote-front:v1 --registry devopscatalogaks --file Dockerfile .

## DOCKER 
docker image ls 


## HELM ##
helm repo add stable https://charts.helm.sh/stable
helm search repo mongodb
helm show readme stable/mongodb
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency list go-demo-9
helm dependency update go-demo-9
helm -n production upgrade --install go-demo-9 go-demo-9 --wait --timeout 10m

#
curl -H "Host: go-demo-9.acme.com" "http://$INGRESS_HOST"

helm install release1 randmeth-campaigns-0.1.0.tgz
helm package helm

helm uninstall release1

az acr login --name devopscatalogaks
kubectl describe pod randmeth-campaigns-6d6ff5c4b6-jbtl9 -n randmeth
####################
# Create a Cluster #
####################

# This script assumes that you followed the instructions from the "Creating And Managing Google Kubernetes Engine (GKE) Clusters With Terraform" section" section.
# It assumes that you have:
# * The resource group *devops-catalog-aks*
# * The storage account *devopscatalog*
# * The storage container *devopscatalog*

# Make sure that you are inside the local copy of the devops-catalog-code repository

cd terraform-aks/minimal

terraform init

terraform plan --var-file="variables.tf"

az aks get-versions --location eastus

# Replace `[...]` with a valid orchestratorVersion from the previous output
export K8S_VERSION=[...]

terraform refresh \
    --var k8s_version=$K8S_VERSION

terraform plan --var-file="ctrl-plane-variables.tfvars"

terraform apply \
    --var k8s_version=$K8S_VERSION

az aks get-credentials --admin --name controlplane --resource-group platform-engineering-sg

# config in /Users/tiisetsokhalane/.kube/config
# other options

export KUBECONFIG=$PWD/kubeconfig

az aks get-credentials \
    --name $(terraform output --raw cluster_name) \
    --resource-group $(terraform output --raw resource_group) \
    --file \
    $KUBECONFIG


az aks get-credentials \
> --name $(terraform output --raw cluster_name) \
> --resource-group $(terraform output --raw resource_group)

kubectl get nodes

cd ../..

#

#############################
# Deploy Ingress Controller #
#############################

kubectl apply \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/cloud/deploy.yaml

export INGRESS_HOST=$(kubectl \
    --namespace ingress-nginx \
    get svc ingress-nginx-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $INGRESS_HOST



kubectl get pods -n ingress-nginx

# Repeat the `export` command if the output is empty

#######################
# Destroy The Cluster #
#######################

cd terraform-aks/minimal

terraform destroy \
    --var k8s_version=$K8S_VERSION \
    --target azurerm_kubernetes_cluster.primary

cd ../..

## 
#Obtain the IP address of the Azure Internal Load Balancer (ILB) associated with your AKS cluster.
#You can retrieve this information using the Azure CLI:

az aks show --resource-group <resource-group-name> --name <aks-cluster-name> --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName -o table

# If you have set up an Ingress resource without a Load Balancer service, you can use port-forwarding to access your application. Run the following command in your terminal:
kubectl port-forward service/myapp-service <local-port>:<target-port>

# to view the nginx configuration

kubectl logs ingress-nginx-controller-86b55bb769-qb258 -n ingress-nginx
#or
kubectl exec -it ingress-nginx-controller-86b55bb769-qb258 -n ingress-nginx -- /bin/sh
cd /etc/nginx/
cat nginx.conf

http://20.241.133.148:8080/api/v1/campaigns

#### argo cd #####
#https://argo-cd.readthedocs.io/en/stable/getting_started/?_gl=1*11oktsg*_ga*MTgxMTQwOTU3MC4xNjg5OTYzMDYw*_ga_5Z1VTPDL73*MTY4OTk2MzA1OS4xLjEuMTY4OTk2MzE1OC4wLjAuMA..
helm repo add argo https://argoproj.github.io/argo-helm
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
# password = KuT9MLefVE8IZoNe replaced with Password01#
#In order to access the server UI you have the following options:

#1. 
kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:443





#    and then open the browser on http://localhost:8080 and accept the certificate

#2, alternatively 
#To access the Argo CD web UI from outside the cluster, you need to expose the service.
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

https://20.231.250.3/settings
# after installing argocd via brew, and running the above, logged in with
export LB_HOST=above ip
argocd login --insecure --username admin --password Password01# --grpc-web argocd.$LB_HOST.nip.io
# to deploy from git
argocd app create randmeth-campaigns --repo https://github.com/tkhalane/mtnx-demo.git --path helm --dest-server https://kubernetes.default.svc --dest-namespace mtnx

#azure devops quirks
# used this token to create a repository on argocd ui following this https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/
# may access token = jclo2foprogp4l7xkopxao5lu3ahgdqgtd6quwp5v7vhjqlpb4za
# then viola!!

argocd app create randmeth-campaigns \
    --repo https://warehouse-africa@dev.azure.com/warehouse-africa/randmeth/_git/randmeth \
    --path helm \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace randmeth 


## github token
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

git remote set-url origin https://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@github.com/tkhalane/randmeth-campaigns.git
