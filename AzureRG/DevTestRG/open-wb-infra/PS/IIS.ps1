#
# IIS.ps1
#
# The configuration to install Web Server role with ASP.NET and management console 
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
    } 
}