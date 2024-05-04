# acme-dns-certbot-joohoi

An example [Certbot](https://certbot.eff.org) client hook for [acme-dns](https://github.com/joohoi/acme-dns). 

This authentication hook automatically registers acme-dns accounts and prompts the user to manually add the CNAME records to their main DNS zone on initial run. Subsequent automatic renewals by Certbot cron job / systemd timer run in the background non-interactively.

Requires either 
   * Docker
   * Certbot >= 0.10, Python requests library.

## Installation

### Docker
1) Clone repo

2) Modify the ACMEDNS_URL environment variable (or any other config)

3) Run docker compose to start the container (with the current working directory in the root of the project)
```
docker compose up
```

### Manual
1) Install Certbot using instructions at [https://certbot.eff.org](https://certbot.eff.org)

2) Make sure you have the [python-requests](http://docs.python-requests.org/en/master/) library installed.

3) Download the authentication hook script and make it executable:
```
$ curl -o /etc/letsencrypt/acme-dns-auth.py https://raw.githubusercontent.com/joohoi/acme-dns-certbot-joohoi/master/acme-dns-auth.py
$ chmod 0700 /etc/letsencrypt/acme-dns-auth.py
```

4) Configure the variables in the beginning of the hook script file to point to your acme-dns instance. The only value that you must change is the `ACMEDNS_URL`, other values are optional.
   
   a) Alternitively you can use environment variables to configure the hook.
```
### EDIT THESE: Configuration values ###

# URL to acme-dns instance
ACMEDNS_URL = os.environ.get("ACMEDNS_URL", "https://auth.acme-dns.io")
# Path for acme-dns credential storage
STORAGE_PATH = os.environ.get("STORAGE_PATH", "/etc/letsencrypt/acmedns.json")
# Whitelist for address ranges to allow the updates from
# Example: ALLOW_FROM = ["192.168.10.0/24", "::1/128"]
ALLOW_FROM = os.environ.get("ALLOW_FROM", [])
# Force re-registration. Overwrites the already existing acme-dns accounts.
FORCE_REGISTER = os.environ.get("FORCE_REGISTER", False)
```

## Usage

### Docker
On initial run: 
```
docker compose exec certbot-acme-dns register.sh -d example.org -d \*.example.org
```

### Manual
On initial run:
```
certbot certonly --manual --manual-auth-hook /etc/letsencrypt/acme-dns-auth.py \
   --preferred-challenges dns --debug-challenges                               \
   -d example.org -d \*.example.org
```
Note that the `--debug-challenges` is mandatory here to pause the Certbot execution before asking Let's Encrypt to validate the records and let you to manually add the CNAME records to your main DNS zone.

### Common steps
After adding the prompted CNAME records to your zone(s), wait for a bit for the changes to propagate over the main DNS zone name servers. This takes anywhere from few seconds up to a few minutes, depending on the DNS service provider software and configuration. Hit enter to continue as prompted to ask Let's Encrypt to validate the records.

After the initial run, Certbot is able to automatically renew your certificates using the stored per-domain acme-dns credentials. This can be done manualy with the `cerbot renew` command or letting certbot's auto renewal run.
