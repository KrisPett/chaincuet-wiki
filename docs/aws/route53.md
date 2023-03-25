## Cost 

- $0.50 per Hosted Zone for the first 25 Hosted Zones
- $0.40 per 1,000,000 queries
- Cost = (16,606 / 1,000,000) * $0.40 = 0.000016606 * $0.40 = $0.0000066424


## Records

#### A Record

An A record is a type of DNS record that maps a domain name to an IP address. It is used to point a domain name directly to the IP address of a server that hosts a website, mail server, or other network services. For example, if you have a website hosted on a server with an IP address of 1.2.3.4, you would create an A record in your DNS settings that maps your domain name to that IP address. This allows users to access your website by typing your domain name into their web browser.

 - Is used to generate ssl/tls certificates. (letsencrypt)

#### CNAME Record

A CNAME record is a type of DNS record that maps one domain name to another domain name. It is often used to create aliases or subdomains for a website. For example, if you have a website hosted on a server with a domain name of www.example.com, you might create a CNAME record that maps blog.example.com to www.example.com. This allows users to access your blog by typing blog.example.com into their web browser, and the traffic will be redirected to the www.example.com domain.

 - Is used to redirect a domain name to another domain name.

## Troubleshooting
**Usefull commands**

 - nslookup example.com
 - dig ns example.com
