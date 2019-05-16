
#!/bin/bash
# Reset
nc='\033[0m'       # Text Reset

#Regular Colors
blck='\033[0;30m'        # Black
red='\033[0;31m'          # Red
gr='\033[0;32m'        # Green
yw='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purp='\033[0;35m'       # Purple
cy='\033[0;36m'         # Cyan
white='\033[0;37m'        # White

# Bold
bb='\033[1;30m'       # Black
br='\033[1;31m'         # Red
bg='\033[1;32m'       # Green
by='\033[1;33m'      # Yellow
bb='\033[1;34m'        # Blue
bp='\033[1;35m'      # Purple
bc='\033[1;36m'        # Cyan
bw='\033[1;37m'       # White
####################################
ascii(){
rndcolor
cat<<"EOF"
                             .-----------------TTTT_-----_______
                       /''''''''''(______O] ----------____  \______/]_
    __...---'"""\_ --''   Q                               ___________@
|'''                   ._   _______________=---------"""""""
|                ..--''|   l L |_l   |       S.E.N.A
|          ..--''      .  /-___j '   '       Simple. Effective. NMap. Aide.
|    ..--''           /  ,       '   '        
|--''                /           `    \       Product Of Peril Group.
                     L__'         \    -
                                   -    '-.
                                    '.    /
                                      '-./
EOF
ttl=$(grep -r ".nse" /usr/share/nmap/scripts/ | wc -l | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
echo -e "${br}SENA$nc - Fully equipped with a ${rndcolor}$ttl${nc}/round clip."
}

rndcolor(){
    color=("$blue" "$red" "$yw" "$white" "$gr" "$cy")
    rcolor=${color[RANDOM%6]}
    echo -e $rcolor
}
#Mains:
host="$1"
mode="$2"
scadas="/$HOME/scada_nse/atg-info,BACnet-discover-enumerate,codesys-v2-discover,dnp3-info,enip-enumerate,fox-info,iec-identify,mms-identify,modbus-discover,modbus-enum,modicon-info,omrontcp-info,omronudp-info,pcworx-info,proconos-info,s7-enumerate,Siemens-CommunicationsProcessor,Siemens-HMI-miniweb,Siemens-Scalance-module,Siemens-SIMATIC-PLC-S7,Siemens-WINCC"    
ports="47808,20000,34980,44818,2222,55000,55555,55003,1091,1089,102,502,4840,80,443,34962,34964,4000,50001,50016,50018,50020,50021,50025,50028,50110-50111"   

ip=$(dig +short $host | awk '{ print ; exit }')
cidr=$(echo $host | sed 's/[0-9]*$/0/')
#-----------------------------------
if [[ $1 = "" ]]; then
    echo
    ascii
    echo -e $bg"USAGE:"$nc
    echo -e $by"$0 modes$nc\n$bp$0 [host]$nc\n$b$0 [host] [mode]"$nc
    exit 0
fi
rndcolor
if [ -z  $mode ]; then
    sudo nmap -v -sV -sC $host -oG default.tmp 
elif [ $mode == "titles" ]; then
    nmap -sn $cidr/24 --script http-title -oG titles.tmp
elif [ $mode == "auth" ]; then 
    nmap -Pn --script auth $host -oG auth.tmp
elif [ $mode == "safe" ]; then 
    nmap -Pn --script safe $host -oG safe.tmp
elif [ $mode == "intrude" ]; then
    nmap -Pn --script intrusive -oG intrusive.tmp $host
elif [ $mode == "http" ]; then
    ncount=$(grep -r -c /usr/share/nmap/scripts/http-* | wc -l  )
    echo "*WARNING*: This will check $host against $ncount NSEs."
    echo -e $br" Continue? Y/N"
    read yn
    if [ $yn == "Y" ]; then
        nmap --open --script "http-*" -oG http.tmp $host
    elif [ $yn == "N" ]; then
        exit 0
    fi
elif [ $mode == "vuls" ]; then
    nmap -Pn --script vuln $host -oG vulns.tmp
elif [ $mode == "sploit" ]; then
    nmap -Pn --script exploit $host -oG exploit.tmp
elif [ $mode == "services" ]; then
    nmap -Pn -sV $host -oG services.tmp
elif [ $mode == "open" ]; then
    nmap -Pn --open $host -oG open.tmp
elif [ $mode == "deep" ]; then
    nmap -p- --script safe,auth $host -oG deep.tmp
elif [ $mode == "full" ]; then
    nmap -sn -sV -sC -oG full.tmp $cidr/24
elif [ $mode == "ics" ]; then
    nmap -p $ports --open -sV -Pn --script $scadas -o ics.tmp $cidr/24 
fi
echo -e "$nc"
