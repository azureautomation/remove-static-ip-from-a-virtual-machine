<#
.SYNOPSIS 
    Removes Static IP Address from an existing virtual machine. 

.DESCRIPTION
    This runbook removes a static IP Address from an existing virtual machine.
    The runbook accepts virtual machine name and cloud service name . It will retrieve the virtual
    machine based on its name and cloud service and update it after removing static IP address.
    The virtual machine does not have static IP after successfully running this runbook however it retains the 
    existing IP. It will get a new IP after it is again start after de-allocation.


.PARAMETER AzureSubscriptionName
    Name of the Azure subscription to connect to
    
.PARAMETER VMName    
    Name of the virtual machine to whom you want to remove static IP addess from.  

.PARAMETER ServiceName
     Name of the Cloud Service that hosts and contains the Virtual machine
    
.PARAMETER AzureCredentials
    A credential containing an Org Id username / password with access to this Azure subscription.

	If invoking this runbook inline from within another runbook, pass a PSCredential for this parameter.

	If starting this runbook using Start-AzureAutomationRunbook, or via the Azure portal UI, pass as a string the
	name of an Azure Automation PSCredential asset instead. Azure Automation will automatically grab the asset with
	that name and pass it into the runbook.

.EXAMPLE
    Remove-StaticIPAddress -AzureSubscriptionName "Visual Studio Ultimate with MSDN" -VMName "Sample VM Name" -ServiceName "CloudServiceName" -StaticIPAddress "10.0.0.7" -AzureCredentials $cred

.NOTES
    AUTHOR:Ritesh Modi
    LASTEDIT: March 15, 2015 
    Blog: http://automationnext.wordpress.com
    email: callritz@hotmail.com
#>
workflow Remove-StaticIPAddress {
    param
    (
        [parameter(Mandatory=$true)]
        [String]
        $AzureSubscriptionName,
     
        [parameter(Mandatory=$true)]
        [String]
        $VMName,
        
        [parameter(Mandatory=$true)]
        [String]
        $ServiceName,
                 
        [parameter(Mandatory=$true)]
        [String]
        $AzureCredentials
    )

    # Get the credential to use for Authentication to Azure and Azure Subscription Name 
    $Cred = Get-AutomationPSCredential -Name $AzureCredentials 
     
    # Connect to Azure and Select Azure Subscription 
    $AzureAccount = Add-AzureAccount -Credential $Cred 

    # Connect to Azure and Select Azure Subscription 
    $AzureSubscription = Select-AzureSubscription -SubscriptionName $AzureSubscriptionName 

     # Inline script for removal of static IP to Virtual machine
     inlinescript {
          # Retrieve VM based on its name and Cloud Service
        $VM = Get-AzureVM -ServiceName $using:ServiceName -Name $using:VMName
            # Virtual machine is found
            if($VM) {
                    try{
                          # Removing Static IP addess from Virtual Machine  
                          Remove-AzureStaticVNetIP -VM $VM -erroraction stop | out-null
                            
                         # Updating Virtual Machine to reflect the new static IP address
                          Update-AzureVM -VM $VM.VM -Name $using:VMName -ServiceName $using:ServiceName -erroraction stop | out-null
                          
                           $OutputMessage ="Removed static Ip addess from Virtual Machine $using:VMName in Cloud Service $using:ServiceName successfully !!"
                       }
                   catch
                       {
                         $OutputMessage ="Error removing static IP from Virtual Machine $using:VMName in Cloud Service $using:ServiceName successfully !!"
                                      
                       }   
                               
             }  else  { 
                    $OutputMessage = "Virtual Machine $using:VMName in Cloud Service $using:ServiceName could not be retrieved !!" 
                }

            Write-Output "$OutputMessage"
    } 
}




    