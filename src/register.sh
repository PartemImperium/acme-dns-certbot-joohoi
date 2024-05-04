#!/usr/bin/env sh

# Helper script to make initial registration of domains easier
certbot certonly --manual \
                 --manual-auth-hook /opt/certbot-acme-dns/bin/acme-dns-auth.py \
                 --preferred-challenges dns \
                 --debug-challenges \
                 "$@" 


##### Explanation of flags ####
# --manual                                               -- run certbot in manual mode
# --manual-auth-hook /etc/letsencrypt/acme-dns-auth.py   -- Tell certbot about the acme-dns auth hook
# --preferred-challenges dns                             -- dns challenge is the only one that will work with acme-dns
# --debug-challenges                                     -- We need to pause execution before Let's Encrypt validates the records so you can manually add the CNAME records
# "$@"                                                   -- Pass any args that are passed to us. This will normally be the domains you want to set up ie -d example.org -d *.example.org
