<# invoke-pingsweep:
A small program designed to ping the given internal network for quick host discovery.

Plans:
    - change from static 192.168.1.0/24 network
        - User input will equal netid
        - Additional input for CIDR/subnet mask
    - Add "sleep time" param 
            -s, --sleep (ms)
    - Add mask param to establish range
            -m, --mask (255.255.255.255)
    - Add CIDR param to setablish range
            -c, --cidr 24=/24, 16=/16
    - Add jobcount controls:
        - Job count limit
            -l, --limit 255, n
        - Job count 
            -n, 255, n
#>

# Initialize ArrayList for Hits
$hits = [System.Collections.ArrayList]@() # Used for Hits within network
$used = [System.Collections.ArrayList]@() # Used for job cleanup

# Sending Connections and Creating 255 Jobs.
# Adding Jobs to "used" jobs arraylist to keep track of Ids for later dumping.
for ($o = 1; $o -lt 255; $o += 1) {
    #Testing Connection
    $res = Test-Connection "192.168.1.${o}" -Count 1 -AsJob # Creating Job for each host pinging
    $used.Add($res) | Out-Null
}

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

