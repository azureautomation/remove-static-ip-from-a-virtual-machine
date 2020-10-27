Remove Static IP from a Virtual machine
=======================================

            

 This runbook removes a static IP Address from an existing virtual machine. 


 The runbook accepts virtual machine name and cloud service name . It will retrieve the virtual machine  based on its name and cloud service and update it after removing static IP address.


 The virtual machine does not have static IP after successfully running this runbook however it retains the     existing IP. It will get a new IP after the VM is restarted after de-allocation.


 




 






        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
