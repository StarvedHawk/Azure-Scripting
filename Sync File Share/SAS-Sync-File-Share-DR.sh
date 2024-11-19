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

# Function to generate SAS token
generate_sas_token() {
    local storage_account_name=$1
    local resource_group_name=$2
    local file_share_name=$3

    # Get the storage account key
    storage_account_key=$(az storage account keys list \
        --resource-group "$resource_group_name" \
        --account-name "$storage_account_name" \
        --query "[0].value" -o tsv)

    # Generate SAS token
    end_time=$(date -u -d "+${SAS_VALIDITY_DURATION} seconds" '+%Y-%m-%dT%H:%MZ')
    sas_token=$(az storage share generate-sas \
        --account-name "$storage_account_name" \
        --account-key "$storage_account_key" \
        --name "$file_share_name" \
        --permissions "rwdlc" \
        --expiry "$end_time" \
        -o tsv)

    echo "$sas_token"
}

# Generate SAS tokens for source and destination
SOURCE_SAS_TOKEN=$(generate_sas_token "$SOURCE_STORAGE_ACCOUNT_NAME" "$SRC_RESOURCE_GROUP_NAME" "$SOURCE_FILE_SHARE_NAME")
DESTINATION_SAS_TOKEN=$(generate_sas_token "$DESTINATION_STORAGE_ACCOUNT_NAME" "$DEST_RESOURCE_GROUP_NAME" "$DESTINATION_FILE_SHARE_NAME")

# Construct Source and Destination URLs
SOURCE_URL="https://${SOURCE_STORAGE_ACCOUNT_NAME}.file.core.windows.net/${SOURCE_FILE_SHARE_NAME}?${SOURCE_SAS_TOKEN}"
DESTINATION_URL="https://${DESTINATION_STORAGE_ACCOUNT_NAME}.file.core.windows.net/${DESTINATION_FILE_SHARE_NAME}?${DESTINATION_SAS_TOKEN}"

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
