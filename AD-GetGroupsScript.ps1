import-module activedirectory
# Get AD groups with names containing "VSTS"
$Groups = Get-ADGroup -Filter { Name -like "*VSTS*" } -Properties managedBy, mail
# Create an empty array to store group information
$GroupInfo = @()

# Iterate through each group and retrieve managed by information
$Groups | ForEach-Object {
    $managedBy = $_.managedBy

    # If managed by is not null, get manager details
    if ($managedBy -ne $null) {
        $manager = Get-ADUser -Identity $managedBy -Properties emailAddress
        $managerName = $manager.Name
        $managerEmail = $manager.emailAddress
    } else {
        # If managed by is null, set default values
        $managerName = 'N/A'
        $managerEmail = 'N/A'
    }

    # Create a custom object for each group
    $groupObject = [PSCustomObject]@{
        'Group Name' = $_.Name
        'Managed By Name' = $managerName
        'Managed By Email' = $managerEmail
    }

    # Add the group object to the array
    $GroupInfo += $groupObject
}

# Specify the output Excel file path and filename
$OutputPath = $Path
$FileName = Read-Host "Enter a filename for the Excel file (without extension)"
# Export the group information to an Excel file
$FileName = $FileName + ".csv"
$GroupInfo | Export-Csv -Path $FileName -NoTypeInformation

Write-Host "Group information exported"

