NAME=$1
STORAGEGB=$2
VERSION=$3

FILE_PATH=platform/gitops/${NAME}-aws-postgres.yml

cp platform/api/claim-postgres-aws-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.parameters.version = \"${VERSION}\"" $FILE_PATH
yq --inplace ".spec.parameters.storageGB = \"${STORAGEGB}\"" $FILE_PATH
