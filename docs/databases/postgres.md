### Exec into postgres container

```
docker exec -it postgres_name psql -U postgres
```

### LIST DATABASES

```
docker exec -it postgres_name psql -U postgres -c "\l"
```

### LIST ROLES

```
docker exec -it postgres_name psql -U postgres -c "\du"
```

### Swtich to keycloak database

```
\c keycloak
```

### List of relations

```
\d
```

### List of relations

```
\c keycloak
\d
SELECT * FROM user_entity;
SELECT * FROM realm;
SELECT * FROM credential;
echo 'secretPassword' | base64
echo -n c2VjcmV0UGFzc3dvcmQK | base64 --decode
```

### Quit

```
\q
```

### Backup postgres data
**Dont restore backup while**
```
mkdir backup && cd backup

# Make a backup
docker run --rm \
    -v postgres_data_03_25_23:/data \
    -v $(pwd):/backup \
    busybox tar czf /backup/postgres_data_03_25_23.tar.gz /data
    
# Restore backup
# Dont restore backup while postgres is running
docker run --rm \
    -v postgres_data_03_25_23:/data \
    -v $(pwd):/backup \
    busybox tar xzf /backup/postgres_data_03_25_23.tar.gz
```

### pgAdmin4

```
# export POSTGRES_PASSWORD=postgres_password
version: "3.8"
services:
  pgadmin_03_25_23:
    container_name: pgadmin_03_25_23
    image: dpage/pgadmin4:6.21
    ports:
      - "5050:80"
    volumes:
      - pgadmin_data_03_25_23:/var/lib/pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: pgadmin_03_25_23@email.com
      PGADMIN_DEFAULT_PASSWORD: pgadmin_03_25_23@email.com
    networks:
      - chaincue-tech-net

  postgres_kc_03_25_23:
    container_name: postgres_kc_03_25_23
    image: postgres:10.4
    restart: always
    volumes:
      - postgres_data_03_25_23:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: keycloak_DB
      POSTGRES_USER: keycloak_user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5433:5432"
    networks:
      - chaincue-tech-net
      
volumes:
  postgres_data_03_25_23:
    name: postgres_data_03_25_23
  pgadmin_data_03_25_23:
    name: pgadmin_data_03_25_23
```