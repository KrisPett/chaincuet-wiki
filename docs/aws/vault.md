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

### Usefull commands:
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
