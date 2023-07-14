kubectl create secret \
generic aws-secret \
-n crossplane-system \
--from-file=creds=./aws-credentials.txt

kubectl get xrd
kubectl describe secret aws-secret -n crossplane-system
kubectl get composite
kubectl get bucket
kubectl get table