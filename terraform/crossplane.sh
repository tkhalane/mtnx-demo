helm install crossplane \
crossplane-stable/crossplane \
--dry-run --debug \
--namespace crossplane-system \
--create-namespace

helm install crossplane  crossplane-stable/crossplane  --namespace crossplane-system --create-namespace
kubectl get pods -n crossplane-system
kubectl api-resources  | grep crossplane
