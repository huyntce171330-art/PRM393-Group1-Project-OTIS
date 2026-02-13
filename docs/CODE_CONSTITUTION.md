# OTIS Project - Entity & Model Standards

## 1. Entity (Domain Layer)

**Purpose:** Pure business objects representing core domain concepts.

**Rules:**
- MUST use `@freezed` + `@immutable` annotations
- MUST have `assert()` validation for business rules in constructor
- MUST NOT contain JSON/serialization logic
- MUST be immutable - no mutable state
- SHOULD contain only business logic (getters, computed properties)
- MUST extend `Equatable` via freezed (automatic)

**Example:**
```dart
@immutable
@freezed
class Product with _$Product {
  const factory Product({
    @Assert('price >= 0', 'Price cannot be negative') required double price,
    @Assert('stockQuantity >= 0', 'Stock cannot be negative') required int stockQuantity,
  }) = _Product;
}
```

## 2. Model (Data Layer)

**Purpose:** Handle JSON serialization and API/database communication.

**Rules:**
- MUST extend `Equatable` for performance
- MUST have `toDomain()` instance method (Model -> Entity)
- MUST have `fromDomain(User user)` factory constructor (Entity -> Model)
- MUST use `json_annotation` for JSON serialization
- MUST use `SafeConverter` utilities from `core/utils/json_converters.dart`
- MUST have `@JsonSerializable(includeIfNull: false)` annotation

**Example:**
```dart
@JsonSerializable(includeIfNull: false)
class UserModel extends Equatable {
  const UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toDomain() => User(id: id, name: name);
  factory UserModel.fromDomain(User user) => UserModel(id: user.id, name: user.name);
}
```

## 3. Validation Rules

Apply these `assert()` patterns in Entity constructors:

| Field Type | Assertion | Error Message |
|------------|-----------|---------------|
| Price | `>= 0` | 'Price cannot be negative' |
| Stock | `>= 0` | 'Stock cannot be negative' |
| Quantity | `> 0` | 'Quantity must be greater than 0' |
| ID | `isNotEmpty` | 'ID cannot be empty' |
| Name | `isNotEmpty` | 'Name cannot be empty' |
| Page/Limit | `>= 1` | 'Page/Limit must be >= 1' |
| Price Range | `minPrice <= maxPrice` | 'minPrice must be <= maxPrice' |
| Dimensions | `> 0` | 'Dimension must be greater than 0' |

## 4. Null Safety Pattern

**DON'T:**
```dart
// NEVER use ! operator
product!.price
product!.isAvailable
```

**DO:**
```dart
// Use null-coalescing for default values
double get totalPrice => (product?.price ?? 0.0) * quantity;

// Use null-coalescing for boolean defaults
bool get isValid => (product?.isAvailable ?? false);

// Use local variable for repeated null checks
final currentProduct = product;
if (currentProduct == null) return 'Product not available';
```

## 5. File Structure

```
lib/
├── domain/
│   ├── entities/          # All entities (using @freezed)
│   │   ├── product.dart
│   │   ├── user.dart
│   │   └── ...
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic
├── data/
│   ├── models/            # All models (using @JsonSerializable)
│   │   ├── product_model.dart
│   │   ├── user_model.dart
│   │   └── ...
│   ├── datasources/       # Data sources
│   └── repositories/      # Repository implementations
└── core/
    ├── enums/             # Enums
    ├── utils/             # Utilities (json_converters.dart)
    └── injections/        # DI setup
```

## 6. Mapping Pattern

**Model -> Entity (toDomain):**
```dart
// In Model class
Product toDomain() {
  return Product(
    id: id,
    name: name,
    price: price,
    brand: brand?.toDomain(),
  );
}
```

**Entity -> Model (fromDomain):**
```dart
// In Model class - factory constructor
factory ProductModel.fromDomain(Product product) {
  return ProductModel(
    id: product.id,
    name: product.name,
    price: product.price,
    brand: product.brand != null ? BrandModel.fromDomain(product.brand!) : null,
  );
}
```

## 7. Enum Conversion

**Model -> Entity:**
```dart
// Handle both int (API) and Map (DB) formats
UserRole? _parseUserRole(dynamic value) {
  if (value == null) return null;
  if (value is UserRole) return value;
  if (value is int) {
    final enumRole = const UserRoleConverter().fromJson(value);
    return _enumToEntity(enumRole);
  }
  if (value is Map<String, dynamic>) {
    return UserRoleModel.fromJson(value).toDomain();
  }
  return null;
}
```

## 8. JsonKey Conventions

Use consistent naming for `@JsonKey`:

```dart
@JsonKey(name: 'product_id', fromJson: safeStringFromJson, toJson: safeStringToJson)
final String id;

@JsonKey(name: 'created_at', fromJson: safeDateTimeFromJson, toJson: safeDateTimeToJson)
final DateTime createdAt;
```

## 9. SafeConverters

Always use centralized converters from `core/utils/json_converters.dart`:

- `safeStringFromJson` / `safeStringToJson`
- `safeIntFromJson` / `safeIntToJson`
- `safeDoubleFromJson` / `safeDoubleToJson`
- `safeBoolFromJson` / `safeBoolToJson`
- `safeDateTimeFromJson` / `safeDateTimeToJson`

## 10. After Changes

When modifying entities or models:
1. Run code generation: `dart run build_runner build`
2. Fix any compilation errors
3. Run tests to verify functionality
4. Commit changes with descriptive message

## 11. Best Practices

- Keep entities pure - no side effects
- Make validation explicit with `assert()`
- Use descriptive error messages in assertions
- Document complex mapping logic
- Follow naming conventions consistently
- Use const constructors where possible
- Avoid nullable fields unless necessary
