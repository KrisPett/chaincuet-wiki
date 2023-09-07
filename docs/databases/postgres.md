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

### Switch to keycloak database

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
### Delete from table
```
SELECT * FROM materials;
DELETE FROM materials WHERE id = '43df4b5-bf0d-4a98-a0cf-ab45adc92f38';
```

### Backup postgres data
**Dont restore backup while**
```
mkdir backup && cd backup

# Make a backup
sudo docker run --rm \
    -v postgres_data_03_25_23:/data \
    -v $(pwd):/backup \
    busybox tar czf /backup/postgres_data_03_25_23.tar.gz /data
    
# Restore backup
# Dont restore backup while postgres is running
sudo docker run --rm \
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

#### create admin user in keycloak

```
SELECT * FROM user_entity;

INSERT INTO user_entity (id, username, email, first_name, last_name) VALUES ('uuid', 'admin', 'admin@example.com', 'Admin', 'User');

SELECT * FROM credential;

Hashed password
echo -n 'password' | openssl dgst -sha256

INSERT INTO credential (id, user_id, created_date, credential_data, type, user_label) VALUES ('UUid', 'uuidID', now(), '<hashed_password>', 'password', 'password');


INSERT INTO user_role (id, realm_id, user_id, role_id) VALUES ('<new_uuid>', 'master', '<user_entity_id>', '<admin_role_id>');
```
