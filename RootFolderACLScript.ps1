# This script was created by Matthew Velez 11/13/23

# It is designed to take a path of folders and give back a csv files with all of the members that
# have access to the folders and the type of access they have. 
#Change the Path to the path of the folders you want the ACL
#Change th Path Variable to become and Input
$Path = Read-Host "Please Enter The Directory You Want To Scan"
$GroupedUsers = @{}

$RootFolders = Get-ChildItem -Path $Path -Directory

foreach ($RootFolder in $RootFolders){
    $Acl = Get-Acl -Path $RootFolder.FullName
    $Aces = $Acl.Access
    foreach ($Ace in $Aces) {
        $Identity = $Ace.IdentityReference.Value
        $Rights = $Ace.FileSystemRights
        $Inherited = $Ace.IsInherited
    
        if ($Rights -like '*FullControl*') {
            $Group = 'Administrator'
        } elseif ($Rights -like '*ExecuteFile*' -and $Rights -like '*Synchronize*') {
            $Group = 'Power User'
        } elseif ($Rights -like '*ReadData*' -and $Rights -like '*Synchronize*') {
            $Group = 'Remote Desktop User'
        } else {
            $Group = 'Other'
        }

        if ($GroupedUsers.ContainsKey($Identity)) {
            $GroupedUsers[$Identity] += $Group
        } else {
            $GroupedUsers[$Identity] = @($Group)
        }
    }
}

$CsvData = foreach ($Key in $GroupedUsers.Keys) {
    [PSCustomObject]@{
        Username = $Key
        Groups   = $GroupedUsers[$Key] -join ', '
        Rights  = $Rights -join ', '
        Inherited = $Inherited -join ', '
        FolderName = $RootFolder.FullName -join ', '




    }
}

$CsvData | Export-Csv -Path 'UserGroups.csv' -NoTypeInformation
