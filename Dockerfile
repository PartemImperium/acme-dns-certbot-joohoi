FROM certbot/certbot:v2.10.0

# Add register.sh and acme-dns-auth.py to bin (mostly to make register.sh easier to run)
ENV PATH="${PATH}:/opt/certbot-acme-dns/bin"

# Install supercronic so we can auto renew the certs
RUN apk add --no-cache supercronic shadow

# Add the certbot hook/register script 
ADD src /opt/certbot-acme-dns/bin/
# and crontab into container
ADD crontab /opt/certbot-acme-dns/

VOLUME ["/etc/letsencrypt", "/var/lib/letsencrypt"]
ENTRYPOINT ["/usr/bin/supercronic", "/opt/certbot-acme-dns/crontab"]