# EdgeTransport_MessageTrackingLog

Pre-requisites

 - Enable ps remote in each Edge Transport Server

    Enable-PSRemote -Force

 - Add all Edge Transport Servers as trusted hosts in the system you are going to run this script. If you want to be able to run the script in any Edge Tranport server then run the following command in each Edge Transport Server.

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'edge01.contoso.corp','edge02.contoso.corp','edge03.contoso.corp'

 - It is mandatory to have the Exchange admin user with the same username and password on all Edge Transport servers    


How to run

 - Store the admin user credentials in a variable. Just the user name (without the server name notation). The script will automatically take care of adding SERVER\user notation:

    $cred = Get-Credential


Now you can go ahead and run it:

    To get all message tracking logs from specific Edge Transport Servers:

        .\Get-EdgeMessageTrackingLog.ps1 -EdgeTransportServers edge01.contoso.corp, edge02.contoso.corp, edge03.contoso.corp -Credential $cred


    To get all message tracking logs from all Edge Transport Servers by collecting the Edge Servers using Exchange Snapin in a domain joined Exchange Server:
    
        .\Get-EdgeMessageTrackingLog.ps1 -UseEMS $true -Credential $cred


    To get all message tracking logs from specific Edge Transport Servers and considering specific date/time, let's say only message tracking from the last 3 hours:

    .\Get-EdgeMessageTrackingLog.ps1 -EdgeTransportServers edge01.contoso.corp,edge02.contoso.corp -Credential $cred -Start (Get-date).AddHours(-3) -End (Get-Date)


    Only message tracking from yesterday:

        .\Get-EdgeMessageTrackingLog.ps1 -EdgeTransportServers edge01.contoso.corp,edge02.contoso.corp -Credential $cred -Start (Get-date).AddDays(-2) -End (Get-Date).AddDays(-1)