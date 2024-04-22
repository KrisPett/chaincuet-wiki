### Open-sourced libraries

- Actix-web
- sea-orm (sqlx, tokio)

### Useful commands

```
cargo run
```

```
cargo build --release
```

####  Disable warning and only show errors

```
export RUSTFLAGS=-Awarnings cargo check
```

### Actix-web

When running in docker container local port must be 0.0.0.0 and not 127.0.0.1

```
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(move || {
        App::new()
    })
        // .bind("127.0.0.1:8080")?
        .bind(("0.0.0.0", 8080))?
        .run()
        .await
}
```
