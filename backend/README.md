
This document explains the backend architecture of the PRM393 Otis Project. The project follows the **Clean Architecture** (also known as Hexagonal Architecture) principles to ensure separation of concerns, maintainability, and testability.

## 1. Project Structure Overview

The project is organized efficiently to separate business logic from implementation details.

```
.
├── cmd/                # Entry points of the application
│   └── server/         # Main server application (main.go)
├── config/             # Configuration handling (env vars, config structs)
├── domain/             # Core business logic (Entities & Interfaces) - NO internal dependencies
├── internal/           # Private application code (not importable by others)
│   ├── delivery/       # Interface adapters (HTTP Handlers)
│   │   └── http/       # Gin handlers, routers, middleware
│   ├── usecase/        # Application business rules
│   ├── repository/     # Data access interfaces implementations
│   └── infrastructure/ # External tools (Database connection, third-party APIs)
└── migrations/         # Database migration files
```

## 2. Architectural Layers

### Domain Layer (`/domain`)
*   **What it is:** The heart of the application.
*   **Contains:**
    *   **Entities:** Structs representing database tables (e.g., `Product`, `User`).
    *   **Interfaces:** Definitions for Repositories and Usecases. This allows `usecase` to depend on `repository` interfaces without knowing the implementation (Dependency Inversion).
*   **Dependencies:** None. This layer should not import other internal packages (except standard libs).

### Repository Layer (`/internal/repository`)
*   **What it is:** The data access layer.
*   **Responsibilities:** Implementing the repository interfaces defined in `domain`.
*   **Technology:** Uses GORM to interact with PostgreSQL.
*   **Dependencies:** Imports `domain` and database drivers.

### Usecase Layer (`/internal/usecase`)
*   **What it is:** The business logic layer.
*   **Responsibilities:** Orchestrating the flow of data. It calls repositories to get data, processes it, and returns it.
*   **Dependencies:** Imports `domain`. It does *not* know about HTTP or JSON.

### Delivery Layer (`/internal/delivery/http`)
*   **What it is:** The transport layer (REST API).
*   **Responsibilities:**
    *   Parsing HTTP requests (JSON binding).
    *   Calling Usecases.
    *   Formatting HTTP responses.
*   **Technology:** Uses Gin framework.

### Infrastructure (`/internal/infrastructure`)
*   **What it is:** Technical details.
*   **Responsibilities:** Initializing database connections (Postgres), Redis, external clients, etc.

## 3. Data Flow

A typical request follows this path:

1.  **Request**: Client sends `GET /products`.
2.  **Delivery (Handler)**: `ProductHandler` receives the request.
3.  **Usecase**: Handler calls `ProductUsecase.Fetch()`.
4.  **Repository**: Usecase calls `ProductRepository.Fetch()`.
5.  **Database**: Repository queries the PostgreSQL database.
6.  **Response**: Data returns up the chain to the client.

## 4. How to Add a New Feature

To add a new feature (e.g., "Orders"), follow these steps in order:

1.  **Domain**:
    *   Create `domain/order.go`.
    *   Define the `Order` struct.
    *   Define `OrderRepository` and `OrderUsecase` interfaces.

2.  **Repository**:
    *   Create `internal/repository/postgres/order_repo.go`.
    *   Implement the `OrderRepository` interface methods.

3.  **Usecase**:
    *   Create `internal/usecase/order/order_usecase.go`.
    *   Implement the `OrderUsecase` interface methods (business logic).

4.  **Delivery**:
    *   Create `internal/delivery/http/handler/order_handler.go` (Note the `handler` subdirectory).
    *   Create struct `OrderHandler` with `domain.OrderUsecase`.
    *   Implement `NewOrderHandler` returning `*OrderHandler` (Do NOT register routes here).
    *   Implement Gin handler functions (Create, Get, etc.).
    *   Update `internal/delivery/http/router.go`:
        *   Add `OrderHandler` to `NewRouter` arguments.
        *   Register routes: `r.Group("/orders")`.

5.  **Wiring (Dependency Injection)**:
    *   Go to `cmd/server/main.go`.
    *   Initialize Repository: `orderRepo := postgres.NewOrderRepository(db)`
    *   Initialize Usecase: `orderUC := usecase.NewOrderUsecase(orderRepo)`
    *   Initialize Handler: `orderHandler := handler.NewOrderHandler(orderUC)`
    *   Register Routes: `http.NewRouter(r, orderHandler)`

## 5. Running the Project

### Prerequisites
*   Go 1.22+
*   PostgreSQL
*   Docker (Optional)

### Setup
1.  Copy `.env.example` to `.env` (if available) or create one.
2.  Configuration typically resides in `config/config.yaml`.

### Run Locally
```bash
go run cmd/server/main.go
```

### Run with Docker
```bash
docker-compose up --build
```
