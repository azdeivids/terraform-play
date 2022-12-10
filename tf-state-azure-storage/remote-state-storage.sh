#!/bin/bash

RESOURCE_GROUP_NAME=terraform-state-storage-uksouth
STORAGE_ACCOUNT_NAME=tfstate428150812
CONTAINER_NAME=tfstate

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location uksouth

# Create key vault
az keyvault create --name "tfstate428150812-key" --resource-group $RESOURCE_GROUP_NAME --location uksouth

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

az keyvault secret set --vault-name "tfstate428150812-key" --name "terraform-state-uks-storage-key" --value $ACCOUNT_KEY

export ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-state-uks-storage-key --vault-name tfstate428150812-key --query value -o tsv)