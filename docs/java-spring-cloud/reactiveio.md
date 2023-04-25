#### Testing 

```jsx
public interface TestUtils {
    static <I, D> D retryBlock(I initial, Function<I, Mono<D>> transaction) {
        return Mono.just(initial)
                .flatMap(transaction)
                .timeout(Duration.ofSeconds(3))
                .retryWhen(Retry.backoff(3, Duration.ofMillis(10))
                        .filter(throwable -> throwable instanceof TimeoutException))
                .block(Duration.ofSeconds(10));
    }

    static <I, D> D retryBlock(Supplier<Mono<D>> transaction) {
        return Mono.just("")
                .flatMap(s -> transaction.get())
                .timeout(Duration.ofSeconds(3))
                .retryWhen(Retry.backoff(3, Duration.ofMillis(10))
                        .filter(throwable -> throwable instanceof TimeoutException
                                || throwable instanceof IncorrectUseMlkrException
                                || Exceptions.isErrorCallbackNotImplemented(throwable))
                )
                .block(Duration.ofSeconds(10));
    }
}
```
#### Webclient
```jsx
    private static Mono<String> getAccessTokenForUser() {
        String endpointUrl = "https://localhost:8080/auth/realms/<client>/protocol/openid-connect/token";
        WebClient webClient = WebClient.builder().baseUrl(endpointUrl).build();

        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("username", "test@gmail.com");
        body.add("password", "password");
        body.add("grant_type", "password");
        body.add("client_id", "");

        return webClient.post()
                .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
                .body(BodyInserters.fromFormData(body))
                .retrieve()
                .bodyToMono(String.class)
                .map(response -> new JSONObject(response).getString("access_token"));
    }
```

#### HttpClient
**import reactor.netty.http.client.HttpClient;**
```jsx
    public static Mono<String> getAccessTokenForUser() {
        final String ENDPOINT_URL = "https://localhost:8080/auth/realms/<client>/protocol/openid-connect/token";
        final String USERNAME = "test@gmail.com";
        final String PASSWORD = "test@gmail.com";
        final String GRANT_TYPE = "";
        final String CLIENT_ID = "";
        String basicAuthHeader = "Basic " + Base64.getEncoder().encodeToString(CLIENT_ID.getBytes());

        HttpClient httpClient = HttpClient.create()
                .baseUrl(ENDPOINT_URL);

        Flux<ByteBuf> requestBody = Flux.fromStream(Stream.of((
                        "username=" + USERNAME + "&" +
                                "password=" + PASSWORD + "&" +
                                "grant_type=" + GRANT_TYPE + "&" +
                                "client_id=" + CLIENT_ID)
                        .getBytes(CharsetUtil.UTF_8))
                .map(Unpooled::wrappedBuffer));

        return httpClient
                .headers(headers -> headers
                        .set(HttpHeaderNames.AUTHORIZATION, basicAuthHeader)
                        .set(HttpHeaderNames.CONTENT_TYPE, "application/x-www-form-urlencoded")
                )
                .post()
                .send(requestBody)
                .responseSingle((response, byteBufMono) -> {
                    if (response.status().code() == HttpResponseStatus.OK.code()) {
                        return byteBufMono.asString(StandardCharsets.UTF_8)
                                .map(json -> new JSONObject(json).getString("access_token"));
                    } else {
                        return Mono.error(new RuntimeException("Error: " + response.status().code()));
                    }
                });
    }
```