#!/bin/bash
# Script usage example:
# $ ./deploy-template.sh <azure_username> <azure_user_password>
#

if [[ !("$#" -eq 2) ]]; 
    then echo "Parameters are missing!" >&2
    exit 1
fi

#Prepare parameters  
azure_username=$1
azure_user_password=$2

resource_group_location="westeurope"
deploy_index="01"
resource_group_prefix="Open-RG"

#Prepare environment variables  
resource_group_name="${resource_group_prefix}${deploy_index}"
deployment_name="${resource_group_prefix}-Dep${deploy_index}"
template_file="../DevTestRG/open-wb-infra/openWb.json"
template_parameter_file="../DevTestRG/open-wb-infra/openWb.parameters.json"

# Azure login with provided username and password
az login --username $azure_username --password $azure_user_password

echo "Creating resource group: $resource_group_name"
az group create \
        --name $resource_group_name \
        --location $resource_group_location

echo "Creating resource group: $resource_group_name"
az group deployment create \
        --name $deployment_name \
        --resource-group $resource_group_name \
        --template-file $template_file \
        --parameters "@${template_parameter_file}" \
        --verbose

echo "Done!"
