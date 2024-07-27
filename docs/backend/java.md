### Install Java Ubuntu

#### Option 1

- ```sudo apt remove *jdk*```
- sudo apt update
- sudo add-apt-repository ppa:linuxuprising/java
- java --version
- sudo apt install openjdk-21-jre

#### Option 2

- https://www.oracle.com/java/technologies/downloads/
- Download deb
- chmod +x jdk-22_linux-x64_bin.deb
- sudo dpkg -i jdk-22_linux-x64_bin.deb
- sudo apt install maven

### Setup Concurrent Testing

```
import org.junit.jupiter.api.parallel.Execution;
import org.junit.jupiter.api.parallel.ExecutionMode;

@Execution(ExecutionMode.CONCURRENT)
class Test {
    @RepeatedTest(10)
    void test() {}
}

src
└── test
    ├── java
    └── resources
        └── junit-platform.properties

junit.jupiter.execution.parallel.enabled=true
```

### Maven

```
mvn clean install
java -jar target/<project>.jar
```

### Gradle

```
./gradlew clean build
java -jar build/libs/<project>.jar
```
