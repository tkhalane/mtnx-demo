#1
helm repo add crossplane-stable https://charts.crossplane.io/stable && helm repo update

#2
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace
kubectl get pods -n crossplane-system
kubectl api-resources  | grep crossplane
 kubectl get crds
 az login
# create service principal, and store output in azure-credentials.json
az ad sp create-for-rbac \
--sdk-auth \
--role Owner \
--scopes /subscriptions/85933884-f6aa-4035-a09c-03e9776d31cd

#
# create k8s secret

kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json

kubectl describe secret azure-secret -n crossplane-system

kubectl describe linuxvirtualmachine | grep "At Provider\|Location"