#### Run node mount volume in current directory 'npm i' inside container

```
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0 bash
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh -c "cd app && yarn dev"

docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:14.0.0-alpine sh
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
