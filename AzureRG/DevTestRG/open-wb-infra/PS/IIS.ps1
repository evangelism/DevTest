#
# IIS.ps1
#
# The configuration to install Web Server role with ASP.NET, FTP features and management console 
#
configuration IISInstall 
{ 
    node "localhost"
    { 
        WindowsFeature IISServer 
        { 
            Ensure = "Present" 
            Name = "Web-Server"                       
        } 

        WindowsFeature ASPNET 
        { 
            Ensure = "Present" 
            Name = "Web-Asp-Net"                       
        }
        
        WindowsFeature FTP
        {
            Ensure = "Present"
            Name = "Web-Ftp-Server"
            IncludeAllSubFeature = $true
        }
        
        Script FTPConfig
        {
            SetScript = 
            { 
				## Import IIS module 
				Import-Module WebAdministration


				## Get VM Public IP

				# Get VM public fqdn   
				$vmPublicName = $env:COMPUTERNAME + ".westeurope.cloudapp.azure.com"

				# Get VM public IP using function 
				$vmPublicIP = ([System.Net.Dns]::GetHostAddresses($vmPublicName)).IPAddressToString
				$extIP = $vmPublicIP.Substring(0,$vmPublicIP.Length)


				## Create FTP

                # Delete iisstart.htm default file
                if (Test-Path "C:\inetpub\wwwroot\iisstart.htm")
                {
                    Remove-Item "C:\inetpub\wwwroot\iisstart.htm"  
                }

				# Create Ftp site with default home directory c:\inetpub\wwwroot
				New-WebFtpSite -Name appUpload -Port 21 -PhysicalPath C:\inetpub\wwwroot


				## Configure appropriate settings
  
				# Enable basic authentication 
				Set-ItemProperty "IIS:\Sites\appUpload" -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true

				# Allow non-SSL connections 
				Set-ItemProperty "IIS:\Sites\appUpload" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0 
				Set-ItemProperty "IIS:\Sites\appUpload" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0
 
				# Allow Read-Write access for Administrators group 
				Add-WebConfiguration system.ftpServer/security/authorization "IIS:\" -Value @{accessType="Allow";roles="Administrators";permissions="Read,Write"}

				# Configure ftp passive mode
				Set-WebConfiguration system.ftpServer/firewallSupport "IIS:\" -Value @{lowDataChannelPort="5000";highDataChannelPort="5014"}
				Set-WebConfiguration system.applicationHost/sites/siteDefaults/ftpServer/firewallSupport "IIS:\" -Value @{externalIp4Address=$extIP}
 
				# Restart Ftp service for all changes to take effect
				net stop ftpsvc
				net start ftpsvc
			}
            TestScript = { (-not (Test-Path "C:\inetpub\ftproot")) }
            GetScript = { @{ Result = $env:COMPUTERNAME } } 
            DependsOn = "[WindowsFeature]FTP"         
        }
    } 
}