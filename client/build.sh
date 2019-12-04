npm run build
rsync -rav --size-only -e "ssh -p 666 -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress ../httpdocs/js ../httpdocs/css  root@pitverwaltung.de:/var/www/vhosts/pitverwaltung.de/httpdocs
