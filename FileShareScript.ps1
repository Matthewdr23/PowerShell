import-module ActiveDirectory
import-module ImportExcel
$Path = Read-Host "Please state the directory that you wish to get the ACL for "
While (!(Test-Path $Path)){
    Write-Host "Invalid FilePath. Please Enter a valid one" -ForegroundColor Red
    $Path = Read-Host "Please state the directory that you wish to get the ACL"
}
$FolderPath = Get-ChildItem -Directory -Path $Path -Recurse -Force
$RootFolder = Get-Acl -Path $Path
$reportfile = Read-Host "Name the report file"
$FileName   = $reportFile+".xlsx"
$Output     = @()
 
ForEach ($Folder in $FolderPath) {
 
    $Acl = Get-Acl -Path $Folder.FullName

   
    ForEach ($Access in $Acl.Access) {
        if ($Access.IsInherited -eq $false) {
            $username = $Access.IdentityReference
            $Username_Only = $username -replace 'EVERESTRE\\',''
            $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
            $UserDep = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties Department | Select-Object Department
            #$UserGroup = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties Group | Select-Object Group            #Write-Host $UserID
            #For Troubleshooting purposes
            #Write-Host $Username_Only
            #$Properties = [ordered]@{'Description'=$Folder.FullName; 'User'=$UserID.EmployeeNumber;'EntitlementDescription'= $UserGroup.Group}
            $Properties = [ordered]@{'Description'=$Folder.FullName;'Department'=$UserDep.Department;'Group/User'=$Username_Only ;'EmployeeID'=$UserID.EmployeeNumber;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Output += New-Object -TypeName PSObject -Property $Properties
            
        }
    }
}
 
foreach ($Access in $RootFolder.Access){
    If($Access.IsInherited -eq $False){
        $username = $Access.IdentityReference
        $Username_Only = $username -replace 'EVERESTRE\\',''
        $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
        $UserDep = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties Department | Select-Object Department
        $EmployeeNumber = $UserID.EmployeeNumber

        #Write-Host $Username_Only
        $Properties = [ordered]@{'Description'=$Path;'Department'=$UserDep.Department;'Group/User'=$Username_Only;'EmployeeID'=$EmployeeNumber;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
        $Output += New-Object -TypeName PSObject -Property $Properties
    }
}
 
$Output | Export-Excel -Path $FileName

