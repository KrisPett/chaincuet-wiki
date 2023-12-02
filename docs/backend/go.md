#### Setup Go in IntelliJ

- Download latest from go.dev
- add ```export PATH=$PATH:/usr/local/go/bin``` in .bashrc
- IntelliJ > Settings > Langugaes & Frameworks > Go > GOROOT > /use/local/go

#### Useful commands

- go mod init test (create go project)
- go get ./... (install all dependencies)
- go get github.com/stretchr/testify/assert (install specific dependencies)

#### Setup a project

```
mkdir aws-go-examples
cd aws-go-examples
go mod init aws-go-examples
go get -u github.com/gin-gonic/gin
mkdir -p ./src/github.com/kqt3/aws-go-examples && cd "$_"
curl https://raw.githubusercontent.com/gin-gonic/examples/master/basic/main.go > main.go
go get -u github.com/gin-gonic/gin
go run main.go
```

- The cmd/ directory contains the main applications for the project. Each subdirectory under cmd/ represents a separate
  application.

- The internal/ directory contains packages that are used only by the main applications in cmd/.

- The pkg/ directory contains packages that are shared by multiple applications.

- The vendor/ directory contains copies of external dependencies that are used by the project.

- The go.mod file contains the module definition for the project.

- The go.sum file contains the cryptographic hashes of the dependencies used in the project.

```
project-root/
├── cmd/
│   └── server/
│       └── main.go
├── internal/
│   ├── config/
│   ├── handlers/
│   ├── middleware/
│   ├── models/
│   └── routes/
├── pkg/
├── vendor/
├── go.mod
└── go.sum
```

In this structure, the cmd/ directory holds the main application executable, which in this case would be the server. The
internal/ directory contains the internal packages used by the application, including config/, handlers/, middleware/,
models/, and routes/. The pkg/ directory is used to store reusable packages that can be used by other Go projects. The
vendor/ directory holds the external dependencies of the project.

This structure follows the standard layout recommended by the Go community and makes it easier to organize the code in a
modular and scalable way. However, this is just a recommendation and you are free to organize your code in a way that
works best for you and your project.

**Testing**

- "github.com/stretchr/testify/assert"

**Object-Relational Mapping (ORM)**

- go get -u gorm.io/gorm

**Build project**

- go build -o main ./cmd/server

### Check memory usage of go

- go build -o main
- pgrep -fl main
- top -p 126868
- ps -p 126868 -o pid,rss,vsz --sort -rss | awk '{print $1, $2/1024, $3/1024}'

**RSS: is the actually memory being used.**

**VSZ: is allocated memory**

### Compare Kotlin and Go

| Application | PID    | RSS (MB) | VSZ (MB) |
|-------------|--------|----------|----------|
| Kotlin      | 129856 | 478.5    | 16.1     |
| Go          | 126868 | 20.3     | 1.8      |

### Go Commands

#### go mod init

```
go mod init <module-name>
```

#### download

```
go mod download
```

#### build

```
go build -o main
```

#### test

```
go test -v ./...
```

#### clean up

```
go mod tidy
```

#### verify

```
go mod verify
```

#### graph
```
go mod graph
```
