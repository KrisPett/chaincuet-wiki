#### Setup

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
  AllowedIPs = 000.000.000.0/24,0.0.0.0/0 # to allow internet access
```

- sudo wg-quick up peer1
- sudo wg-quick down peer1
- SSH: ssh username@0.0.0.0
- On default tunnel might disable you internet connection
- ip route 
