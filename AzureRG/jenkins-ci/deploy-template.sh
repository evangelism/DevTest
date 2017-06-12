#!/bin/bash
# Script usage example:
# $ ./deploy-template.sh <azure_username> <azure_user_password> <azure_tenant>
#

if [[ !("$#" -eq 3) ]]; 
    then echo "Parameters are missing!" >&2
    exit 1
fi

# Prepare parameters  
azure_username=$1
azure_password=$2
azure_tenant=$3

resource_group_location="westeurope"
deploy_index="01"
resource_group_prefix="Open-RG"

# Prepare environment variables  
resource_group_name="${resource_group_prefix}${deploy_index}"
deployment_name="${resource_group_prefix}-Dep${deploy_index}"
template_file="../DevTestRG/open-wb-infra/openWb.json"
template_parameter_file="../DevTestRG/open-wb-infra/openWb.parameters.json"

# Azure login with service principal
echo "Azure login for user: $azure_username"
az login --service-principal --username $azure_username \
                             --password $azure_password \
                             --tenant $azure_tenant

echo "Creating resource group: $resource_group_name"  
az group create \
        --name $resource_group_name \
        --location $resource_group_location

echo "Creating deployment: $deployment_name"
echo -n "Please wait..."
az group deployment create \
        --name $deployment_name \
        --resource-group $resource_group_name \
        --template-file $template_file \
        --parameters "@${template_parameter_file}" \
        --no-wait

#When done - should be 'Succeeded'
while : ; do
     state=$(az group deployment show \
	        --name $deployment_name \
                --resource-group $resource_group_name \
                --query "properties.provisioningState")
     if [ "$state" == "\"Running\"" ]; then
        echo -n "."           
        sleep 10
     else
        break
     fi
done

echo -e "\nDeployment status: ${state}"
echo "Done!"
