### Core Concepts

#### Concurrency

Concurrency refers to the concept of multiple tasks being executed in overlapping time periods, potentially running
simultaneously. It doesn't necessarily mean true simultaneous execution (as in parallelism) but rather the appearance of
simultaneous progress.

**E.g. Two threads running at the same time, but they don't refer to the same memory**

#### Parallelism

Parallelism involves the simultaneous execution of multiple tasks or processes to achieve better performance and speed.
Unlike concurrency, parallelism implies that multiple tasks are genuinely being executed at the same time, usually on
multiple processors or cores. Parallelism is often used to divide a large task into smaller subtasks that can be
executed concurrently for faster results.

**E.g. Two threads running at the same time, but they share and points to the same memory, it means they can access and
modify the same variables directly.**

#### Asynchronous

Asynchronous programming is a programming paradigm that allows tasks to be performed independently of the main program
flow. It enables the execution of non-blocking operations, allowing a program to continue processing other tasks while
waiting for potentially time-consuming operations to complete. Asynchronous programming is commonly used in scenarios
such as handling I/O operations, network requests, or other tasks where waiting for a response would otherwise block the
program.

**E.g. Javascript fetch is async and doesn't block the main thread on the browser**

#### Coroutines

Coroutines are a lightweight and efficient concurrency design pattern introduced in many modern programming languages,
including Kotlin. Coroutines allow you to write asynchronous code in a more sequential and readable manner. They provide
a way to suspend and resume the execution of functions, enabling non-blocking, cooperative multitasking. Coroutines are
often used in scenarios where asynchronous programming is required, offering the benefits of concurrency without the
complexity of traditional threading models.

**E.g. Coroutines creates lightweight threads within the thread that is executing the program**

#### Threads vs Coroutines

Threads are significantly larger than coroutines. This is because threads have their own stack, which is a data
structure that stores the thread's local variables and the current execution context. Coroutines, on the other hand, do
not need their own stack. Instead, they share a single stack with the main thread. This makes coroutines much smaller
than threads.

Threads also use more memory than coroutines. This is because threads need to allocate memory for their stack, as well
as for other data structures such as the thread control block. Coroutines, on the other hand, do not need to allocate as
much memory.

The time complexity of creating threads and coroutines is also different. Creating a thread is a relatively expensive
operation, as it involves allocating memory and setting up the thread's execution context. Creating a coroutine is much
cheaper, as it does not require as much overhead.

- **1 thread requires around 1MB of memory.**
- **1 coroutine requires around 2KB of memory.**
- This means that you can create around 500,000 coroutines in one thread before you start to use up 1 MB of memory.
- **1 thread takes around 2-5 microseconds to create.**
- **1 coroutine takes around 200 nanoseconds to create.**
- 1000 nanoseconds is 1 microsecond. 1000 microseconds is 1 millisecond. and 1000 milliseconds is 1 second.

### Common Problems

#### Race Conditions

A race condition occurs when two or more threads or processes access shared data concurrently, and the final outcome
depends on the timing or order of their execution. This can lead to unpredictable and unintended behavior.

**Use synchronization mechanisms (e.g., locks, synchronized methods) to prevent.**

#### Deadlock

Deadlock is a situation where two or more threads are unable to proceed because each is waiting for the other to release
a resource, creating a circular waiting dependency.

**Carefully design the order in which resources are acquired, and use techniques such as resource allocation hierarchies
and timeouts to avoid deadlocks.**

#### Memory Leak

A memory leak occurs when a program allocates memory but fails to release it when it is no longer needed. In concurrent
programming, this can happen when references to objects are not properly managed.

**Ensure proper management of object references, use weak references where appropriate, and consider tools and profilers
to detect and resolve memory leaks.**

### Code Gists

#### Testing

```
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

```
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

```
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
