#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if required arguments are provided
if [ $# -ne 6 ]; then
    echo "Usage: $0 <aws-region> <bucket-name> <access-key-id> <secret-access-key> <template_file_name>"
    exit 1
fi

AWS_REGION="$1"
BUCKET_NAME="$2"
ACCESS_KEY_ID="$3"
SECRET_ACCESS_KEY="$4"
TEMPLATE_FILE_NAME="$5"
OUTPUT_FILE_NAME="$6"

export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"

# Create the CloudFormation stack
STACK_NAME=s3-bucket-stack-"$BUCKET_NAME"
aws cloudformation create-stack --stack-name "$STACK_NAME" --template-body file://"$TEMPLATE_FILE_NAME" --region "$AWS_REGION" --capabilities CAPABILITY_IAM --parameters ParameterKey=BucketName,ParameterValue="$BUCKET_NAME" >> $OUTPUT_FILE_NAME
