NAME=$1
VERSION=$2

FILE_PATH=platform/resources/${NAME}-redis.yaml

cp platform/api/claim-redis-azure-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.version = \"${VERSION}\"" $FILE_PATH
