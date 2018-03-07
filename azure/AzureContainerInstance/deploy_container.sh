#!/bin/bash
# Change these four parameters as needed
ACI_PERS_RESOURCE_GROUP=test-container-rg
ACI_PERS_STORAGE_ACCOUNT_NAME=testcontainer$RANDOM
ACI_PERS_LOCATION=westeurope
ACI_PERS_SHARE_NAME=containershare
ACI_CONTAINER_NAME=php7-with-oci8
ACI_CONTAINER_IMAGE=adrianharabula/php7-with-oci8



# Create the storage account with the parameters
az storage account create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --location $ACI_PERS_LOCATION \
    --sku Standard_LRS

# Export the connection string as an environment variable. The following 'az storage share create' command
# references this environment variable when creating the Azure file share.
export AZURE_STORAGE_CONNECTION_STRING=$(az storage account show-connection-string --resource-group $ACI_PERS_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --output tsv)

# Create the file share
az storage share create -n $ACI_PERS_SHARE_NAME

# Get storage credentials
STORAGE_ACCOUNT=$(az storage account list --resource-group $ACI_PERS_RESOURCE_GROUP --query "[?contains(name,'$ACI_PERS_STORAGE_ACCOUNT_NAME')].[name]" --output tsv)
echo $STORAGE_ACCOUNT

STORAGE_KEY=$(az storage account keys list --resource-group $ACI_PERS_RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)
echo $STORAGE_KEY


# Deploy container and mount volume
az container create \
    --resource-group $ACI_PERS_RESOURCE_GROUP \
    --name $ACI_CONTAINER_NAME \
    --image $ACI_CONTAINER_IMAGE \
    --ports 80 \
    --ip-address Public \
    --azure-file-volume-account-name $ACI_PERS_STORAGE_ACCOUNT_NAME \
    --azure-file-volume-account-key $STORAGE_KEY \
    --azure-file-volume-share-name $ACI_PERS_SHARE_NAME \
    --azure-file-volume-mount-path /var/www/html/
