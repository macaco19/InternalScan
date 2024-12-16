# InternalScan
very basic Internal Network Recon tool

## Mazorca and loot folders
Once any script is executed it will create a folder named "**Mazorca**" (why not) with a subfolder in it named "**loot**". 

In **Mazorca** will be the __script_progress__ file, which will save the last range where the 1scan script left when it was interrupted.
In **loot** will be 3 type of files:
1. __script_results-{range}__ where defines if a range has at least one IP within the first 5 IP values from the range.
2. __script_IPS_vivas-{range}__ where are stored all the active IPs from the specified range.
3. __script_escaneo_puertos-{range}__ where are stored all the active Ports from the active IPs on a specified range.


# Usage
> To scan the first 5 IPs from a specified range (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16).
- ./1scan.sh 
> To scan all the active IPs from the /24 ranges where have been found at least one IP from the 1scan script.
- ./2ranges.sh 
> To scan some basic ports on the active IPs found by the 2ranges script.
- ./3ports.sh

## Modifications
It can be modified the threads used on the 1scan script and the ports to scan on 3ports script. 

## Basic commands with **loot** files
> Search all hosts that has the 445 port (SMB) opened and save it on a file stored in the tmp directory.
`cat mazorca/loot/script_escaneo_puertos-10| grep ":445$" | awk -F ':' '{print $1}' > /tmp/smb_hosts`
> Show all ports discovered on a range
`cat mazorca/loot/script_escaneo_puertos-10 | awk -F ':' '{print$2}' | sort -nu`
