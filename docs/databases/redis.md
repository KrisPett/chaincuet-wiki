### Exec into redis container

```
docker exec -it chaincue-real-estate-redis bash
```

### Use redis-cli

```
redis-cli

using password
edis-cli -a redis 
```

### List all keys

```
KEYS *
```

### Get value by key

```
GET <key>
```

### Flush all keys

```
FLUSHALL
```

### Expiration time

```
TTL <key>
```

### docker-compose.yml

```
version: '3.9'
services:
  redis:
    container_name: chaincue-real-estate-redis
    image: redis:7.2.3
    ports:
      - "6379:6379"
    command: redis-server --requirepass redis
    networks:
      - chaincue-real-estate-network

networks:
  chaincue-real-estate-network:
    driver: bridge
    name: chaincue-real-estate-network
```
