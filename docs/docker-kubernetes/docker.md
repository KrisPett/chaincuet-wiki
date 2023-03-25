#### Run node mount volume in current directory 'npm i' inside container

```
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0 bash
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh -c "cd app && yarn dev"

docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:14.0.0-alpine sh
```

#### Run maven with a specific version

```
docker run -it --rm -p 1000:1000 --name maven-11 -v ${PWD}:/app maven:3.8.6-openjdk-11 sh
```

#### On windows may run powershell on administrator

```
docker run --rm -it -p 3000:3000 -v %cd%:/app node sh
docker run --rm -it -p 3000:3000 -v /$(pwd):/app node sh
pwd
docker run --rm -it -p 3000:3000 -v C:drive:/app node sh
```

#### Kill a running npm process in docker

```
kill $(lsof -t -i:3000)
```

#### Cleanup Docker

```
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

```
#### remove all <none> tag images 
```
docker image prune --filter="dangling=true"
```

### Backup volume data
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
