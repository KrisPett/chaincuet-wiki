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

