[https://testdriven.io/blog/managing-secrets-with-vault-and-consul/](https://testdriven.io/blog/managing-secrets-with-vault-and-consul/)

[https://github.com/visa2learn/spring-cloud-vault-db-cred-rotation](https://github.com/visa2learn/spring-cloud-vault-db-cred-rotation)

### init

```
docker-compose -f docker-compose-vault.yml up -d --build
docker exec -it <...> bash
```

```
vault operator unseal
vault login
```

```
export VAULT_TOKEN=your_token_goes_here
```

### Usefully commands:

```
export VAULT_ADDR=http://127.0.0.1:8200

Auth
curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    --request LIST \
    http://127.0.0.1:8200/v1/auth/token/accessors
    
#Add new secret engine
vault secrets enable -path=secret kv
vault secrets enable -path=secret -version=2 kv
vault secrets list 

#Interact with engine
vault kv put secret/psql username=postgres password=password
vault kv get secret/psql

```

### Config vault with postgres example

```
vault secrets disable database
vault secrets enable database
vault secrets list

vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@psql-db:5432/<...>?sslmode=disable" \
     allowed_roles="*" \
     username="postgres" \
     password="password"


vault write database/roles/loginToPostgres db_name=postgresql \
     creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\"; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
     default_ttl="30s" \
     max_ttl="1m"

vault list database/roles/
vault read database/creds/loginToPostgres
```

### Prod Setup

[https://github.com/KQT3/vault-setup](https://github.com/KQT3/vault-setup)

#### docker-compose.yml

```
version: '3.5'

services:
  vault:
    build:
      context: ./vault
      dockerfile: Dockerfile
    container_name: vault-1
    ports:
      - 8200:8200
    volumes:
      - ./vault/config:/vault/config
      - ./vault/policies:/vault/policies
      - ./vault/data:/vault/data
      - ./vault/logs:/vault/logs
    environment:
      - VAULT_ADDR=http://127.0.0.1:8200
      - VAULT_API_ADDR=http://127.0.0.1:8200
    command: server -config=/vault/config/vault-config.json
    cap_add:
      - IPC_LOCK
```

#### Dockerfile

```
# base image
FROM alpine:3.14

# set vault version
ENV VAULT_VERSION 1.8.2

# create a new directory
RUN mkdir /vault

# download dependencies
RUN apk --no-cache add \
      bash \
      ca-certificates \
      wget

# download and set up vault
RUN wget --quiet --output-document=/tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip /tmp/vault.zip -d /vault && \
    rm -f /tmp/vault.zip && \
    chmod +x /vault

# update PATH
ENV PATH="PATH=$PATH:$PWD/vault"

# add the config file
COPY ./config/vault-config.json /vault/config/vault-config.json

# expose port 8200
EXPOSE 8200

# run vault
ENTRYPOINT ["vault"]
```

#### ~/vault/config

vault-config.json

```
{
  "backend": {
    "file": {
      "path": "vault/data"
    }
  },
  "listener": {
    "tcp":{
      "address": "0.0.0.0:8200",
      "tls_disable": 1
    }
  },
  "ui": true
}
```

#### Scripts

**auth.py**

```
#!/usr/bin/env python3

import hvac

def init_server():

    client = hvac.Client(url='http://127.0.0.1:8200')
    print(f" Is client authenticated: {client.is_authenticated()}")

init_server()
```

**read.py**

```
#!/usr/bin/env python3

import hvac

def read_secret():

    client = hvac.Client(url='http://127.0.0.1:8200')
    print(f" Is client authenticated: {client.is_authenticated()}")
    read_response = client.secrets.kv.v1.read_secret(path='psql')
    print(read_response['data']['password'])
    
    return read_response['data']['password']

read_secret()
```

#### Setup using UI

- Key Shares (Default): 5 key shares
- Key Threshold (Default): 3 key shares

In the default setup, when you initialize Vault for the first time, the root key will be split into 5 parts (key
shares). you will only need 3 out of the 5 key shares to reconstruct the root key and unseal Vault.

- Enable new engine
- KV
- Create secret

#### Create tls

**https://localhost:8200/ui/vault**

Change owner of files **sudo chown -R systemd-network .**

**Use same encryption as nginx**

```
ssl_certificate /etc/letsencrypt/live/vault.example.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/vault.example.com/privkey.pem; # managed by Certbot
```

```
openssl genpkey -algorithm RSA -out localhost.key
openssl req -new -key localhost.key -out localhost.csr -subj "/CN=localhost"
openssl x509 -req -days 365 -in localhost.csr -signkey localhost.key -out localhost.crt
```

```
openssl genpkey -algorithm RSA -out vault.key
openssl req -new -key vault.key -out vault.csr -subj "/CN=vault.example.com"
openssl x509 -req -days 365 -in vault.csr -signkey vault.key -out vault.crt
sudo chown -R systemd-network .
```
