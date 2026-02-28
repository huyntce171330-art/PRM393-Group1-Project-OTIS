

/// Product Category
enum CategoryType {
  tireBrand,
  vehicleMake,
  tireSpec,
}

extension CategoryTypeX on CategoryType {
  String get displayName {
    switch (this) {
      case CategoryType.tireBrand:
        return 'Tire Brand';
      case CategoryType.vehicleMake:
        return 'Vehicle Make';
      case CategoryType.tireSpec:
        return 'Tire Specification';
    }
  }
}