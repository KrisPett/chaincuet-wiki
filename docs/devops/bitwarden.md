[https://bitwarden.com/help/install-on-premise-linux/](https://bitwarden.com/help/install-on-premise-linux/)

### Install bitwarden using nginx (notes)

**using nginx ssl instead of docker container nginx**

- ./bitwarden.sh install
- (!) Enter the domain name for your Bitwarden instance (ex. bitwarden.example.com): bitwarden.example.se
- (!) Do you want to use Let's Encrypt to generate a free SSL certificate? (y/n): n
- (!) Enter the database name for your Bitwarden instance (ex. vault): vault
- (!) Enter your installation id (get at https://bitwarden.com/host):
- (!) Enter your installation key:
- (!) Enter your region (US/EU) [US]: EU
- (!) Do you have a SSL certificate to use? (y/N): n
- (!) Do you want to generate a self-signed SSL certificate? (y/N): y
- ```Update config.yml (http_port: 8089) (https_port: 9443) (ssl: false)```
- ./bitwarden.sh rebuild
- ./bitwarden.sh start

```
server {
    server_name bitwarden.example.se;
    location / {
            proxy_pass      http://192.168.100.239:8089;
    } 
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
server {
    if ($host = bitwarden.example.se) {
        return 301 https://$host$request_uri;
    } # managed by Certbot
        server_name bitwarden.example.se;
    listen 80;
    return 404; # managed by Certbot
}
```
