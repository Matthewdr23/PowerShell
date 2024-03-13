import-module ActiveDirectory
import-module ImportExcel

$Location = Read-Host "What is the Inputlist Location: "

$Inputlist = gc $Location
$outputFolder = $Path
 
 
foreach($Path in $Inputlist)
{

    # $FileName = $Path -replace '\\\\','' 
    # $FileName = ($FileName -replace '\\','-') + ".xlsx"
    # $FileName = $outputFolder + $FileName
    $FileName = Read-Host "Name the Output file: "
    $FileName = $FileName+".xlsx"
    if($FileName -like "*-.xlsx")
    {
        $FileName = $FileName -replace '-.xlsx','.xlsx'
    }
    $FolderPath = Get-ChildItem -Directory -Path $Path -Recurse -Force
    $RootFolder = Get-Acl -Path $Path
    $Output     = @()

    ForEach ($Folder in $FolderPath) 
    {
        $Acl = Get-Acl -Path $Folder.FullName
        ForEach ($Access in $Acl.Access) 
        {
            if ($Access.IsInherited -eq $false) 
            {
                $username = $Access.IdentityReference
                $Username_Only = $username -replace 'EVERESTRE\\',''
                if(($username -like "*NT AUTHORITY*") -or ($username -like "*BUILTIN*"))
                {
                    $Properties = [ordered]@{
                        'Description' = $Folder.FullName;
                        'Group' = '';
                        'User' = $Username_Only;
                        'EmployeeID' = '';
                        'Permissions' = $Access.FileSystemRights;
                        'Inherited' = $Access.IsInherited;
                        'Manager' = '';
                        'Approve/Revoke' = '';
                    }
                    $Output += New-Object -TypeName PSObject -Property $Properties
                }
                elseif(get-ADUser -Filter {SAMAccountName -eq $Username_Only})
                {
                    $UserID = $null;$Manager = $null;$Properties = $Null;
                    $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
                    $Manager = Get-ADUser -Identity $Username_Only -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {
                        if ($_ -match 'CN=(.+?),') 
                        {
                             $matches[1]
                        }
                    }
                    $Properties = [ordered]@{
                        'Description' = $Folder.FullName;
                        'Group' = '';
                        'User' = $Username_Only;
                        'EmployeeID' = $UserID.EmployeeNumber;
                        'Permissions' = $Access.FileSystemRights;
                        'Inherited' = $Access.IsInherited;
                        'Manager' = $Manager;
                        'Approve/Revoke' = '';
                    }
                    $Output += New-Object -TypeName PSObject -Property $Properties
                }
                else
                { # Group
                    $group = $null;$GroupMembers = $null;$Properties = $Null;
                    $Group = $Username_Only
                    $GroupMembers = get-adgroupmember $Username_Only | select -ExpandProperty SAMAccountName
                    foreach($nesteduser in $GroupMembers)
                    {
                        $username = "EVERESTRE\$nesteduser"
                        $Username_Only = $username -replace 'EVERESTRE\\',''
                        $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
                        $Manager = Get-ADUser -Identity $Username_Only -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {
                            if ($_ -match 'CN=(.+?),') 
                            {
                                 $matches[1]
                            }
                        }
                        $Properties = [ordered]@{
                            'Description' = $Folder.FullName;
                            'Group' = $Group;
                            'User' = $Username_Only;
                            'EmployeeID' = $UserID.EmployeeNumber;
                            'Permissions' = $Access.FileSystemRights;
                            'Inherited' = $Access.IsInherited;
                            'Manager' = $Manager;
                            'Approve/Revoke' = '';
                        }
                        $Output += New-Object -TypeName PSObject -Property $Properties
                    }
                }
            }
        }
    }

    # Export the results to an Excel file
    foreach ($Access in $RootFolder.Access)
    {
        If($Access.IsInherited -eq $False)
        {
            $username = $Access.IdentityReference
            $Username_Only = $username -replace 'EVERESTRE\\',''
            if(($username -like "*NT AUTHORITY*") -or ($username -like "*BUILTIN*"))
                {
                    $Properties = [ordered]@{
                        'Description' = $Folder.FullName;
                        'Group' = '';
                        'User' = $Username_Only;
                        'EmployeeID' = '';
                        'Permissions' = $Access.FileSystemRights;
                        'Inherited' = $Access.IsInherited;
                        'Manager' = '';
                        'Approve/Revoke' = '';
                    }
                    $Output += New-Object -TypeName PSObject -Property $Properties
                }
            elseif(get-ADUser -Filter {SAMAccountName -eq $Username_Only})
            {
                $UserID = $null;$Manager = $null;$Properties = $Null;
                $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
                $Manager = Get-ADUser -Identity $Username_Only -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {
                    if ($_ -match 'CN=(.+?),') 
                    {
                            $matches[1]
                    }
                }
                $Properties = [ordered]@{
                    'Description' = $Folder.FullName;
                    'Group' = '';
                    'User' = $Username_Only;
                    'EmployeeID' = $UserID.EmployeeNumber;
                    'Permissions' = $Access.FileSystemRights;
                    'Inherited' = $Access.IsInherited;
                    'Manager' = $Manager;
                    'Approve/Revoke' = '';
                }
                $Output += New-Object -TypeName PSObject -Property $Properties
            }
            else
            { # Group
                $group = $null;$GroupMembers = $null;$Properties = $Null;
                $Group = $Username_Only
                $GroupMembers = get-adgroupmember $Username_Only | select -ExpandProperty SAMAccountName
                foreach($nesteduser in $GroupMembers)
                {
                    $username = "EVERESTRE\$nesteduser"
                    $Username_Only = $username -replace 'EVERESTRE\\',''
                    $UserID = Get-ADUser -Filter {SamAccountName -eq $Username_Only} -Properties EmployeeNumber | Select-Object EmployeeNumber
                    $Manager =Get-ADUser -Identity $Username_Only -Properties * | Select-Object -ExpandProperty Manager | ForEach-Object {
                        if ($_ -match 'CN=(.+?),') 
                        {
                                $matches[1]
                        }
                    }
                    $Properties = [ordered]@{
                        'Description' = $Folder.FullName;
                        'Group' = $Group;
                        'User' = $Username_Only;
                        'EmployeeID' = $UserID.EmployeeNumber;
                        'Permissions' = $Access.FileSystemRights;
                        'Inherited' = $Access.IsInherited;
                        'Manager' = $Manager;
                        'Approve/Revoke' = '';
                    }
                    $Output += New-Object -TypeName PSObject -Property $Properties
                }
            }
        }
    }
    $Output | Export-Excel -Path $FileName -AutoSize
}




