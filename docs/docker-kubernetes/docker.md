#### Run node mount volume in current directory 'npm i' inside container

```
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0 bash
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh
docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:19.5.0-alpine sh -c "cd app && yarn dev"

docker run -it --rm -p 3000:3000 --name node -v ${PWD}:/app node:14.0.0-alpine sh
```

#### Run container with network host and command 

```
docker run -it --rm -p 3000:3000 --name node --network host -v ${PWD}:/workdir node:19.0.0-alpine sh -c "\
npm install -g npm && \
npm install -g truffle && \
apk add --no-cache git && \
cd /workdir && \
sh"
```

#### Update package.json version and build

```
docker run -it --rm -e NEW_VERSION=1.154.0 -v ${PWD}:/workdir -w /workdir node:20-alpine sh -c '\
sed -i "s/\"version\": \"[0-9]*\\.[0-9]*\\.[0-9]*\"/\"version\": \"$NEW_VERSION\"/g" package.json && \
npm run build'
```

#### Run maven with a specific version

```
docker run -it --rm -p 1000:1000 --name maven-11 -v ${PWD}:/app maven:3.8.6-openjdk-11 sh
```

#### Run with a specific cpuset-cpus

```
docker run -it --rm -p 3000:3000 --name node --cpuset-cpus 7 --network host -v ${PWD}:/workdir -w /workdir node:14 bash
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

#### remove all 'none' tag images 

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

### Setup Docker without docker

```
sudo groupadd docker
sudo gpasswd -a $USER docker
Restart pc
```

### Show info about docker

```
docker info
```

### Remove containers with a specific image

```
docker ps -a | awk '$2 == "docker/compose:1.29.2" {print $1}' | xargs docker rm
```

### TestContainer

```
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <version>1.18.1</version>
    <scope>test</scope>
</dependency>
@SpringBootTest
@Testcontainers
class ContainersTest {

    @Container
    private static final DockerComposeContainer<?> serverContainer = new DockerComposeContainer(new File("src/test/resources/docker-compose.yml"))
            .withExposedService("server", 8082);

    @BeforeEach
    void setUp() {
        serverContainer.start();
    }

    @AfterEach
    void tearDown() {
        serverContainer.stop();
    }

    @Test
    void test() {

    }
}
```