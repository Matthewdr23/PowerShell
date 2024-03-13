# Init PowerShell GUI
Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$FileBrowserForm = New-Object System.Windows.Forms.Form
$FileBrowserForm.Text = "File Browser"
$FileBrowserForm.ClientSize = '400,200'

# Create a button for file selection
$BrowseButton = New-Object System.Windows.Forms.Button
$BrowseButton.Text = "Browse for .txt File"
$BrowseButton.Location = '50,50'
$BrowseButton.FlatStyle = 'Flat'
$BrowseButton.FlatAppearance.BorderSize = 1
$BrowseButton.FlatAppearance.BorderColor = 'Black'
$BrowseButton.FlatAppearance.MouseDownBackColor = 'LightGray'
$BrowseButton.FlatAppearance.MouseOverBackColor = 'LightBlue'
$BrowseButton.Add_Click({
    $FileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $FileDialog.Filter = "Text Files (*.txt)|*.txt"
    $Result = $FileDialog.ShowDialog()
    if ($Result -eq 'OK') {
        $SelectedFile = $FileDialog.FileName

        # Create a text box for export filename
        $ExportTextBox = New-Object System.Windows.Forms.TextBox
        $ExportTextBox.Location = '50,100'
        $ExportTextBox.Width = 200
        $ExportTextBox.Text = "Enter export filename"
        $FileBrowserForm.Controls.Add($ExportTextBox)

        # Add a button to confirm export
        $ExportButton = New-Object System.Windows.Forms.Button
        $ExportButton.Text = "Export"
        $ExportButton.Location = '260,100'
        $ExportButton.FlatStyle = 'Flat'
        $ExportButton.FlatAppearance.BorderSize = 1
        $ExportButton.FlatAppearance.BorderColor = 'Black'
        $ExportButton.FlatAppearance.MouseDownBackColor = 'LightGray'
        $ExportButton.FlatAppearance.MouseOverBackColor = 'LightBlue'
        $ExportButton.Add_Click({
            $ExportFilename = $ExportTextBox.Text
            if ([string]::IsNullOrWhiteSpace($ExportFilename)) {
                [System.Windows.Forms.MessageBox]::Show("No filename provided. Export canceled.")
            } else {
                # Construct the full export path
                $ExportPath = Join-Path (Get-Location) "$ExportFilename.txt"
                # Do something with the selected file and export path
                [System.Windows.Forms.MessageBox]::Show("Selected file: $SelectedFile`r`nExport path: $ExportPath")
            }
        })
        $FileBrowserForm.Controls.Add($ExportButton)
    }
})

# Add the button to the form
$FileBrowserForm.Controls.Add($BrowseButton)

# Display the form
[void]$FileBrowserForm.ShowDialog()

