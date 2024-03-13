#Extracting Data through 2 csv files to compare names of users using powershell
#This script will extract data from two CSV files and then compare the names of users. It is important that both CSV files have a column named "Name"
#Author: Matthew Velez
#Date: 11/15/23
#In the future the filepath variables can become an input function that can later serve to streamline the process for large scale csv files. 
$filepath = "C:\Users\mvelez\Desktop\Scripts\csv_file_comparison" #Convert to input varible
$filepath2 = "C:\Users\mvelez\Desktop\Scripts\csv_file_comparison2" #Convert to input varible
$outputFilePath = $filepath + "\compare.txt"
$usersInFirstFile = Import-Csv -Path "$($filepath)\first.csv" | Select Name, Age #Age and Name variables are just placeholders 
$usersInSecondFile = Import-Csv -Path "$($filepath2)\second.csv" | Select Name, Age #Age and Name variables are just placeholders 
$commonNames = Compare-Object -ReferenceObject ($usersInFirstFile) -DifferenceObject ($usersInSecondFile) -Property Name
#The placeholders can be changed to suit the needs we are looking for 
#The data needs to be placed into an array and that array will be placed into a PSObject
#The PSObject will then be exported into their very own csv file 
foreach ($user in $usersInFirstFile) {
    foreach ($user2 in $usersInSecondFile){
        if (($user.Name -eq $user2.Name) -and ($user.Age -ne $user2.Age)){
            Add-Content -Value "$($user.Name), $($user.Age)" -Path $outputFilePath
            }
            elseif (($user.Name -eq $user2.Name) -and ($user.Age -eq $user2.Age))
            {
                #Temporary line that wil be changed once a discussion finalizes things
                Write-Host "Names are the same and ages match."
                }
                else{
                    continue
                    }
                }
            }


<#
Creating a PSObject 

$obj = new-object PSObject -property @{
    Variable1 = blank
    Variable2 = blank
    Variable3 = blank 
    ... etc

}

To then add it to an array 
$array_Variable = @()

At the end of the PSObject add
$array_Variable += $obj
#>            