# SSH

```
ssh-keygen -t rsa
```

```
ssh-keygen -t ed25519 -C "ubuntu@domain"
```

### SSH using password

```
sshpass -p password ssh -o StrictHostKeyChecking=no ubuntu@<server> /bin/bash -ic "deploy.sh"
```

### SSH into server without using password

- Create SSH keypair 'ssh-keygen -t rsa'
- touch .ssh/authorized_keys -> copy public key here
- SSH using private key ssh -i id_rsa username@server_ip
