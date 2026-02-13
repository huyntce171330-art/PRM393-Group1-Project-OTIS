# PRM393 OTIS Project

This is the frontend application for the OTIS Project, a mobile application built with Flutter. It follows **Clean Architecture** principles and uses **BLoC** (Business Logic Component) for state management.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.x or higher)
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository_url>
   ```

2. **Navigate to the app directory**:
   ```bash
   cd app
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## 🏗 Project Architecture

The project is structured using **Clean Architecture**, separating the code into three main layers: **Data**, **Domain**, and **Presentation**. This ensures scalability, testability, and maintainability.

### 1. Domain Layer (`lib/domain`)
*The "Inner Layer" - Independent of frameworks and external data sources.*
- **Entities**: Core business objects (e.g., `User`, `Product`, `Order`).
- **Repositories (Interfaces)**: Abstract definitions of how data should be handled.
- **UseCases**: Encapsulate specific business rules and logic (e.g., `LoginUseCase`, `GetProductsUseCase`).

### 2. Data Layer (`lib/data`)
*The "Outer Layer" - Handles data retrieval and storage.*
- **Models**: Data Transfer Objects (DTOs) that extend Entities plus JSON/DB mapping methods.
- **DataSources**:
    - **Remote**: API calls (via `http` or `dio`).
    - **Local**: Database interactions (SQLite/Sqflite).
- **Repositories (Implementation)**: Concrete implementations of the Domain Repositories.

### 3. Presentation Layer (`lib/presentation`)
*The "UI Layer" - Handles User Interface and State Management.*
- **BLoC**: Manages state using Events and States.
- **Screens**: Full-page widgets (pages).
- **Widgets**: Reusable UI components.

### 4. Core (`lib/core`)
- Contains common utilities, constants, error handling, and dependency injection setups (`get_it`).

## 📂 Folder Structure

Below is the project structure overview:

```text
lib/
├───core/                   # Core utilities (Constants, Error, DI, Network)
│   ├───constants/
│   ├───error/
│   ├───injections/
│   ├───network/
│   ├───theme/
│   └───utils/
│
├───data/                   # Data Layer
│   ├───datasources/        # Remote & Local data sources
│   ├───models/             # Data models (JSON/DB serialization)
│   └───repositories/       # Repository Implementations
│
├───domain/                 # Domain Layer
│   ├───entities/           # Business Objects
│   ├───repositories/       # Repository Interfaces
│   └───usecases/           # Business Logic (Interactors)
│
└───presentation/           # Presentation Layer
    ├───bloc/               # State Management (BLoC)
    ├───screens/            # UI Screens
    └───widgets/            # Reusable Widgets
```

### Detailed Feature Structure

```text
D:.
│   app.dart
│   main.dart
│   
├───core
│   ├───constants
│   │       api_constants.dart
│   │       app_colors.dart
│   ├───error
│   │       failures.dart
│   ├───injections
│   │       database_helper.dart
│   │       injection_container.dart
│   ├───network
│   │       api_client.dart
│   │       network_info.dart
│   ├───theme
│   │       app_theme.dart
│   └───utils
│
├───data
│   ├───datasources
│   │   ├───auth/
│   │   ├───cart/
│   │   ├───category/
│   │   ├───chat/
│   │   ├───map/
│   │   ├───notification/
│   │   ├───order/
│   │   ├───payment/
│   │   ├───product/
│   │   └───profile/
│   ├───models/
│   └───repositories/
│
├───domain
│   ├───entities/
│   ├───repositories/
│   └───usecases
│       ├───auth/
│       ├───cart/
│       ├───category/
│       ├───chat/
│       ├───map/
│       ├───notification/
│       ├───order/
│       ├───payment/
│       ├───product/
│       └───profile/
│
└───presentation
    ├───bloc
    │   ├───auth/
    │   ├───cart/
    │   ├───category/
    │   ├───chat/
    │   ├───map/
    │   ├───notification/
    │   ├───order/
    │   ├───payment/
    │   ├───product/
    │   └───profile/
    ├───screens
    │   ├───auth/
    │   ├───cart/
    │   ├───category/
    │   ├───chat/
    │   ├───map/
    │   ├───notification/
    │   ├───order/
    │   ├───payment/
    │   ├───product/
    │   └───profile/
    └───widgets/
```

## 🛠 Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Local Database**: sqlite
- **Networking**: dio
- **Value Equality**: equatable

---
**Developed by PRM393 Group 1**