import 'package:json_annotation/json_annotation.dart';

/// Shared JSON converters for SQLite type mappings.
///
/// SQLite only supports INTEGER, REAL, TEXT, and BLOB types.
/// Dart `bool` must be mapped to/from SQL INTEGER (0/1).

/// Custom JSON converter for boolean values stored as integers (0/1) in SQLite.
///
/// **SQLite Rule:** No native BOOLEAN type - use INTEGER with 0 (false) and 1 (true).
///
/// Usage:
/// ```dart
/// @BoolFromIntConverter()
/// final bool isActive;
/// ```
class BoolFromIntConverter implements JsonConverter<bool, int> {
  const BoolFromIntConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool object) => object ? 1 : 0;
}

/// Custom JSON converter for boolean values that may come as int (0/1), bool, or String.
///
/// This handles API responses that may have inconsistent boolean representations.
/// For SQLite storage, prefer [BoolFromIntConverter] which is stricter.
class BoolFlexibleConverter implements JsonConverter<bool, dynamic> {
  const BoolFlexibleConverter();

  @override
  bool fromJson(dynamic json) {
    if (json == null) return false;

    if (json is bool) return json;

    if (json is int) return json == 1;

    if (json is String) {
      final normalized = json.toLowerCase().trim();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }

    return false;
  }

  @override
  int toJson(bool object) => object ? 1 : 0;
}
