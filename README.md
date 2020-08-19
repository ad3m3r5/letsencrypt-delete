# letsencrypt-delete

I often use a script made for nginx to enable and disable configs. I got tired of manually deleting the cert files for letsencrypt. I combined these two things into this script.

### Usage

 - -d | --delete
	 - This will allow you to pass a cert name or select from a provided list of live certs in the /etc/letsencrypt/live directory
	 - Deletes:
		 - /etc/letsencrypt/live/<certname>
		 - /etc/letsencrypt/archive/<certname>
		 - /etc/letsencrypt/renewal/<certname>.conf
 - -l | --list
	 - List the lives certs found in /etc/letsencrypt/live

Easily delete letsencrypt certs.
