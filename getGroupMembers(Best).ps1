import-module activedirectory
$groups = get-content "C:\Users\YOUR LAN ID\OneDrive - Everest Reinsurance\Desktop\Groups.txt"
# The $out array is going to be used to capture the data for each person in the group to then be displayed in a .txt file 
$out = @()
#This is the formating that will used in the .txt file 
$out += "Group`tUserID`tDisplayName"
#This part of the script is for counting the number of users in the group
$currentGroup = 0
$groupCount = $groups.count
#This is for the Timing portion of the Code to display in the txt file. 
$startTime = get-date

#Recursive method for the people in the groups
foreach($group in $groups)
{
    $currentGroup++
    $members = get-adgroup $group -server everestre.net -properties Members|Select -expandProperty Members
    $currentMember = 0
    $memberCount = $members.count
    foreach($member in $members)
    {
        try
        {
            $memberObject = get-aduser $member -server everestre.net -properties SamAccountName, DisplayName
            $sam = $memberObject|Select -expandProperty SamAccountName
            $displayName = $memberObject|Select -expandProperty DisplayName            
        }
        catch
        {
            $sam = $member
            $displayName = ""
        }
        $out += "$group`t$sam`t$displayName"
        $currentMember++
        $percentage = [math]::Round((($currentMember/$memberCount)*100),2)
        $elapsedTime = (get-date)-$startTime
        $elapsedDays = $elapsedTime.Days
        $elapsedHours = $elapsedTime.Hours
        $elapsedMinutes = $elapsedTime.Minutes
        $elapsedSeconds = $elapsedTime.Seconds
        $elapsedTimeString = ""
        if($elapsedDays -ne 0)
        {
            $elapsedTimeString += "$elapsedDays Days "
        }
        if($elapsedHours -ne 0)
        {
            $elapsedTimeString += "$elapsedHours Hours "
        }
        if($elapsedMinutes -ne 0)
        {
            $elapsedTimeString += "$elapsedMinutes Minutes "
        }
        if($elapsedSeconds -ne 0)
        {
            $elapsedTimeString += "$elapsedSeconds Seconds"
        }
        Write-Progress -Activity "Processing groups $currentGroup of $groupCount..`tRunning Time: $elapsedTimeString" -Status "$percentage% Complete" -PercentComplete $percentage
    }
}
#Takes all the data has been gathered and exports it as a csv file
$out|out-file "C:\Users\YOUR LAN ID\OneDrive - Everest Reinsurance\desktop\GroupMembers.csv"