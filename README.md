# Invoke-PingSweep
## Description
A small program designed to ping the given internal network for quick host discovery.


## Plans:
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

