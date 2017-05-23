# DevTest
This repo contains files, documents and ARM templates for the technical engagement project.

The main idea of the template is deploying a base VM infrastructure to replicate current customer Dev&Test environment. Using the template with Jenkins can help to fully automate infrastructure deployment and specific apps testing.

The template file [openWb.json] (AzureRG/DevTestRG/open-wb-infra/openWb.json) will create nine VMs in a workgroup. Roles, default number and sizes of the VMs are described below. To change the size of VM you need to adjust appropriate parameter in [*openWb.parameters.json*] (AzureRG/DevTestRG/open-wb-infra/openWb.parameters.json) file.

| VM Name |	Description | Azure VM Size | # Cores/RAM (GB) |
| :--- | :--- | :--- | :--- |
| open-wb-load | Load server, Windows Server 2008 R2 SP1 Datacenter | Standard_A8_v2 | 8/16 |
| open-wb-web01 | Web server (IIS and ASP.NET), Windows Server 2008 R2 SP1 Datacenter | Standard_F16 | 16/32 |
| open-wb-db01, open-wb-db02 | Two database servers with SQL Server 2012 SP3 Enterprise on Windows Server 2012 R2 Datacenter. Both VMs are in availability set with two Update and two Fault domains. Use **numberOfSqlVMs** parameter to change number of SQL Server instances during deployment | Standard_D15_v2 | 20/140 |
| open-wb-g00000X | Four app gate servers, Windows Server 2008 R2 SP1 Datacenter. To improve scalability all these servers are placed in a VM Scale Set. Use **gateVmInstanceCount** parameter to change number of instances during deployment | Standard_A2m_v2 | 2/16 |
| open-wb-stub | Emulation integration server, Windows Server 2008 R2 SP1 Datacenter | Standard_A8_v2 |	8/16 |

All VMs except VM Scale Set will be deployed with public IP addresses. That allows to connect to those VMs through RDP outside Azure datacenters. You can reach VM Scale Set instances through RDP from any other VMs.

To make deployment process easier you may use [*DeployTemplate.ps1*] (AzureRG/DevTestRG/open-wb-infra/DeployTemplate.ps1) script. For example this command will create 'Open-RG02' resource group in West Europe Azure region in appropriate tenant subscription and start deployment with the name 'Open-RG-Dep02':
```
.\DeployTemplate.ps1 -ResourceGroupLocation 'westeurope' -DeployIndex '02' -ResourceGroupPrefix 'Open-RG' -AzureUserName '<tenant account name>' -AzureUserPassword '<tenant account password>'
```
See comment section of *DeployTemplate.ps1* file for more details.  