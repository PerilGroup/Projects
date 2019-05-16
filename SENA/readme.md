# S.E.N.A
##### Simple. Effective. Nmap. Aide.
###### Project by: [Peril Group](https://twitter.com/perilgroup) & [NullArray](https://github.com/NullArray)
---------------
### Intro:
SENA is just what it says - a simple & effective AIDE to nmap, with a few more twist and turns([NullArray](https://github.com/NullArray)). It uses NMAP's default libraries[(NSE/s)](https://nmap.org/book/nse-usage.html) to its full potential.

From recon, http scans, quick defaults, to samba -> MSF - SENA has you covered!

#### Usage & Commands
> ***usage**:
> ./sena.sh ```IP/host``` (No mode = quick default scan "```-sC```")
./sena.sh ```IP/host``` ```[mode]```

| Command | Usage  |
| -------- | ------ |
| open | ```Return only open ports via [host]```
| services | ```Return services attached to [host]```
| safe | ```Scripts which weren't designed to crash services.```
| auth | ```These scripts deal with authentication credentials (or bypassing them) on the target system. ```
| vuln | ```These scripts check for specific known vulnerabilities and generally only report results if they are found```
| exploit | ```These scripts aim to actively exploit some vulnerability. Examples include jdwp-exec and http-shellshock.```
| full | ```This mode searches for any/ALL ports while scanning the hosts CIDR.```
| deep | ```This mode ultilizes [safe & auth] while searching hosts CIDR```
| ics | ```This mode ultilizes pre-builtin ports & ICS discovery NSE scripts while searching hosts CIDR```
| Next? | **More as we add them. Don't worry** 
>***This project will continiously be updated by both [NullArray](https://github.com/NullArray) & [PerilGroup](https://twitter.com/PerilGroup).***
----
## Script Disclaimer:
```None of the members, contributors, programmers, or anyone else connected with Peril Group, in any way whatsoever, can be responsible for your use of the scripts and/or tools contained in or linked from this github.```
