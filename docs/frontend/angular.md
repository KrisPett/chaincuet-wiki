### vs code

- Prettier - Code formatter
- Angular Language Service

### Angular CLI

#### Install Angular CLI

```
npm install -g @angular/cli
ng new <project-name>
```

#### Start server

```
ng serve
ng serve --port 4201 --open
```

#### Generate component

```
ng generate component components/header
```


#### Generate interface

```
ng generate interface housinglocation
```

#### Generate service

```
ng generate service services/housing
```

##### Example folder structure

```
chaincue-real-estate-angular
│   .env                    # Environment variables
│   .eslintrc.json          # ESLint configuration
│   .gitignore              # Git ignore file
│   docker-compose-prod.yml # Docker production configuration
│   docker-compose.yml      # Docker development configuration
│   Dockerfile              # Dockerfile for containerization
│   angular.json            # Angular CLI configuration
│   package-lock.json       # npm lock file
│   package.json            # npm configuration
│   tailwind.config.ts      # Tailwind CSS configuration
│   tsconfig.json           # TypeScript configuration
│   README.md               # Project documentation
│
├───.github
│   └───workflows
│           docker-image.yml # CI/CD workflow
│
├───public                   # Public assets folder
│       next.svg
│       vercel.svg
│
├───src                     # Source files
│   ├───app                 # Core Angular app folder
│   │   ├───core            # Core module for singletons, guards, interceptors
│   │   │   ├── interceptors/
│   │   │   │       auth.interceptor.ts
│   │   │   ├── guards/
│   │   │   │       auth.guard.ts
│   │   │   ├── services/
│   │   │   │       auth.service.ts
│   │   │   │       account.service.ts
│   │   │   │       property.service.ts
│   │   │   └── core.module.ts
│   │   │
│   │   ├───shared # Shared module for reusable components, directives, pipes
│   │   │   ├── components/
│   │   │   │       loading-spinner/
│   │   │   │           loading-spinner.component.ts
│   │   │   │           loading-spinner.component.html
│   │   │   │           loading-spinner.component.scss
│   │   │   ├── directives/
│   │   │   │       highlight.directive.ts
│   │   │   ├── pipes/
│   │   │   │       format-date.pipe.ts
│   │   │   └── shared.module.ts
│   │   │
│   │   ├───features # Feature-specific modules
│   │   │   ├── account/
│   │   │   │   ├── components/
│   │   │   │   │       account-details/
│   │   │   │   │           account-details.component.ts
│   │   │   │   │           account-details.component.html
│   │   │   │   │           account-details.component.scss
│   │   │   │   ├── services/
│   │   │   │   │       account-page-api.service.ts
│   │   │   │   │       account-page-dto.ts
│   │   │   │   ├── models/
│   │   │   │   │       account.model.ts
│   │   │   │   ├── account.component.ts
│   │   │   │   ├── account.module.ts
│   │   │   │   └── account-routing.module.ts
│   │   │   │
│   │   │   ├── add-property/
│   │   │   │   ├── components/
│   │   │   │   │       mint-modal/
│   │   │   │   │           mint-modal.component.ts
│   │   │   │   │           mint-modal.component.html
│   │   │   │   │           mint-modal.component.scss
│   │   │   │   ├── services/
│   │   │   │   │       add-property-api.service.ts
│   │   │   │   │       add-property-dto.ts
│   │   │   │   ├── models/
│   │   │   │   │       property.model.ts
│   │   │   │   ├── add-property.component.ts
│   │   │   │   ├── add-property.module.ts
│   │   │   │   └── add-property-routing.module.ts
│   │   │   │
│   │   │   ├── home/
│   │   │   │   ├── components/
│   │   │   │   │       banner/
│   │   │   │   │           banner.component.ts
│   │   │   │   │           banner.component.html
│   │   │   │   │           banner.component.scss
│   │   │   │   ├── services/
│   │   │   │   │       home-api.service.ts
│   │   │   │   │       home-dto.ts
│   │   │   │   ├── models/
│   │   │   │   │       home.model.ts
│   │   │   │   ├── home.component.ts
│   │   │   │   ├── home.module.ts
│   │   │   │   └── home-routing.module.ts
│   │   │   │
│   │   │   ├── house/
│   │   │   │   ├── components/
│   │   │   │   │       image-modal/
│   │   │   │   │           image-modal.component.ts
│   │   │   │   │           image-modal.component.html
│   │   │   │   │           image-modal.component.scss
│   │   │   │   ├── services/
│   │   │   │   │       house-api.service.ts
│   │   │   │   │       house-dto.ts
│   │   │   │   ├── models/
│   │   │   │   │       house.model.ts
│   │   │   │   ├── house.component.ts
│   │   │   │   ├── house.module.ts
│   │   │   │   └── house-routing.module.ts
│   │   │   │
│   │   │   ├── houses/
│   │   │   │   ├── components/
│   │   │   │   │       house-item/
│   │   │   │   │           house-item.component.ts
│   │   │   │   │           house-item.component.html
│   │   │   │   │           house-item.component.scss
│   │   │   │   ├── services/
│   │   │   │   │       houses-api.service.ts
│   │   │   │   │       houses-dto.ts
│   │   │   │   ├── models/
│   │   │   │   │       houses.model.ts
│   │   │   │   ├── houses.component.ts
│   │   │   │   ├── houses.module.ts
│   │   │   │   └── houses-routing.module.ts
│   │   │
│   │   ├── app.component.html  # Root app component HTML
│   │   ├── app.component.scss  # Root app component styles
│   │   ├── app.component.ts    # Root app component logic
│   │   ├── app.module.ts       # Root app module
│   │   └── app-routing.module.ts # App-wide routing module
│   │
│   ├───assets                  # Static assets
│   │   ├── icons/              # Icons
│   │   └── images/             # Images
│   │
│   ├───environments            # Environment-specific configurations
│   │       environment.ts      # Development environment
│   │       environment.prod.ts # Production environment
│   │
│   ├───layouts                 # Layouts for the app
│   │       header.component.ts
│   │       footer.component.ts
│   │       layout.component.ts
│   │
│   ├───styles                  # Global styles
│   │       globals.scss        # Global SCSS styles
│   │       variables.scss      # SCSS variables
│   │       mixins.scss         # SCSS mixins
│   │
│   ├───utilities               # Utility classes and helpers
│   │       jwt-utilities.ts
│   │       search-area.ts
│   │       web3-modal.ts
│   │
│   └───types                   # Type definitions
│           environment.d.ts
│           auth.d.ts
│           window.d.ts
│
└───tests                       # Unit and integration tests
    ├───unit/
    └───integration/

```