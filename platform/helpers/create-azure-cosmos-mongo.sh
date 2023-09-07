NAME=$1

FILE_PATH=platform/resources/${NAME}-cosmos-mongo.yaml

cp platform/api/claim-cosmos-mongo-azure-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.throughput = $2" $FILE_PATH
