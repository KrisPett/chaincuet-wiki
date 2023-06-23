#### Setup

- go get ./... (install all dependencies)


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

- The cmd/ directory contains the main applications for the project. Each subdirectory under cmd/ represents a separate application.

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

In this structure, the cmd/ directory holds the main application executable, which in this case would be the server. The internal/ directory contains the internal packages used by the application, including config/, handlers/, middleware/, models/, and routes/. The pkg/ directory is used to store reusable packages that can be used by other Go projects. The vendor/ directory holds the external dependencies of the project.

This structure follows the standard layout recommended by the Go community and makes it easier to organize the code in a modular and scalable way. However, this is just a recommendation and you are free to organize your code in a way that works best for you and your project.

**Testing**

- "github.com/stretchr/testify/assert"

**Object-Relational Mapping (ORM)**

-  go get -u gorm.io/gorm 

**Build project**

- go build -o main ./cmd/server
