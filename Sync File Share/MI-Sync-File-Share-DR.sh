#!/bin/bash

# Define Variables
SOURCE_STORAGE_ACCOUNT_NAME="bespinpscalculator"
SOURCE_FILE_SHARE_NAME="abc"
DESTINATION_STORAGE_ACCOUNT_NAME="tasktesting123"
DESTINATION_FILE_SHARE_NAME="abc"
SRC_RESOURCE_GROUP_NAME="PS-Calc"
DEST_RESOURCE_GROUP_NAME="PS-Calc"
SAS_VALIDITY_DURATION=300 # 5 minutes

# AzCopy Path (adjust if AzCopy is not in PATH)
AZCOPY_PATH="/path/to/azcopy"

# Construct Source and Destination URLs
SOURCE_URL="https://${SOURCE_STORAGE_ACCOUNT_NAME}.file.core.windows.net/${SOURCE_FILE_SHARE_NAME}"
DESTINATION_URL="https://${DESTINATION_STORAGE_ACCOUNT_NAME}.file.core.windows.net/${DESTINATION_FILE_SHARE_NAME}"

echo "Source URL: $SOURCE_URL"
echo "Destination URL: $DESTINATION_URL"

# Perform File Sync using AzCopy
echo "Starting data replication..."
azcopy sync "$SOURCE_URL" "$DESTINATION_URL" --recursive=true
echo "Data replication completed."

# Cleanup SAS tokens (by unsetting the variables)
unset SOURCE_SAS_TOKEN
unset DESTINATION_SAS_TOKEN

echo "Temporary SAS tokens cleaned up for security."
