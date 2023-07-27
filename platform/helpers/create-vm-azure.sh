NAME=$1
REGION=$2

FILE_PATH=platform/gitops/${NAME}-vm-azure.yaml

cp platform/api/claim-vm-azure-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.region = \"${REGION}\"" $FILE_PATH
