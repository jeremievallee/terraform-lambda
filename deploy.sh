#!/bin/bash
set -e

# Get Virtualenv Directory Path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -z "$VIRTUAL_ENV_DIR" ]; then
    VIRTUAL_ENV_DIR="$SCRIPT_DIR/venv"
fi

echo "Using virtualenv located in : $VIRTUAL_ENV_DIR"

# If zip artefact already exists, back it up
if [ -f $SCRIPT_DIR/check_file_lambda.zip ]; then
    mv $SCRIPT_DIR/check_file_lambda.zip $SCRIPT_DIR/check_file_lambda.zip.backup
fi

# Add virtualenv libs in new zip file
cd $VIRTUAL_ENV_DIR/lib/python2.7/site-packages
zip -r9 $SCRIPT_DIR/check_file_lambda.zip *
cd $SCRIPT_DIR

# Add python code in zip file
zip -r9 $SCRIPT_DIR/check_file_lambda.zip check_file_lambda.py

# Run terraform apply
terraform apply
