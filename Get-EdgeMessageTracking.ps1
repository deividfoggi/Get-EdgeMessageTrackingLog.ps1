param(
    [Parameter(Mandatory=$true)]
    [System.Array]$EdgeTransportServers,
    [Parameter(Mandatory=$true)]
    [System.Management.Automation.PSCredential]$Credential,
    [Parameter(Mandatory=$false)]
    [boolean]$UseEMS,
    [string]$ArgumentList
)

#If UseEMS = $true then try to get all Edge Transport servers automatically
if($UseEMS){
    Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Snapin
    $EdgeTransportServers = Get-ExchangeServer | Where-Object{$_.ServerRole -eq "Edge"}
}

#Creates an empty array list to store the results
$TrackingLog = @()

#For each Edge Transport server
foreach($edge in $EdgeTransportServers){

    #Builds the username variable using the notation SERVER\USERNAME
    $currentUser = "$($edge)\$($Credential.UserName)"
    #Creates a PSCredential object using the notation SERVER\USERNAME and the password stored in the $credential variable
    $currentCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $currentUser, $credential.Password

    #If the current edge transport isn't the same name of the server where the command is running, use remote powershell
    if($edge -ne [System.Net.Dns]::GetHostByName(($env:computerName)).HostName) {
        #Invoke the remote powershell command and stores the result
        $currentTrackingLog = Invoke-Command -ComputerName $edge -Credential $currentCredential -ScriptBlock {Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Snapin;Get-MessageTrackingLog}
    } 
    #If the current server is the same of the server where the command is running, do not use remote powershell
    else {
        #Checks if the Exchange Snapin isn't already loaded
        if(!(Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Snapin)) {
            #Loads the Exchange snapin
            Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Snapin            
        }

        #Collect the tracking log
        $currentTrackingLog = Get-MessageTrackingLog

    }
    
    #Adds the result of the current server to the final result
    $TrackingLog += $currentTrackingLog

}

#Prints out the final result
$TrackingLog