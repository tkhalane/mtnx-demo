NAME=$1
VERSION=$2

FILE_PATH=platform/resources/${NAME}-aws-postgres.yml

cp platform/api/claim-postgres-aws-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.writeConnectionSecretToRef.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.parameters.version = \"${VERSION}\"" $FILE_PATH
