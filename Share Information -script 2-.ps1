<#
    Modified by Stephen Cimbolic
    last updated 6/8/2021
    Changes:
        Added notes.

    Modified by Stephen Cimbolic
    last updated 5/5/2021
    Changes:
        Added below 2 lintes to anywhere $access was used to remove edge cases of the access code appearing instead of FullControl.
        
        

    Remodified by Stephen Cimbolic
    last updated 1/26/2021
    Changes:
        # commented out # the Completion Email sent at the end of script as it didn't work due to communication restrictions on ERCYBJUMPP4.

    Remodified by Stephen Cimbolic
    last updated 2/26/2020
    Changes:
        Updated source location to Userhome\Desktop\Shares.txt from locked path/folder
        Updated destination path to Userhome\Desktop\Results.csv
        Removing spaces before and after /'s


    Notes/HowTo

    ***This script is designed to use Input/Output FOLDERS not files. While this CAN be used for single share, it is designed for bulk gathering of data.
    
    1. Create a Folder somewhere called Input. It can be inside another folder, on a different server, or whatever. 
    2. Create a Folder called Output in the same place. 
    3. Update the $InputFolderList = Get-ChildItem \\server\path or path to file IE C:\users\user\desktop\input (the end of it should be the INPUT FOLDER)
    4. Create a .txt file in the Input. Could be named anything, and can be as many as needed. A seperate output is created for each input.
    5. Run the script. When it is completed, you can find the output file in the output folder with the input name (replaced any instance of input with output)

#>

