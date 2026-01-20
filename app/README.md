# frontend_otis

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
(base) PS D:\04_Semester_08\01_PRM393\03_Projects\PRM393-OTIS-Project\app\lib> tree /F                                                                            
Folder PATH listing for volume New Volume
Volume serial number is 40CF-2A5D
D:.
│   app.dart
│   main.dart
│   
├───core
│   ├───constants
│   │       api_constants.dart
│   │       app_colors.dart
│   │       
│   ├───error
│   │       failures.dart
│   │
│   ├───injections
│   │       injection_container.dart
│   │
│   ├───network
│   │       api_client.dart
│   │       network_info.dart
│   │
│   ├───theme
│   │       app_theme.dart
│   │
│   └───utils
├───data
│   ├───datasources
│   │   ├───auth
│   │   │       auth_remote_datasource.dart
│   │   │       auth_remote_datasource_impl.dart
│   │   │
│   │   ├───cart
│   │   │       cart_remote_datasource.dart
│   │   │       cart_remote_datasource_impl.dart
│   │   │
│   │   ├───category
│   │   │       category_remote_datasource.dart
│   │   │       category_remote_datasource_impl.dart
│   │   │
│   │   ├───chat
│   │   │       chat_remote_datasource.dart
│   │   │       chat_remote_datasource_impl.dart
│   │   │
│   │   ├───map
│   │   │       location_service.dart
│   │   │       map_remote_datasource.dart
│   │   │       map_remote_datasource_impl.dart
│   │   │
│   │   ├───notification
│   │   │       notification_remote_datasource.dart
│   │   │       notification_remote_datasource_impl.dart
│   │   │       push_notification_service.dart
│   │   │
│   │   ├───order
│   │   │       order_remote_datasource.dart
│   │   │       order_remote_datasource_impl.dart
│   │   │
│   │   ├───payment
│   │   │       payment_remote_datasource.dart
│   │   │       payment_remote_datasource_impl.dart
│   │   │
│   │   ├───product
│   │   │       product_remote_datasource.dart
│   │   │       product_remote_datasource_impl.dart
│   │   │
│   │   └───profile
│   │           profile_remote_datasource.dart
│   │           profile_remote_datasource_impl.dart
│   │
│   ├───models
│   │       cart_item_model.dart
│   │       cart_model.dart
│   │       category_model.dart
│   │       message_model.dart
│   │       notification_model.dart
│   │       order_model.dart
│   │       product_model.dart
│   │       store_model.dart
│   │       user_model.dart
│   │
│   └───repositories
│           auth_repository_impl.dart
│           cart_repository_impl.dart
│           category_repository_impl.dart
│           chat_repository_impl.dart
│           map_repository_impl.dart
│           notification_repository_impl.dart
│           order_repository_impl.dart
│           payment_repository_impl.dart
│           product_repository_impl.dart
│           profile_repository_impl.dart
│
├───domain
│   ├───entities
│   │       app_location.dart
│   │       cart.dart
│   │       cart_item.dart
│   │       category.dart
│   │       message.dart
│   │       notification.dart
│   │       notification_filter.dart
│   │       order.dart
│   │       order_item.dart
│   │       product.dart
│   │       product_filter.dart
│   │       store.dart
│   │       user.dart
│   │
│   ├───repositories
│   │       auth_repository.dart
│   │       cart_repository.dart
│   │       category_repository.dart
│   │       chat_repository.dart
│   │       map_repository.dart
│   │       notification_repository.dart
│   │       order_repository.dart
│   │       payment_repository.dart
│   │       product_repository.dart
│   │       profile_repository.dart
│   │
│   └───usecases
│       ├───auth
│       │       login_usecase.dart
│       │       logout_usecase.dart
│       │       register_usecase.dart
│       │
│       ├───cart
│       │       add_product_to_cart_usecase.dart
│       │       get_cart_usecase.dart
│       │       update_cart_usecase.dart
│       │
│       ├───category
│       │       assign_category_to_product_usecase.dart
│       │       create_category_usecase.dart
│       │       delete_category_usecase.dart
│       │       get_categories_usecase.dart
│       │       get_category_detail_usecase.dart
│       │       update_category_usecase.dart
│       │
│       ├───chat
│       │       get_messages_usecase.dart
│       │       receive_message_stream_usecase.dart
│       │       send_message_usecase.dart
│       │
│       ├───map
│       │       get_current_location_usecase.dart
│       │       get_direction_usecase.dart
│       │       get_store_locations_usecase.dart
│       │
│       ├───notification
│       │       create_notification_usecase.dart
│       │       delete_notification_usecase.dart
│       │       get_notifications_usecase.dart
│       │       get_notification_detail_usecase.dart
│       │       search_notifications_usecase.dart
│       │       update_notification_status_usecase.dart
│       │
│       ├───order
│       │       create_order_usecase.dart
│       │       get_orders_usecase.dart
│       │       get_order_detail_usecase.dart
│       │
│       ├───payment
│       │       process_payment_usecase.dart
│       │
│       ├───product
│       │       create_product_usecase.dart
│       │       delete_product_usecase.dart
│       │       get_products_usecase.dart
│       │       get_product_detail_usecase.dart
│       │       search_products_usecase.dart
│       │       sort_product_usecase.dart
│       │       update_product_usecase.dart
│       │
│       └───profile
│               get_profile_usecase.dart
│               update_profile_usecase.dart
│
└───presentation
    ├───bloc
    │   ├───auth
    │   │       auth_bloc.dart
    │   │       auth_event.dart
    │   │       auth_state.dart
    │   │
    │   ├───cart
    │   │       cart_bloc.dart
    │   │       cart_event.dart
    │   │       cart_state.dart
    │   │
    │   ├───category
    │   │       category_bloc.dart
    │   │       category_event.dart
    │   │       category_state.dart
    │   │
    │   ├───chat
    │   │       chat_bloc.dart
    │   │       chat_event.dart
    │   │       chat_state.dart
    │   │
    │   ├───map
    │   │       map_bloc.dart
    │   │       map_event.dart
    │   │       map_state.dart
    │   │
    │   ├───notification
    │   │       notification_bloc.dart
    │   │       notification_event.dart
    │   │       notification_state.dart
    │   │
    │   ├───order
    │   │       order_bloc.dart
    │   │       order_event.dart
    │   │       order_state.dart
    │   │
    │   ├───payment
    │   │       payment_bloc.dart
    │   │       payment_event.dart
    │   │       payment_state.dart
    │   │
    │   ├───product
    │   │       product_bloc.dart
    │   │       product_event.dart
    │   │       product_state.dart
    │   │
    │   └───profile
    │           profile_bloc.dart
    │           profile_event.dart
    │           profile_state.dart
    │
    ├───screens
    │   │   home_screen.dart
    │   │
    │   ├───auth
    │   │       login_screen.dart
    │   │       register_screen.dart
    │   │
    │   ├───cart
    │   │       cart_screen.dart
    │   │
    │   ├───category
    │   │       category_create_screen.dart
    │   │       category_list_screen.dart
    │   │       category_update_screen.dart
    │   │
    │   ├───chat
    │   │       chat_screen.dart
    │   │
    │   ├───map
    │   │       map_screen.dart
    │   │
    │   ├───notification
    │   │       notification_create_screen.dart
    │   │       notification_detail_screen.dart
    │   │       notification_list_screen.dart
    │   │
    │   ├───order
    │   │       order_detail_screen.dart
    │   │       order_list_screen.dart
    │   │
    │   ├───payment
    │   │       payment_screen.dart
    │   │
    │   ├───product
    │   │       product_create_screen.dart
    │   │       product_detail_screen.dart
    │   │       product_list_screen.dart
    │   │       product_update_screen.dart
    │   │
    │   └───profile
    │           profile_screen.dart
    │           profile_update_screen.dart
    │
    └───widgets
        │   custom_button.dart
        │   filter_bottom_sheet.dart
        │   loading_widget.dart
        │   nav_bar.dart
        │   search_bar.dart
        │
        ├───cart
        │       cart_item_card.dart
        │
        ├───category
        │       category_card.dart
        │       category_dropdown.dart
        │
        ├───chat
        │       message_bubble.dart
        │
        ├───map
        │       map_view.dart
        │
        ├───notification
        │       notification_card.dart
        │
        ├───order
        │       order_card.dart
        │       status_badge.dart
        │
        └───product
                price_text.dart
                product_card.dart
                product_image.dart

