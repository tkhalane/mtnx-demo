NAME=$1
STORAGEGB=$2
VERSION=$3

FILE_PATH=platform/gitops/${NAME}-postgres.yml

cp platform/api/claim-postgres-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.parameters.version = \"${VERSION}\"" $FILE_PATH
yq --inplace ".spec.parameters.storageGB = \"${STORAGEGB}\"" $FILE_PATH
