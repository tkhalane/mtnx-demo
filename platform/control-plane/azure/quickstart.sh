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

# create service principal, and store output in azure-credentials.json
az login
az ad sp create-for-rbac \
--sdk-auth \
--role Owner \
--scopes /subscriptions/85933884-f6aa-4035-a09c-03e9776d31cd

# create k8s secret

kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json

kubectl describe secret azure-secret -n crossplane-system

kubectl describe linuxvirtualmachine | grep "At Provider\|Location"
