#### Nginx conf on server 

##### Setup ssl/tls

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
