NAME=$1
REGION=$2

FILE_PATH=platform/resources/${NAME}-s3-dynamodb.yaml

cp platform/api/claim-s3-dynamodb-aws-template.yml $FILE_PATH
yq --inplace ".metadata.name = \"${NAME}\"" $FILE_PATH
yq --inplace ".spec.region = \"${REGION}\"" $FILE_PATH
