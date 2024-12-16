# InternalScan
very basic Internal Network Recon tool 
# Usage
./1scan.sh # to scan the first 5 IPs from a specified range (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
./2ranges.sh # to scan all the active IPs from the /24 ranges where have been found at least one IP from the 1scan script.
./3ports.sh # to scan some basic ports on the active IPs found by the 2ranges script.

# Modifications
It can be modified the threads used on the 1scan script and the ports to scan on 3ports script. 
