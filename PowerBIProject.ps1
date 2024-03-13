# Install the ImportExcel module if you haven't already
Install-Module -Name ImportExcel -Scope CurrentUser

# Specify the folder containing your CSV and XLSX files
$Path = Read-Host "what is the folder containing the data that is to be processed"
$ExportFile = Read-Host "Name the file"
$ExportFileName = $ExportFile + ".xlsx"
Write-Output "Processing Data in Folder: $Path"
# Get a list of all .csv and .xlsx files in the specified directory.
$Files = Get-ChildItem "$Path\*.csv", "$Path\*.xls*"
if ($Files) {
    Write-Host "Found Files:"
    foreach ($file in $Files) {
        Write-Host "  $($file.Fullname)"
    }
} else {
    Write-Warning "No matching files found!"
    exit
}

