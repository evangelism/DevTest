# DevTest
This repo contains files, documents and ARM templates for the technical engagement project.

The main idea of the template is deploying a base VM infrastructure to replicate current customer Dev&Test environment. Using the template with Jenkins can help to fully automate infrastructure deployment and specific apps testing.

The template file *openWb.json* will create nine VMs in a workgroup. Roles, default number and sizes of the VMs are described below. To change the size of VM you need to adjust appropriate parameter in *openWb.parameters.json* file.

| VM Name |	Description | Azure VM Size | # Cores/RAM (GB) |
| :--- | :--- | :--- | :--- |
| open-wb-load | Load server, Windows Server 2008 R2 SP1 Datacenter | Standard_A8_v2 | 8/16 |

open-wb-web01	Web server, Windows Server 2008 R2 SP1 Datacenter	Standard_F16	16/32