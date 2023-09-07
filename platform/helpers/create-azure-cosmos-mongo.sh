NAME=$1
THROUGHPUT=$(echo "$2" | awk '{print $0+0}')

FILE_PATH=platform/resources/${NAME}-cosmos-mongo.yaml

cp platform/api/claim-cosmos-mongo-azure-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.throughput = \"${THROUGHPUT}\"" $FILE_PATH
yq --inplace ".spec.version = $2" $FILE_PATH
