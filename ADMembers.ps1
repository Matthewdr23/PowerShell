# Grab the Display names of users in a Given Membership 

import-module activedirectory
import-module ImportExcel
#input for variable "Group"
$group = read-host -prompt "Please enter the Group name you want to search"
#Connecting to AD and getting all members of the group.
$members = get-adgroupmember $group | where {$_.objectclass -eq 'user'}| select name,samaccountname
#foreach member in members create an array to put into a object to export as a csv file
$data = @()
foreach ($mem in $members) {
    $obj = new-object PSObject -property @{
        Name=$mem.name;
        UserName=$mem.SamAccountName
        GroupName=$group
        }
        $data += $obj
        }
#exporting data to CSV File
#file name will be "MembersOf"+ $ADGroup
$filename = "MembersOf_"+$group+".csv"
$data | Export-Csv -Path $filename -NoTypeInformation

#Import the CSV File and export is as a xsls file 
# Note
<#
For future usage on different devices make sure to change the file path
#>

<# 
This way we have both file types just in case
#>