(base) PS D:\04_Semester_08\01_PRM393\03_Projects\PRM393-OTIS-Project\app\lib>
```

# PRM393 OTIS Project - Architecture & Contribution Guide

Welcome to the OTIS Project codebase. This project adheres to **Clean Architecture** combined with the **BLoC (Business Logic Component)** pattern to ensure scalability, maintainability, and testability.

This document serves as a guideline for the team to understand the structure, where to find things, and how to add new features consistently.

## 🏗 Architecture Overview

We follow the **Separation of Concerns** principle by dividing the project into three main layers:

1.  **Domain Layer (Business Logic)**: The "Brain" of the app. It defines *what* the app does. It contains pure Dart code with no dependencies on Flutter or external libraries (mostly).
2.  **Data Layer (Data Handling)**: The "Limbs" of the app. It handles *how* data is retrieved (API, Database) and converts it for the Domain layer.
3.  **Presentation Layer (UI)**: The "Face" of the app. It displays data to the user and captures events using BLoC.

---

## 📂 Project Structure Explained

The `lib/` folder is organized as follows:

### 1. `core/` (Shared Infrastructure)
Contains utilities and configurations used across the entire application.
*   **`constants/`**:
    *   `api_constants.dart`: Stores API endpoints (`baseUrl`, `loginUrl`, etc.).
    *   `app_colors.dart`: Defines the color palette (primary, secondary, error colors).
*   **`error/`**:
    *   `failures.dart`: Defines custom error types (e.g., `ServerFailure`, `NetworkFailure`) used by `dartz` types.
*   **`injections/`**:
    *   `injection_container.dart`: The **Dependency Injection (DI)** setup using `GetIt`. This is where we register our BLoCs, Repositories, and UseCases so they can be injected where needed.
*   **`network/`**:
    *   `api_client.dart`: A wrapper around `Dio` or `http` to handle raw HTTP requests, headers, and interceptors.
    *   `network_info.dart`: Logic to check internet connectivity.
*   **`theme/`**:
    *   `app_theme.dart`: Centralized `ThemeData` configuration (fonts, sizes, input styles).

### 2. `domain/` (The Contract)
This layer defines the rules. It does not know about JSON, APIs, or Flutter Widgets.
*   **`entities/`** (The Objects):
    *   *Examples*: `user.dart`, `product.dart`, `order.dart`.
    *   **Purpose**: Lightweight Dart objects containing only data fields needed by the app logic. They extend `Equatable` for value comparison.
*   **`repositories/`** (The Interfaces):
    *   *Examples*: `auth_repository.dart`, `product_repository.dart`.
    *   **Purpose**: Abstract classes defining *what* operations are possible (e.g., `getOrders()`, `login()`). They return `Future<Either<Failure, Type>>`.
*   **`usecases/`** (The Actions):
    *   *Examples*: `login_usecase.dart`, `get_products_usecase.dart`.
    *   **Purpose**: Single-responsibility classes. Each class does ONE thing. They allow us to execute a specific business action by calling the Repository.

### 3. `data/` (The Implementation)
This layer acts as the bridge between the Domain and the outside world.
*   **`models/`** (The Parsers):
    *   *Examples*: `user_model.dart`, `order_model.dart`.
    *   **Purpose**: Subclasses of Entities that add JSON parsing logic (`fromJson`, `toJson`). The Domain layer uses Entities; the Data layer uses Models.
*   **`datasources/`** (The Fetchers):
    *   *Examples*: `auth_remote_datasource.dart`, `product_remote_datasource.dart`.
    *   **Purpose**: Classes that actually call the API endpoints using `ApiClient`. They throw Exceptions (not Failures) if something goes wrong.
*   **`repositories/`** (The Connectors):
    *   *Examples*: `auth_repository_impl.dart`, `order_repository_impl.dart`.
    *   **Purpose**: Implementation of the Domain Repositories. They call specific Datasources, catch Exceptions, and map them to Failures (Clean Architecture Result types).

### 4. `presentation/` (The View)
*   **`bloc/`** (State Management):
    *   Each feature has a BLoC (e.g., `auth`, `order`, `product`).
    *   **`_event.dart`**: Actions triggered by the user (e.g., `LoginButtonPressed`).
    *   **`_state.dart`**: Status of the UI (e.g., `AuthLoading`, `AuthSuccess`, `AuthFailure`).
    *   **`_bloc.dart`**: Logic that receives Events, calls UseCases, and emits States.
*   **`screens/`** (Components):
    *   Full-page widgets corresponding to features (e.g., `login_screen.dart`, `order_list_screen.dart`).
*   **`widgets/`** (Reusables):
    *   Small, reusable UI parts (e.g., `custom_button.dart`, `order_card.dart`).

---

## 🚀 Workflow: How to Add a New Feature

Follow this step-by-step flow to maintain consistency:

### Step 1: **Domain Layer**
1.  **Entity**: Create `domain/entities/my_feature.dart`. Define the fields.
2.  **Repository Interface**: Create `domain/repositories/my_feature_repository.dart`. Define abstract methods.
3.  **Use Cases**: Create `domain/usecases/my_feature/do_something_usecase.dart`. Create a class that calls the repository method.

### Step 2: **Data Layer**
4.  **Model**: Create `data/models/my_feature_model.dart`. Extend the Entity and add `fromJson`/`toMap`.
5.  **DataSource**:
    *   Create interface `data/datasources/my_feature/my_feature_remote_datasource.dart`.
    *   Create impl `my_feature_remote_datasource_impl.dart`. Write the API call here.
6.  **Repository Implementation**: Create `data/repositories/my_feature_repository_impl.dart`. Implement the Domain Interface. Call the Datasource here and handle errors.

### Step 3: **Injection**
7.  **DI**: Go to `core/injections/injection_container.dart`. Register:
    *   Datasource (`sl.registerLazySingleton`)
    *   Repository (`sl.registerLazySingleton`)
    *   UseCases (`sl.registerLazySingleton`)
    *   BLoC (`sl.registerFactory`)

### Step 4: **Presentation Layer**
8.  **BLoC**:
    *   Define `events` (Input).
    *   Define `states` (Output).
    *   Implement `bloc` logic (Map Event -> UseCase -> State).
9.  **UI**:
    *   Create `screen` using `BlocProvider` and `BlocBuilder`.
    *   Trigger events on user interaction.
    *   Render different UI based on state (Loading, Success, Error).

---

## 📋 File Guide (Line-by-Line logic)

### `main.dart`
*   **Line 1-5**: Imports.
*   **`main()`**: The entry point. It requires `WidgetsFlutterBinding` initialization and calls `di.init()` to setup all dependencies before running the app.

### `core/network/api_client.dart`
*   **Class `ApiClient`**: Singleton or Factory wrapper.
*   **`get(url)`**: Performs GET request using Dio. Throws specific exceptions on 404/500 errors.
*   **`post(url, body)`**: Performs POST request.

### `domain/usecases/example_usecase.dart`
*   **Class Definition**: `class GetExampleUsecase`.
*   **Constructor**: Injects `ExampleRepository`.
*   **`call()`**: The executable function. It delegates the work to `repository.getExample()`.

### `data/repositories/example_repository_impl.dart`
*   **Class Definition**: Implements Domain's `ExampleRepository`.
*   **Constructor**: Injects `ExampleRemoteDataSource`.
*   **Function Implementation**:
    *   `try`: checks network, calls `dataSource.fetch()`. returns `Right(data)`.
    *   `catch`: catches ServerException, returns `Left(ServerFailure)`.

### `presentation/bloc/example/example_bloc.dart`
*   **Class Definition**: Extends `Bloc<ExampleEvent, ExampleState>`.
*   **Constructor**: Injects UseCases. Registers event handlers (`on<Event>`).
*   **Event Handler**:
    *   Emits `Loading`.
    *   Awaits `usecase()`.
    *   Checks result (`fold`).
    *   Emits `Loaded` or `Error`.

---

## 🤝 Contribution Rules
*   **Never** write business logic in UI widgets.
*   **Never** import Data layer classes (Models/DTOS) into the Presentation layer unnecessarily; try to use Entities.
*   **Always** create a UseCase for an action, even if it seems simple. This keeps the BLoC decoupled.
*   **Format** your code using standard Dart formatting before committing.
