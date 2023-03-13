## Testing 

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