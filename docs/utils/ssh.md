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


### Specify a port 

```
ssh -i your_private_key_file -p 22222 ubuntu@192.168.000.000
```

### echo to a .pem 

```
cat your_private_key_file | base64
echo "BASE64_ENCODED_STRING" | base64 --decode > your_private_key_file
chmod 400 your_private_key_file
```

### debug ssh

```
ssh -i your_private_key_file -p 22222 -vvv ubuntu@192.168.000.000
```
