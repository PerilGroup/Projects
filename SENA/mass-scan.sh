#!/bin/bash
#
# This is what i got so far
# Feel free to change or add to 
# Should you so desire
#                 -Null
###########################################
# Coloring scheme for notfications and logo
ESC="\x1b["
RESET=$ESC"39;49;00m"
CYAN=$ESC"33;36m"
RED=$ESC"31;01m"
GREEN=$ESC"32;01m"
 
#Regular Colors
BLACK=$ESC"\033[0;30m"        # Black
YELLOW=$ESC'\033[0;33m'       # Yellow
BLUE=$ESC'\033[0;34m'         # Blue
PURPLE=$ESC'\033[0;35m'       # Purple
WHITE=$ESC'\033[0;37m'        # White

# Bold
bb=$ESC'\033[1;30m'       # Black
br=$ESC'\033[1;31m'         # Red
bg=$ESC'\033[1;32m'       # Green
by=$ESC'\033[1;33m'      # Yellow
bb=$ESC'\033[1;34m'        # Blue
bp=$ESC'\033[1;35m'      # Purple
bc=$ESC'\033[1;36m'        # Cyan
bw=$ESC'\033[1;37m'       # White

# Host can be a single host or host file
host="$1"
mode="$2"
scadas="/$HOME/scada_nse/atg-info,BACnet-discover-enumerate,codesys-v2-discover,dnp3-info,enip-enumerate,fox-info,iec-identify,mms-identify,modbus-discover,modbus-enum,modicon-info,omrontcp-info,omronudp-info,pcworx-info,proconos-info,s7-enumerate,Siemens-CommunicationsProcessor,Siemens-HMI-miniweb,Siemens-Scalance-module,Siemens-SIMATIC-PLC-S7,Siemens-WINCC"    
ports="47808,20000,34980,44818,2222,55000,55555,55003,1091,1089,102,502,4840,80,443,34962,34964,4000,50001,50016,50018,50020,50021,50025,50028,50110-50111"   


# Store for later
CWD=$(pwd)
NOW=$(date)
# Current External IP
IPext=$(curl https://api.myip.com)

ip=$(dig +short $host | awk '{ print ; exit }')
cidr=$(echo $host | sed 's/[0-9]*$/0/')

# Warning
function warning(){
	echo -e "\n$RED [!] $1 $RESET\n"
	}

# Green notification
function notification(){
	echo -e "\n$GREEN [+] $1 $RESET\n"
	}

# Cyan notification
function notification_b(){
	echo -e "\n$CYAN [-] $1 $RESET\n"
	}


function usage(){
	# usage info will be here
	}

function nmap(){

	if [[ -z  $mode ]]; then
		sudo nmap -v -sV -sC $host -oG default.tmp
	fi
	 
	if [[ $mode == "titles" ]]; then
		nmap -sn $cidr/24 --script http-title -oG titles.tmp
	fi
	
	if [[ $mode == "auth" ]]; then 
		nmap -Pn --script auth $host -oG auth.tmp
	fi
	
	if [[ $mode == "safe" ]]; then 
		nmap -Pn --script safe $host -oG safe.tmp
	fi
	
	if [[ $mode == "intrude" ]]; then
		nmap -Pn --script intrusive -oG intrusive.tmp $host
	fi
	
	if [[ $mode == "http" ]]; then
		ncount=$(grep -r -c /usr/share/nmap/scripts/http-* | wc -l  )
		warning "This will check $host against $ncount NSEs."
		
		read -p 'Continue? Y/N: ' choice
    
		if [[ $choice == "Y" || $choice == "y"  ]]; then
			nmap --open --script "http-*" -oG http.tmp $host
		else
			exit 0
		fi
	fi
	
	if [[ $mode == "vuls" ]]; then
		nmap -Pn --script vuln $host -oG vulns.tmp
	fi
	
	if [[ $mode == "sploit" ]]; then
		nmap -Pn --script exploit $host -oG exploit.tmp
	fi
	
	if [[ $mode == "services" ]]; then
		nmap -Pn -sV $host -oG services.tmp
	fi
	
	if [[ $mode == "open" ]]; then
		nmap -Pn --open $host -oG open.tmp
	fi
	
	if [[ $mode == "deep" ]]; then
		nmap -p- --script safe,auth $host -oG deep.tmp
	fi
	
	if [[ $mode == "full" ]]; then
		nmap -sn -sV -sC -oG full.tmp $cidr/24
	fi
	
	if [[ $mode == "ics" ]]; then
		nmap -p $ports --open -sV -Pn --script $scadas -o ics.tmp $cidr/24 
	fi


	}

function proxies(){
	clear && sleep 2
	notification_b "Your current outward facing IP is: $IPext"
	printf "This component will gather some proxies to use while"
	printf "Port scanning with Nmap.\n"
	
	read -p 'Continue? Y/N: ' choice
	if [[ $choice == "Y" || $choice == "y"  ]]; then
		cd Proxies
		curl -sSf "https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list.txt" | sed '1,3d; $d; s/\s.*//; /^$/d' > proxy-list.txt
	else
		exit 0
	fi
	
	read -p 'Show results? Y/N: ' choice
	if [[ $choice == "Y" || $choice == "y"  ]]; then
		clear && sleep 2
		tail -n 25 proxy-list.txt
		notification "Done. You can find the complete list here $(PWD)" && sleep 3
		menu
	else
		clear && menu
	
}

function menu(){
	
	PS3='Please enter your choice: '
	options=("Help" "Gather Proxies" "Gather 1000 Hosts" "Gather 10000 Hosts" "Sort Services by Port" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Help")
				usage
				printf "%b \n"
				;;
			"Gather Proxies")
				proxies
				printf "%b \n"
				;;
			"Gather 1000 Hosts")
	
				printf "%b \n"
				;;
			"Gather 10000 Hosts")

				printf "%b \n"
				;;
			"Sort Services by Port")

				printf "%b \n"
				;;
			"Quit")
				break
				;;
			*) echo invalid option;;
		esac
	done
	
}



function checker(){
	
	notification_b "Initializing..." && sleep 2
	
	if [[ -d "Output" ]]; then
		mkdir Output
		mkdir Proxies
	fi
	
	if [[ -z $(which masscan) ]]; then
		notification "Installing mass scan" 
		sudo apt-get -y masscan 
		
		notification "Done."
		sleep 2 && clear
	fi
	
		if [[ -z $(which nmap) ]]; then
		notification "Installing Nmap" 
		sudo apt-get -y nmap 
		
		notification "Done."
		sleep 2 && clear
	fi
		
	}


if [[ "$EUID" -ne 0 ]]; then
	warning "This script requires root to run."
	exit 1
else
	checker
fi		

if [[ "$1" != "" ]]; then
	if [[ "$2" != "" ]]; then
		nmap
	else
		usage
		case $1 in
		'-m' | '--menu' )
		menu
		esac
	fi
else
	usage
	case $1 in
		'-m' | '--menu' )
		menu
	esac
fi
