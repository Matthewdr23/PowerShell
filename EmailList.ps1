'''
The Purpose of this script is use a list created and go through AD to produce a large list of email accounts to reduce the hassle of 
trying to search up everyone to add to an email. 
NOTE: This scritp was created with Manual Recertifications in mind. If you are not in the field then this script can help in other ways but the 
direct purpose is for manual recertifications. 
'''

# Import the ActiveDirectory module
import-module ActiveDirectory

# Specify the path to your text file containing full names

$filePath = #"Add File Path Here"

# Read full names from the file
$fullNames = Get-Content -Path $filePath

# Create an empty array to store user information
$userInfo = @()

# Create an empty array to store email addresses
$emailAddresses = @()

# Create a separate array for users not found
$notFoundUsers = @()

# Loop through each full name and retrieve email address
foreach ($fullName in $fullNames) {
    $user = Get-ADUser -Filter {CN -eq $fullName -or DisplayName -eq $fullName} -Properties DisplayName
    $emails = Get-ADUser -Filter {CN -eq $fullName -or DisplayName -eq $fullName} -Properties EmailAddress
    $Title = Get-ADUser -Filter {CN -eq $fullName -or DisplayName -eq $fullName} -Properties Title
    if ($user) {
        $userInfo += [PSCustomObject]@{
            DisplayName = $user.DisplayName
            EmailAddress = $emails.EmailAddress
            Title = $Title.Title
        }
        $emailAddresses += $emails.EmailAddress
    } else {
        Write-Host "User '$fullName' not found in Active Directory."
        $notFoundUsers += $fullName
    }
}

# Specify the output file names (change as needed)
$outputCsvFileName = "UserEmails.csv"
$outputTxtFileName = "EmailAddresses.txt"
$outputNotFoundFileName = "Not_Found.txt"

# Export the user information to a CSV file
$userInfo | Export-Csv -Path $outputCsvFileName -NoTypeInformation

# Export email addresses to a text file
$emailAddresses | Out-File -FilePath $outputTxtFileName

# Export not found users to a separate text file
$notFoundUsers | Out-File -FilePath $outputNotFoundFileName

Write-Host "User information exported to $outputCsvFileName."
Write-Host "Email addresses exported to $outputTxtFileName."
Write-Host "Users not found exported to $outputNotFoundFileName."
