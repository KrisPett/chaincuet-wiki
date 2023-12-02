#### Install Nginx

- sudo apt install nginx-core (/usr/sbin/nginx)

#### Nginx conf on server

##### Setup ssl/tls

**template**

```
server {
  server_name chain.se;
  location / {
          proxy_pass http://172.00.00.00:8080;
  }
  listen 80;
}
```

- sudo ln -s /path/to/auth.example.com.conf /path/to/symlink
- sudo certbot --nginx --redirect -d auth.example.com
- sudo nginx -t
- sudo systemctl restart nginx
- sudo systemctl status nginx

```
sudo ln -s /path/to/auth.example.com.conf /path/to/symlink
# Run it from sites-enabled (../sites-available/auth.example.com.conf .)

sudo apt install certbot
sudo apt-get install python3-certbot-nginx
sudo certbot --nginx --redirect -d auth.example.com
sudo systemctl restart nginx

# Troubleshooting
Disable vpn connection when issue a certificate
nslookup example.com
dig ns example.com
Use A record instead of CNAME
```

##### Clean Setup (auth.example.com.conf)

```
server {
    server_name auth.example.com;

    location / {
        proxy_pass http://1.1.1.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

##### Using nextJs and Next-auth and keycloak

**Might have to change buffer size if its too large**
Increasing these values can solve the "upstream sent too big header" error is because this error occurs when the
response from your upstream server contains headers that are too large for Nginx's buffers to handle. By increasing the
number and size of the buffers, you're allowing Nginx to handle larger headers.

It's worth noting that while increasing these values can solve this error, it also uses more memory. Therefore, it's
important to monitor your server's memory usage to ensure it's not running out of memory due to these larger buffers.

- Given that each request consumes 512 kilobytes of memory (0.5 mebibytes or MiB), we can calculate the maximum number
  of
  requests per second using the following formula:
- Maximum Requests per Second = Available Memory / Memory Usage per Request
- Maximum Requests per Second = 780 MB / 0.5 MiB
- Maximum Requests per Second = 1560
- Based on this calculation, your server could potentially handle up to 1560 requests per second, assuming each request
  consumes 512 kilobytes of memory.

```
server {
    server_name chainbot.chaincuet.com;

    location / {
        proxy_pass http://172.31.52.49:3000;
        proxy_buffers 4 8k;
	    proxy_buffer_size 8k;
#       proxy_buffers 16 32k;
        proxy_set_header    Host               $host;
        proxy_set_header    X-Real-IP          $remote_addr;
        proxy_set_header    X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Host   $host;
        proxy_set_header    X-Forwarded-Server $host;
        proxy_set_header    X-Forwarded-Port   $server_port;
        proxy_set_header    X-Forwarded-Proto  $scheme;
}
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/chainbot.chaincuet.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/chainbot.chaincuet.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}
server {
    if ($host = chainbot.chaincuet.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80;
    server_name chainbot.chaincuet.com;
    return 404; # managed by Certbot
}
```

