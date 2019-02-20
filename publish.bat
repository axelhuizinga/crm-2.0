@echo off

cp -ur bin/* H:/httpdocs
rem "C:\Program Files\PuTTY\pscp.exe" -P 60666 -l root %1 pitverwaltung.de:/var/www/vhosts/pitverwaltung.de/httpdocs 

echo "Done :)"