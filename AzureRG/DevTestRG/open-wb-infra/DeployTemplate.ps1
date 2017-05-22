<#############################################################
 #                                                           #
 # DeployTemplate.ps1										 #
 #                                                           #
 #############################################################>

<#
 .Synopsis
	The script creates a new resource group in Azure subscription and deploys resources based on 'openWb.json' template file and 'openWb.parameters.json' parameters file.

 .Requirements
	Azure PowerShell modules must be installed in order to run the script (https://www.microsoft.com/web/handlers/webpi.ashx/getinstaller/WindowsAzurePowershellGet.3f.3f.3fnew.appids).
 .Parameter ResourceGroupLocation
	Sets Azure region for the deployment. Default region is 'westeurope'.
 .Parameter DeployIndex
	Sets a number for the deployment iteration.
 .Parameter ResourceGroupPrefix
	Used to form resource group name and deployment name.  
 .Parameter AzureUserName
	Azure Active Directory tenant user name. This account is used to deploy all resources and should have necessary permissions. 
 .Parameter AzureUserPassword
	Azure Active Directory tenant password. 

.Example
     If no parameters are provided, default values are used.

     .\DeployTemplate.ps1 

.Example
     This example creates 'Open-RG02' resource group in West Europe region and starts deployment with the name 'Open-RG-Dep02'.

     .\DeployTemplate.ps1 -ResourceGroupLocation 'westeurope' -DeployIndex '02' -ResourceGroupPrefix 'Open-RG' -AzureUserName 'admin@mytenant.onmicrosoft.com' -AzureUserPassword 'P@ssw0rd!@#$%' 
#>


Param(
	[string] $ResourceGroupLocation = "westeurope",
	[string] $DeployIndex = "01",
	[string] $ResourceGroupPrefix = "Open-RG",
	[string] $AzureUserName = "admin@mytenant.onmicrosoft.com",
	[string] $AzureUserPassword = "P@ssw0rd!@#$%"
)

# Prepare credentials and login to Azure subscription. 
$AadPass = ConvertTo-SecureString $AzureUserPassword -AsPlainText -Force
$AadCred = New-Object System.Management.Automation.PSCredential ($AzureUserName, $Aadpass)
Login-AzureRmAccount -Credential $AadCred

# Prepare environment variables.  
$ResourceGroupName = $ResourceGroupPrefix + $DeployIndex
$DeploymentName = $ResourceGroupPrefix + "-Dep" + $DeployIndex
$TemplateUri = "https://raw.githubusercontent.com/evangelism/DevTest/master/AzureRG/DevTestRG/open-wb-infra/openWb.json"
$TemplateParameterUri = "https://raw.githubusercontent.com/evangelism/DevTest/master/AzureRG/DevTestRG/open-wb-infra/openWb.parameters.json"

# Create a new resource group in given region.  
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force

# Start a new deployment in created resource group. 
New-AzureRmResourceGroupDeployment -Name $DeploymentName `
                                       -ResourceGroupName $ResourceGroupName `
                                       -TemplateUri $TemplateUri `
                                       -TemplateParameterUri $TemplateParameterUri `
                                       -Verbose