$InputFolderList = Get-ChildItem "C:\Users\mvelez\TEST STRUCTURE"
#$InputFolderList = Get-ChildItem "\\erfs1\Access ReCertifications\AutoACL\Input"
$erroractionpreference = "SilentlyContinue"
$count = 0
function Get-ADGroupMembersFunction { # loop to expand AD groups
    ## Null all the variables ##

    ## stop nulling variables ##
    $space = ""
    $outputfile = $args[0]
    $person = $args[1]
    if (($args[2] -ge 1) -and ($args[2] -notlike $null)) {
        $count = $args[2]
    }
    else {
        $count = 0
    }
    $spacer = "-> "; $space = ""
    if ($count -ne 0) {
        for ($i = 0; $i -lt $count; $i++) {
            $space += $spacer
        }
    }
    if ($args[3] -like $null) {
        Write-host "Arg3 Accesstype Null! Pausing Script."
        write-host "Arg0= "+$args[0]
        write-host "Arg1= "+$args[1]
        write-host "Arg2= "+$args[2]
        pause
    }
    else {
        $access = $args[3]
    }
    ## Could potentially add something here, to check if ($args[2] -ge 20), which would be spacer count.
    if (($person -ne $null) -and ($person -like "*everest*")) {
        $person = $person.substring($person.indexof("\") + 1)
        if (get-ADUser -Filter { SAMAccountName -eq $person }) {
            #is user;export data.
            $adquerry = get-aduser $person -Properties * | select SamAccountName, DisplayName, Department
            $content = ($adquerry.SamAccountName + ";" + $adquerry.DisplayName + ";" + $adquerry.Department)
            $content = $space + $content + ";$access"
            $isWritten = $false
            do {
                try {
                    add-content $outputfile $content -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
        }
        else {
            #is group... run nesting.
            
            
            $tempvar = $space + $person + ";$access"
            $isWritten = $false
            do {
                try {
                    add-content $outputfile $tempvar -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            if ($person -like "*$*") {
                $content = "$person;Server/Service Account!"
                
                
                $content = $space + $content + ";$access"
                $isWritten = $false
                do {
                    try {
                        add-content $outputfile $content -ErrorAction Stop
                        $isWritten = $true
                    }
                    Catch
                    {}
                } until ($isWritten)
            }
            else {
                $nestedgroup = get-adgroupmember $person | select -ExpandProperty SAMAccountName
                $count++
                if ($nestedgroup.count -gt 1) {
                    foreach ($nesteduser in $nestedgroup) {
                        
                        
                        Get-ADGroupMembersFunction $outputfile $nesteduser $count $access
                    }
                }
                else {
                    
                    
                    Get-ADGroupMembersFunction $outputfile $nestedgroup $count $access
                }
            }

        }
    }
    elseif ($person -like "*\*") {
        $server = $person.substring(0, $person.indexof("\"))
        $group = $person.substring($person.indexof("\") + 1)
        #local group...
        $isWritten = $false
        do {
            try {
                if (!Test-connection $strComputer -count 1) {
                    add-content $output $strComputer -ErrorAction Stop
                    $isWritten = $true
                }
                else {
                    $isWritten = $true
                }
            }
            Catch {
                $isWritten = $true
            }
        } until ($isWritten)
        $MembersA = ([adsi]"WinNT://$server/Administrators,group").psbase.Invoke('Members') | % { $_.gettype().invokemember('Name', 'getproperty', $null, $_, $null) } 
        $MembersP = ([adsi]"WinNT://$server/Power Users,group").psbase.Invoke('Members') | % { $_.gettype().invokemember('Name', 'getproperty', $null, $_, $null) }   
        $MembersR = ([adsi]"WinNT://$server/Remote Desktop Users,group").psbase.Invoke('Members') | % { $_.gettype().invokemember('Name', 'getproperty', $null, $_, $null) } 
        
        if ($group -like "*admin*") {
            $isWritten = $false
            do {
                try {
                    add-content $output "Administrators Group" -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            foreach ($member in $MembersA) {
                if ($member -like "egs") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> egs;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)
                }
                elseif ($member -like "Rack") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> Rack;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)
                }
                else {
                    
                    
                    # run function from other script...
                    Get-ADGroupMembersFunction $output $member 1 $access
                }
            }
        }
        elseif ($group -like "*Power*") {
            $isWritten = $false
            do {
                try {
                    add-content $output "Power Users Group" -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            foreach ($member in $MembersP) {
                if ($member -like "egs") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> egs;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)        
                }
                elseif ($member -like "Rack") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> Rack;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)   
                }
                else {
                    
                    
                    # run function from other script...
                    Get-ADGroupMembersFunction $output $member 1 $access
                }
            }
        }
        elseif ($group -like "*Remote*") {
            $isWritten = $false
            do {
                try {
                    add-content $output "Remote Desktop Group" -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)

            foreach ($member in $MembersR) {
                if ($member -like "egs") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> egs;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)
                }
                elseif ($member -like "Rack") {
                    $isWritten = $false
                    do {
                        try {
                            
                            
                            add-content $output "-> Rack;$access" -ErrorAction Stop
                            $isWritten = $true
                        }
                        Catch
                        {}
                    } until ($isWritten)
                }
                else {
                    
                    
                    # run function from other script...
                    Get-ADGroupMembersFunction $output $member 1 $access
                }
            }
        }
        else {
            $isWritten = $false
            do {
                try {
                    
                    
                    add-content $output "$group;$access" -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            
        }
    }
    else {
        if (get-ADUser -Filter { SAMAccountName -eq $person }) {
            #is user;export data.
            $adquerry = get-aduser $person -Properties * | select SamAccountName, DisplayName, Department
            $content = ($adquerry.SamAccountName + ";" + $adquerry.DisplayName + ";" + $adquerry.Department)
            
            
            $content = $space + $content + ";$access"
            $isWritten = $false
            do {
                try {
                    add-content $outputfile $content -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
        }
        else {
            #is group... run nesting.
            
            
            $tempvar = $space + $person + ";$access"
            $isWritten = $false
            do {
                try {
                    add-content $outputfile $tempvar -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            if ($person -like "*$*") {
                $content = "$person;Server/Service Account!"
                
                
                $content = $space + $content + ";$access"
                $isWritten = $false
                do {
                    try {
                        add-content $outputfile $tempvar -ErrorAction Stop
                        $isWritten = $true
                    }
                    Catch
                    {}
                } until ($isWritten)
            }
            else {
                $nestedgroup = get-adgroupmember $person | select -ExpandProperty SAMAccountName
                $count++
                if ($nestedgroup.count -gt 1) {
                    foreach ($nesteduser in $nestedgroup) {
                        Get-ADGroupMembersFunction $outputfile $nesteduser $count $access
                    }
                }
                else {
                    Get-ADGroupMembersFunction $outputfile $nestedgroup $count $access
                }
            }

        }
    }
}

foreach ($Folders in $InputFolderList) { # Gets *all* files in the directory
    $output = $Folders.FullName -replace "input", "output" # sets the output file name 
    $Folders = gc $Folders.FullName # gets the current file's content
    $count = 0 # loop counter for status purposes.
    $total = $Folders.count #loop counter for status purposes.
    foreach ($Folder in $Folders) { # gets each line in the current file to process
        ## Null the variables!##
        # exclude: $Folder, $Folders,$output, $total $count
        $ACL = $null 
        $ownertemp = $null
        $item = $Null
        $nametemp = $Null
        $servername = $Null
        $placeholder = $Null
        $perm = $Null
        $access = $null
        ## Stop Nulling the variables!##
        $count++ #increment count by 1 for status purposes
        if ($Folder -like "*@*") { # loop for exempt lines that should be written to file explicitely. 
            $isWritten = $false
            do {
                try {
                    add-content $output $Folder -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
        }
        else {
            $isWritten = $false # loop to ensure data is written and no data fails to write. 
            do {
                try {
                    add-content $output " " -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            $Folder = $Folder.trim()
            if (($Folder -like "* /*") -or ($Folder -like "*/ *")) {
                $Folder -replace '\s+(?="\")'
                $Folder = $Folder.Replace("\ ", "\")
            }
            $isWritten = $false
            do {
                try {
                    add-content $output $Folder -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            ################################################
            #    This is the start of the actual script.   #
            ################################################
            $ACL = (Get-Acl -Path "$Folder") | Select path, Owner, AccessToString # gets the access control logs of the share
            $ownertemp = $acl.Owner #gets the owner from the above line
            $isWritten = $false
            do {
                try {
                    add-content $output "Owner: $ownertemp" -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)

            foreach ($item in ((Get-Acl -Path "$Folder") | Select-Object -ExcludeProperty AccessToString).access) { # loops over each individual Access Control
                if ($item.IdentityReference -like "*BUILTIN*") {
                    
                    $nametemp = $folder.Substring(2)
                    $servername = $nametemp.Substring(0, $nametemp.IndexOf("\"))
                    $placeholder = $item.IdentityReference.ToString()
                    $placeholder = $placeholder.substring($placeholder.IndexOf("\"))
                    $perm = "$servername" + $placeholder   
                    $access = $item.FileSystemRights.ToString()                
                
                }
                elseif ($item.IdentityReference.Value -like "S-*") { # if SID (deleted user) attempt to retrieve what it is, if it still exists.
                
                    $servername = $nametemp.Substring(0, $nametemp.IndexOf("\"))
                    try {
                        $perm = (Get-WmiObject win32_useraccount -ComputerName $servername -Filter "SID = 'S-1-5-21-3462946615-1409782972-46600218-1009'").Caption
                    }
                    catch {
                        $perm = $item.IdentityReference.ToString()
                    }
                    $access = $item.FileSystemRights.ToString()             
                }
                else {
                    $perm = $item.IdentityReference.ToString()
                    $access = $item.FileSystemRights.ToString()
                }
                if ($access -eq "268435456") { #access FullControl value = 268435456
                    $access = "FullControl"
                }           
                Get-ADGroupMembersFunction $output $perm 0 $access
            
            }
            $isWritten = $false
            do {
                try {
                    add-content $output " " -ErrorAction Stop
                    $isWritten = $true
                }
                Catch
                {}
            } until ($isWritten)
            #|Export-Csv -Path "$home\desktop\Results.CSV" -NoTypeInformation -Append
        }
        write-host "$count/$total"
    }
}
