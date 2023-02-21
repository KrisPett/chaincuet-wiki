#### Nginx conf on server 

##### Setup ssl/tls

```
ln -s /path/to/auth.example.com /path/to/symlink

sudo apt install certbot
sudo apt-get install python3-certbot-nginx
sudo certbot --nginx --redirect -d auth.example.com
# Disable vpn connection when issue a certificate
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
