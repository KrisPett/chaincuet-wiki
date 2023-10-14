## Cosmos

**Cosmos DB (Azure Cosmos DB)** is a fully managed NoSQL database service provided by Microsoft Azure.

In **Amazon Web Services (AWS)**, a service similar to Microsoft Azure's Cosmos DB is Amazon DynamoDB.

- Create Cosmos DB
- Create Database (chaincue)
- Create Container (user_images), partition key (userId)
- Add Item ()

## Run Cosmos in docker container and access in Spring Boot

Cosmos in a container needs a valid certificate.

You need to specify the correct jdk your using for the project in IntelliJ.

If you restart container you need to do the setup again and use a different name ./emulatorcert1.crt when generating
cacerts.

[https://localhost:8081/_explorer/index.html](https://localhost:8081/_explorer/index.html)

- ```docker compose up```
- ```curl -k https://localhost:8081/_explorer/emulator.pem > ./emulatorcert1.crt```
- ```sudo keytool -import -file emulatorcert1.crt -alias emulatorcert1 -keystore ~/.jdks/corretto-17.0.8.1/lib/security/cacerts -storepass changeit```

```
version: '3.9'
services:
  cosmos:
    container_name: cosmos
    image: mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator:latest
    ports:
      - "8081:8081"
      - "10251:10251"
      - "10252:10252"
      - "10254:10254"
```

```
azure.serviceURI=https://localhost:8081/
azure.primarySecretKey=https://localhost:8081/_explorer/index.html
azure.database=db
```

```
@Configuration
@EnableConfigurationProperties(AzureCredentials.class)
@AllArgsConstructor
public class CosmosSpringConfigurationLocal extends AbstractCosmosConfiguration {
    private final AzureCredentials credentials;

    @Bean
    public CosmosClientBuilder cosmosClientBuilder() {
        return new CosmosClientBuilder()
                .endpoint(credentials.getServiceURI())
                .key(credentials.getPrimarySecretKey());
    }

    @Bean
    public CosmosAsyncClient cosmosAsyncClient() {
        return cosmosClientBuilder().buildAsyncClient();
    }

    @Bean
    public CosmosConfig cosmosConfig() {
        return CosmosConfig.builder()
                .responseDiagnosticsProcessor(new ResponseDiagnosticsProcessorImpl(credentials))
                .enableQueryMetrics(credentials.isQueryMetricsEnabled())
                .build();
    }

    @Override
    protected String getDatabaseName() {
        return credentials.getDatabase();
    }
}

@Getter
@Setter
@ConfigurationProperties(prefix = "azure")
public class AzureCredentials {
    private String serviceURI;
    private String primarySecretKey;
    private String database;
}
```
