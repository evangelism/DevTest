#!/bin/bash

# if [[ !("$#" -eq 2) ]]; 
#     then echo "Parameters are missing!" >&2
#     exit 1
# fi

#Prepare parameters  
resource_group_location="westeurope"
deploy_index="01"
resource_group_prefix="Open-RG"
azure_username=$1
azure_user_password=$2

#Prepare environment variables  
resource_group_name="${resource_group_prefix}${deploy_index}"
deployment_name="${resource_group_prefix}-Dep${deploy_index}"
#template_uri="https://raw.githubusercontent.com/evangelism/DevTest/master/AzureRG/DevTestRG/open-wb-infra/openWb.json"
#template_parameter_uri="https://raw.githubusercontent.com/evangelism/DevTest/master/AzureRG/DevTestRG/open-wb-infra/openWb.parameters.json"
template_file="../DevTestRG/open-wb-infra/openWb.json"
template_parameter_file="../DevTestRG/open-wb-infra/openWb.parameters.json"

#az login --username $azure_username --password $azure_user_password

echo "Creating resource group: $resource_group_name"
az group create \
        --name $resource_group_name \
        --location $resource_group_location

echo "Creating resource group: $resource_group_name"
echo "Please wait..."
az group deployment create \
        --name $deployment_name \
        --resource-group $resource_group_name \
        --template-file $template_file \
        --parameters "@${template_parameter_file}" \
        --verbose

echo "Done!"
