#!python
import boto3
import botocore

# Checks if the file exists
def check_file(bucket, key):
    s3 = boto3.resource('s3')
    file_exists = False
    try:
        s3.Object(bucket, key).load()
    except botocore.exceptions.ClientError as e:
        if e.response['Error']['Code'] == "404":
            file_exists = False
        else:
            raise
    else:
        file_exists = True
    return file_exists

# Main function. Entrypoint for Lambda
def handler(event, context):

    # Get Bucket Name
    bucket_name = event['bucket']

    # Get File Path
    file_path = event['file_path']

    # Check if exists
    if check_file(bucket_name, file_path):
        print "File {} exists.".format(file_path)
        return True
    else:
        print "File {} does not exist.".format(file_path)
        return False

# Manual invocation of the script (only used for testing)
if __name__ == "__main__":
    # Test data
    test = {}
    test["bucket"] = "my_bucket"
    test["file_path"] = "path_to_file"
    # Test function
    handler(test, None)
