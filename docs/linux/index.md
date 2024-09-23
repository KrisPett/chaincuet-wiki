<img src="https://images.chaincuet.com/wiki/linux-arc2.jpeg" alt="linux" width="400" height="400">

### Linux Commands

##### Change owner of a folders recursively

```
sudo chown -R work ./
```

#### Check OS

```
cat /etc/os-release
```

#### List users

```
cat /etc/passwd
```

#### Change password

```
sudo passwd <username>
```

#### Check storage

```
df -h 
sudo fdisk -l
```

#### List all Users

```
awk -F: '{ if ($3 >= 1000 && $3 != 65534) print $1 }' /etc/passwd
```

#### List all groups

```
cat /etc/group
```

#### Create a group

```
sudo groupadd docker
```

#### Create user

```
sudo adduser bitwarden
sudo passwd bitwarden
```

#### Login to a specific user

```
su bitwarden
```

#### Add user to a group

```
sudo usermod -aG docker bitwarden
```

#### Change permission of directory

```
sudo chmod -R 700 /opt/bitwarden
sudo chown -R bitwarden:bitwarden /opt/bitwarden
```

## Check networks reachability

```ping <private_ip> 5433```

```telnet <private_ip> 5433```

### port already in use troubleshooting

```
sudo lsof -i :8080
kill <pid_number>
```

### Watch gpu

```
watch -n 1 nvidia-smi
```

### Watch cpu

- sudo apt install lm-sensors

```
watch -n 2 sensors
```
