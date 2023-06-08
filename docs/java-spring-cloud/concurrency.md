# Concurrency vs Parallelism

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
