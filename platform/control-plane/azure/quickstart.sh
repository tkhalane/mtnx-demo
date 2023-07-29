#1
helm repo add crossplane-stable https://charts.crossplane.io/stable && helm repo update
#2
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace
#3
kubectl get pods -n crossplane-system
#4
kubectl api-resources  | grep crossplane
kubectl get crds


### FOR AZURE ###
kubectl apply -f azure/kConfig.yml 
kubectl apply -f provider-config.yml
kubectl get providers

# create service principal, and store output in azure-credentials.json
az login
az ad sp create-for-rbac \
--sdk-auth \
--role Owner \
--scopes /subscriptions/a6a80a92-beac-4723-8a08-46e2e7da64f9

# create k8s secret

kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json

kubectl describe secret azure-secret -n crossplane-system

kubectl apply -f provider-config.yml

kubectl describe linuxvirtualmachine | grep "At Provider\|Location"


Unable to create application: application spec for testcross is invalid: InvalidSpecError: Unable to get cluster:
 rpc error: code = NotFound desc = cluster "controlplane-dns-rch2tfg7.hcp.swedencentral.azmk8s.io" not found