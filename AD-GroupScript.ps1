# Create a script to pull samaccountname and group name and export it as a csv file
# This will be used for the purpose of identifying users who are part of specific groups.

import-module activedirectory
$groups = Get-ADGroup -Filter * | select Name, SamAccountName 
$users = @()
foreach ($group in $groups) {
    $members = get-adgroupmember -identity $group.samaccountname -recursive:$true
    foreach($user in $members){
        if($user -is [Microsoft.ActiveDirectory.Management.ADUser]){
            $obj = New-Object PSobject
            Add-Member -InputObject $obj -MemberType NoteProperty -Name "SamAccountName" -Value $user.sAMAcc
            Add-Member -InputObject $obj -MemberType NoteProperty -Name "GroupName" -Value $group.name
            $users += $obj
        }
    }
}

#Ideas 
# I should add a method that will create a new name based on the input the user decides 
# I should also add a way that will grab the pwd and put the csv file in the current directory
$users | Export-Csv C:\temp\test.csv