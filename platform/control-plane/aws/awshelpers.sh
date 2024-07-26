# start

# az account set --subscription 85933884-f6aa-4035-a09c-03e9776d31cd
# az aks get-credentials --admin --name controlplane --resource-group platform-engineering-sg
# kubectl apply  --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/cloud/deploy.yaml


helm repo add \
crossplane-stable https://charts.crossplane.io/stable
helm repo update

# dry run
helm install crossplane \
crossplane-stable/crossplane \
--dry-run --debug \
--namespace crossplane-system \
--create-namespace

#install
helm install crossplane \
crossplane-stable/crossplane \
--namespace crossplane-system \
--create-namespace

# check api API epdoints
kubectl get pods -n crossplane-system

kubectl api-resources  | grep crossplane

# 1) install provider
kubectl apply -f platform/control-plane/aws/aws-provider.yml
# 2) Verify the provider installed 
kubectl get providers
# 3) View installed CRDs from the Provider
 kubectl get crds
# 4) generate a Kubernetes Secret from AWS key-pair and then configure the Provider to use it.


kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./lol.txt

# 5)View secret

kubectl describe secret aws-secret -n crossplane-system

# 6) Apply ProviderConfig customizes the settings of the AWS Provider
kubectl apply -f aws-provider-config.yml




kubectl get composite
kubectl get bucket
kubectl get table