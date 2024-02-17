import sys
import yaml
import subprocess
import os

output_file_name="aws_create_s3_bucket_via_cloud_formation.out"

def delete_file(file_path):
    try:
        os.remove(file_path)
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except PermissionError:
        print(f"Error: Permission denied to delete file '{file_path}'.")
    except OSError as e:
        print(f"Error: Unable to delete file '{file_path}': {e}")

def read_and_print_file(file_path):
    try:
        with open(file_path, 'r') as file:
            contents = file.read()
            print(contents)
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
    except IOError:
        print(f"Error: Unable to read file '{file_path}'.")

def generate_cloudformation_template(region, bucket_name):
    template = {
        "Parameters": {
          "BucketName": {
            "Type": "String"
          }
        },      
        "Resources": {
            "MyS3Bucket": {
                "Type": "AWS::S3::Bucket",
                "Properties": {
                    "BucketName": bucket_name
                }
            }
        }
    }
    return yaml.dump(template, default_flow_style=False)

def save_template_to_file(template_content, file_name):
    with open(file_name, "w") as f:
        f.write(template_content)

def create_bucket_with_cloudformation(region, bucket_name, access_key_id, secret_access_key):
    # Delete output file
    delete_file(output_file_name)

    # Create template file
    template_content = generate_cloudformation_template(region, bucket_name)
    template_file_name = "s3_bucket_template.yaml"
    save_template_to_file(template_content, template_file_name)

    # Call bash script to create the bucket via cloud formation
    command = f"aws_create_s3_bucket_via_cloud_formation.sh {region} {bucket_name} {access_key_id} {secret_access_key} {template_file_name} {output_file_name}"
    subprocess.run(command, shell=True, check=True, capture_output=True, text=True)

    # Read output file
    read_and_print_file(output_file_name)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python create_s3_bucket.py <region> <bucket_name> <access_key_id> <secret_access_key>")
        sys.exit(1)

    region = sys.argv[1]
    bucket_name = sys.argv[2]
    access_key_id = sys.argv[3]
    secret_access_key = sys.argv[4]

    create_bucket_with_cloudformation(region, bucket_name, access_key_id, secret_access_key)
