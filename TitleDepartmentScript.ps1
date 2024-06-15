# Replace 'file.xlsx' with the name of your Excel file
# Replace 'new_file.xlsx' with the name of the new Excel file you want to create
Import-Module ActiveDirectory
Import-Module ImportExcel

$FileName = Read-Host "Enter the File Name"
$ExportFile = Read-Host "What is the name of the File"
$ExportFileName = $ExportFile+".xlsx"
$Users = Import-Excel -Path $FileName | Select-Object -Property Group, UserID
$Output = @()
foreach ($User in $Users) {
    
    $UserGroup = $User.Group
    $User = $User.UserID
    #Write-Host $User.Group
    #Write-Host $User.UserID
    $Department = Get-ADUser $User -Properties * | Select-Object Department
    $Title = Get-ADUser $User -Properties * | Select-Object title
    $FullName = Get-ADUser $User -Properties * | Select-Object DisplayName
    #Write-Host $Department.Department
    $Properties = [ordered]@{'FullName' = $FullName.DisplayName;'Users' = $User;  'Departments' = $Department.Department; 'Title'= $Title.title; 'Group' = $UserGroup} 
    $Output += New-Object -TypeName PSObject -Property $Properties
    }

$Output | Export-Excel -Path $ExportFileName
