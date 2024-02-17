#!/bin/bash

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if required arguments are provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <aws-region> <bucket-name> <access-key-id> <secret-access-key>"
    exit 1
fi

AWS_REGION="$1"
BUCKET_NAME="$2"
ACCESS_KEY_ID="$3"
SECRET_ACCESS_KEY="$4"

export AWS_ACCESS_KEY_ID="$ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$SECRET_ACCESS_KEY"

# Check if the bucket already exists
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "Bucket '$BUCKET_NAME' already exists."
    exit 1
fi

# Create the S3 bucket
if aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION"; then
    echo "Bucket '$BUCKET_NAME' created successfully."
else
    echo "Failed to create bucket '$BUCKET_NAME'."
    exit 1
fi
