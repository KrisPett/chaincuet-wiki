### .NET Framework

The original .NET implementation designed for building Windows-based applications. It includes support for technologies
like Windows Forms, WPF, and ASP.NET Web Forms but is limited to Windows. Now in maintenance mode, it is best suited for
**legacy projects.**

### .NET Core

A modern, cross-platform, open-source framework optimized for high performance and modularity. It supports Windows,
macOS, and Linux, enabling developers to build applications for diverse platforms. It has been **unified into .NET 5 and
later.**

### .NET Standard

A specification defining a common set of APIs that all .NET implementations must support. It enables compatibility and
code-sharing across different .NET versions, including .NET Framework and .NET Core. **It has been largely replaced by
.NET 5+.**

### ASP.NET

A framework within the .NET ecosystem for building dynamic web applications, APIs, and services. It evolved into ASP.NET
Core, which offers cross-platform capabilities, better performance, and support for modern web development practices.
**ASP.NET Core is equivalent to Spring Boot**

### Csharp

A modern, versatile, and object-oriented programming language used to build applications within the .NET ecosystem.
Known for its simplicity and robust features, it is widely adopted for backend development, game development (Unity),
and cloud applications.

### Clean Architecture

1. **Entities** (Core Business Logic):
    - Represent the core domain models and enterprise-wide business rules.
    - Independent of frameworks and external dependencies, ensuring reusability and long-term stability.

2. **Use Cases** (Application-Specific Logic):
    - Handle specific business workflows and orchestrate interactions between entities and other layers.
    - Ensure that each use case solves a defined problem for the application.

3. **Interface Adapters** (Controllers, Presenters, Gateways):
    - Convert data between the format required by use cases and the external systems like UI, databases, or APIs.
    - Act as a mediator between the inner layers and outer layers.

4. **Frameworks & Drivers** (External Systems):
    - The outermost layer that includes frameworks, databases, web servers, or APIs.
    - Implements low-level details that can be swapped without impacting the core logic.

```
[ Frameworks & Drivers ]  --> Frameworks, tools, and external dependencies.
[  Interface Adapters  ]  --> Data translation between core and external systems.
[      Use Cases       ]  --> Application-specific workflows and logic.
[       Entities       ]  --> Core domain models and business rules.


Solution/
├── Core/                      # Core Layer (Domain and Application Logic)
│   ├── Domain/                # Domain Entities and Business Rules
│   │   ├── Entities/
│   │   │   ├── Product.cs
│   │   │   ├── Customer.cs
│   │   ├── ValueObjects/
│   │   │   ├── Money.cs
│   │   │   ├── Address.cs
│   │   ├── DomainEvents/
│   │   │   ├── OrderCreatedEvent.cs
│   │   └── Core.Domain.csproj
│   ├── Application/           # Use Cases and Application Logic
│   │   ├── Interfaces/
│   │   │   ├── IProductRepository.cs
│   │   │   ├── ICustomerService.cs
│   │   ├── Features/
│   │   │   ├── Orders/
│   │   │   │   ├── CreateOrderCommand.cs
│   │   │   │   ├── CreateOrderHandler.cs
│   │   │   ├── Products/
│   │   │       ├── GetProductsQuery.cs
│   │   │       ├── GetProductsHandler.cs
│   │   ├── Common/
│   │   │   ├── Result.cs
│   │   │   ├── ValidationBehavior.cs
│   │   └── Core.Application.csproj
├── Infrastructure/            # Infrastructure Layer (External Dependencies)
│   ├── Persistence/           # Database Context and Implementations
│   │   ├── AppDbContext.cs
│   │   ├── Repositories/
│   │   │   ├── ProductRepository.cs
│   │   │   ├── CustomerRepository.cs
│   ├── ExternalServices/      # External APIs and Service Implementations
│   │   ├── PaymentGateway.cs
│   ├── Configurations/        # Dependency Injection and Configuration
│   │   ├── DependencyInjection.cs
│   └── Infrastructure.csproj
├── API/                       # Presentation Layer (Web API)
│   ├── Controllers/           # API Controllers
│   │   ├── ProductController.cs
│   │   ├── OrderController.cs
│   ├── Models/                # API Request and Response Models
│   │   ├── ProductDto.cs
│   │   ├── CreateOrderDto.cs
│   ├── Filters/               # Exception Handling and Middleware
│   │   ├── ValidationFilter.cs
│   │   ├── ExceptionFilter.cs
│   ├── Program.cs             # Application Entry Point
│   ├── Startup.cs             # Middleware and Dependency Injection
│   └── API.csproj
├── Tests/                     # Test Projects
│   ├── Core.Domain.Tests/
│   │   ├── Entities/
│   │   │   ├── ProductTests.cs
│   │   └── Core.Domain.Tests.csproj
│   ├── Core.Application.Tests/
│   │   ├── Features/
│   │   │   ├── CreateOrderHandlerTests.cs
│   │   └── Core.Application.Tests.csproj
│   ├── Infrastructure.Tests/
│   │   ├── ProductRepositoryTests.cs
│   │   └── Infrastructure.Tests.csproj
│   ├── API.Tests/
│   │   ├── ProductControllerTests.cs
│   │   └── API.Tests.csproj
├── README.md
└── Solution.sln
```

