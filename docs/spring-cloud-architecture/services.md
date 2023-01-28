### Services

### POM

```
Lombok
Spring Reactive Web
Spring Data Reactive MongoDB
Embedded MongoDB Database
Testcontainers
Config Client
Eureka Discovery Client
Spring Boot Actuator
Sleuth
Zipkin Client
Prometheus

spring-cloud-starter-kubernetes-client-loadbalancer
Resilience4j Reactor

<maven.build.timestamp.format>yyyy-MM-dd HH:mm</maven.build.timestamp.format>

```

### application.yml

```
project:
  version: "@project.version@"
  spring-cloud-version: "@spring-cloud.version@"
  description: "@project.description@"
  timestamp: "@maven.build.timestamp@"

spring:
  application:
    name: ...service
  config:
    import: optional:configserver:http://localhost:9000

management:
  endpoints:
    web:
      exposure:
        include: [ "info", "health"]
        

---
spring:
  config:
    activate:
      on-profile: test
  mongodb:
    embedded:
      version: 4.4.9
```
