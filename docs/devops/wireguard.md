[Install](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04#step-3-%E2%80%94-creating-a-wireguard-server-configuration])

### Install Ubuntu

- sudo apt install wireguard
- sudo apt install openresolv # sometimes necessary
- touch /etc/wireguard/peer1.conf

```
 [Interface]
  Address = <>
  PrivateKey =
  ListenPort = <>
  DNS = <>
  [Peer]
  PublicKey =
  PresharedKey =
  Endpoint = <>
  AllowedIPs = 000.000.000.0/24,0.0.0.0/0,::/0 # to allow internet access
```

- sudo wg-quick up peer1
- sudo wg-quick down peer1
- SSH: ssh username@0.0.0.0
- On default tunnel might disable you internet connection
- ip route

### Install alpine docker

**Macvlan network**

- docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=enp0s31f6 my_macvlan
- docker run --rm -d --network my_macvlan --dns 8.8.8.8 --privileged docker:dind

**Host network**

- docker run -d --privileged --network host docker:dind # Using host network might work

- apk add wireguard-tools-wg-quick
- mkdir /etc/wireguard
- echo "[Interface]
  Address = 10.10.10.1
  PrivateKey = <>
  ListenPort = 51820
  DNS = 10.10.10.1
  [Peer]
  PublicKey = <>
  PresharedKey = <>
  Endpoint = wireguard.m2k.se:51821
  AllowedIPs = 0.0.0.0/0" > wg0.conf
- wg-quick up wg0

### Docker Compose

https://github.com/christianlempa/videos/tree/main/wireguard-docker

```
version: "3.9"
services:
  wireguard:
    image: lscr.io/linuxserver/wireguard:latest
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Stockholm
      - SERVERURL=<public_ip_of_server_or_domain_name>:51821 #optional
      - SERVERPORT=51821 #optional
      - PEERS=10 #optional
      - PEERDNS=auto #optional
      - ALLOWEDIPS=<public_subnet_ip> #optional
      - LOG_CONFS=true #optional
    volumes:
      - /opt/wireguard/config:/config
      - /lib/modules:/lib/modules #optional
    ports:
      - 51821:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped
```

Will create 10 peers, use peers to connect from client to server

**peer1_server**

```
[Interface]
Address = 10.13.13.2
PrivateKey = <peer1_private_ip>
ListenPort = 51820
DNS = 10.13.13.1

[Peer]
PublicKey = <peer1_public_ip>
PresharedKey = <peer1_preeshared_ip>
Endpoint = <public_ip_of_server_or_domain_name>:51821
AllowedIPs = <public_subnet_ip>
```

**peer1-client**

```
[Interface]
Address = 10.13.13.2
PrivateKey = <peer1_private_ip>
ListenPort = 51820
DNS = 10.13.13.1
[Peer]
PublicKey = <peer1_public_ip>
PresharedKey = <peer1_preeshared_ip>
Endpoint = <public_ip_of_server_or_domain_name>:51821
AllowedIPs = <public_subnet_ip>, 0.0.0.0/0, ::/0
```

