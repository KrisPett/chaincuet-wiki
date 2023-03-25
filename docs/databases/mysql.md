### Create mysql container

```
docker run -it --name some-mysql -e MYSQL_ROOT_PASSWORD=yourpassword mysql
```

### Exec into mysql container

```
docker exec -it some-mysql mysql -p
```

### LIST DATABASES

```
SHOW DATABASES;
```