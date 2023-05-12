<# 
@author: Alendrik

#>

$netId = Read-Host "Enter Network Id for scan: "

# Initialize ArrayList for Hits
$hits = [System.Collections.ArrayList]@() # Used for Hits within network
$used = [System.Collections.ArrayList]@() # Used for job cleanup

# Sending Connections and Creating 255 Jobs.
# Adding Jobs to "used" jobs arraylist to keep track of Ids for later dumping.
for ($o = 1; $o -lt 255; $o += 1) {
    #Testing Connection
    $res = Test-Connection "${netId}.${o}" -Count 1 -AsJob # Creating Job for each host pinging
    $used.Add($res) | Out-Null
}

# Waiting 100ms for good connections to return
Start-Sleep -Milliseconds 100

# Adding Hits to arraylist by jobs completed sub 100ms
# Usually, a hit will return quickly in localnetwork
# Long running test-connection jobs are usually fails, Default timeout is 4000ms
get-job | where-object {foreach($completedJob in $_.State) {
    if ($completedJob -eq "Completed"){ $hits.Add($_.Id) }
}} | Out-Null

# Displaying Each positive hit
foreach($hit in $hits) {
    $outcome = Receive-job $hit
    if($outcome) {
        $outcome = ($outcome -split "`"")[1]
        Write-Host "online: ${outcome}"
    }
}

# Cleaning up Jobs that are not of interest
foreach($zap in $used) {
    Stop-Job -Job $zap;
    Remove-Job -job $zap
}

