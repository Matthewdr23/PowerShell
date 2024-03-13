import-module ActiveDirectory
import-module ImportExcel

$Path = Read-Host "Please state the directory for which you wish to get the ACL"
While (!(Test-Path $Path)){
    Write-Host "Invalid FilePath. Please enter a valid one" -ForegroundColor Red
    $Path = Read-Host "Please state the directory for which you wish to get the ACL"
}

$FolderPath = Get-ChildItem -Directory -Path $Path -Recurse -Force
$RootFolder = Get-Acl -Path $Path
$reportfile = Read-Host "Name the report file"
$FileName   = $reportFile + ".xlsx"
$Output     = @()

ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName

    ForEach ($Access in $Acl.Access) {
        if ($Access.IsInherited -eq $false) {
            $username = $Access.IdentityReference
            $Username_Only = $username -replace 'EVERESTRE\\',''
            $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
            $Manager =Get-ADUser -Identity mvelez -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {if ($_ -match 'CN=(.+?),') {$matches[1]}}

            $Properties = [ordered]@{
                'Description' = $Folder.FullName;
                #'Group' = $Group;
                'User' = $Username_Only;
                'EmployeeID' = $UserID.EmployeeNumber;
                'Permissions' = $Access.FileSystemRights;
                'Inherited' = $Access.IsInherited;
                'Manager' = $Manager;
            }
                
            $Output += New-Object -TypeName PSObject -Property $Properties
            }
    }
}

# Export the results to an Excel file
foreach ($Access in $RootFolder.Access){
    If($Access.IsInherited -eq $False){
        $username = $Access.IdentityReference
        $Username_Only = $username -replace 'EVERESTRE\\',''
        $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
        $Manager =Get-ADUser -Identity mvelez -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {if ($_ -match 'CN=(.+?),') {$matches[1]}}
        #Write-Host $Username_Only
        $Properties = [ordered]@{
            'Description' = $Folder.FullName;
            #'Group' = $Group;
            'User' = $Username_Only;
            'EmployeeID' = $UserID.EmployeeNumber;
            'Permissions' = $Access.FileSystemRights;
            'Inherited' = $Access.IsInherited;
            'Manager' = $Manager
        }
        $Output += New-Object -TypeName PSObject -Property $Properties
    }
}
 
$Output | Export-Excel -Path $FileName -AutoSize 