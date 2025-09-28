:: Disable Telemetry IP's
cd %SystemRoot%\System32\drivers\etc
if not exist hosts.bak ren hosts hosts.bak 
curl -l -s https://winhelp2002.mvps.org/hosts.txt -o hosts
if not exist hosts ren hosts.bak hosts 