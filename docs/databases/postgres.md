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