### Visual Studio

#### ASP.NET Core Web API

- **What it is**: This is the most common choice for building RESTful APIs. It provides a minimal setup with support for
  routing, controllers, and dependency injection. This would be ideal for building a service similar to a Spring Boot
  application focused on web API endpoints (e.g., CRUD operations, authentication, etc.).
- **Should you choose it?**: Yes, if you want to create a backend API application similar to a Spring Boot application.

#### ASP.NET Core Web API (native AOT)

- **What it is**: This option enables Native Ahead-of-Time (AOT) compilation, which means your application is compiled
  ahead of time into native code for improved startup time and reduced memory usage. This is useful for scenarios where
  performance optimization is critical, but it may limit some runtime flexibility.
- **Should you choose it?**: Choose this option only if you're focused on performance and need the benefits of AOT
  compilation. For most applications, the regular **ASP.NET Core Web API** will be sufficient.

#### ASP.NET Core gRPC Service

- **What it is**: gRPC is a high-performance, language-agnostic remote procedure call (RPC) framework. It’s used for
  efficient communication between services (especially microservices) and uses Protocol Buffers (protobufs) for data
  serialization.
- **Should you choose it?**: Choose this option if you want to build high-performance microservices with gRPC for
  communication between services, rather than a typical REST API.

#### ASP.NET Core Web App (Razor Pages)

- **What it is**: Razor Pages is a web application model that allows for a more traditional server-side rendered
  approach to building web applications with HTML. It’s typically used for applications that need server-side rendering
  of HTML pages, like a full MVC web app.
- **Should you choose it?**: Choose this option if you're building a web application with full HTML rendering on the
  server, similar to a traditional web app with views and controllers. It's not typically used for APIs but for creating
  more interactive web UIs.

#### ASP.NET Core Web App (Model-View-Controller)

- **What it is**: This is the MVC (Model-View-Controller) pattern for building web applications. It’s useful if you're
  building a web application with dynamic views rendered on the server, and you need a structured way to separate your
  data (model), logic (controller), and views.
- **Should you choose it?**: Choose this option if you're building a web app with both frontend and backend logic,
  similar to a Spring MVC application. This is typically used for building applications that involve user interfaces
  with HTML and JavaScript.

#### ASP.NET Core Empty

- **What it is**: This is a minimal setup with no predefined files or templates. It's essentially an empty project that
  you can customize however you need, giving you full control over how to structure your application from the ground up.
- **Should you choose it?**: Choose this option if you want complete control over the application structure and need to
  implement a custom design. If you’re planning on using Clean Architecture and want to build the project from scratch
  with explicit separation of concerns, this is a good choice. You would need to manually set up routes, services,
  controllers, and dependencies.

#### Which to Choose for a Spring Boot-Like Application?

- **ASP.NET Core Web API**: This is the best choice for building a REST API similar to a Spring Boot application. It
  provides a minimal, clean setup with built-in support for controllers, dependency injection, and routing, which is
  what you'd need for a typical API-driven application.

#### Which to Choose for Clean Architecture Design?

- **ASP.NET Core Empty**: If you want to implement **Clean Architecture**, the **Empty** template is the best choice.
  This gives you a blank slate where you can structure your solution with layers (e.g., Core, Application,
  Infrastructure, and API layers). You can then organize your project to follow the principles of Clean Architecture,
  ensuring clear separation between different concerns (e.g., UI, business logic, data access).

    - **Core**: Contains entities and interfaces (the core of your application logic).
    - **Application**: Contains use cases and services for interacting with the domain model.
    - **Infrastructure**: Handles data access, third-party services, etc.
    - **API**: Contains API controllers that interact with the Application layer.

By starting with **ASP.NET Core Empty**, you can create a project that follows Clean Architecture best practices and
allows for easy scaling and testing.

---

#### Summary of Recommendations:

- **For a simple Spring Boot-like application (API)**: Choose **ASP.NET Core Web API**.
- **For Clean Architecture**: Choose **ASP.NET Core Empty**, and structure the project with clear separation of concerns
  and layers.

#### Useful Commands

```
add-migration
update-database
```

```
Install-Package Npgsql.EntityFrameworkCore.PostgreSQL
Install-Package Microsoft.EntityFrameworkCore.Design
```