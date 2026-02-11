import 'package:frontend_otis/core/enums/enums.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';

// ============================================================================
// ENUM CONVERTERS - Static functions for @JsonKey annotations
// ============================================================================

/// Parse UserStatus from String (for @JsonKey annotations).
UserStatus userStatusFromJson(dynamic json) {
  if (json == null) return UserStatus.active;
  if (json is UserStatus) return json;
  if (json is String) {
    final normalized = json.toLowerCase().trim();
    switch (normalized) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      default:
        return UserStatus.active;
    }
  }
  return UserStatus.active;
}

/// Convert UserStatus to String (for @JsonKey annotations).
String userStatusToJson(UserStatus object) {
  switch (object) {
    case UserStatus.active:
      return 'active';
    case UserStatus.inactive:
      return 'inactive';
  }
}

/// Parse OrderStatus from String (for @JsonKey annotations).
OrderStatus orderStatusFromJson(dynamic json) {
  if (json == null) return OrderStatus.pending;
  if (json is OrderStatus) return json;
  if (json is String) {
    final normalized = json.toLowerCase().trim();
    switch (normalized) {
      case 'pending':
        return OrderStatus.pending;
      case 'shipping':
        return OrderStatus.shipping;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
  return OrderStatus.pending;
}

/// Convert OrderStatus to String (for @JsonKey annotations).
String orderStatusToJson(OrderStatus object) {
  switch (object) {
    case OrderStatus.pending:
      return 'pending';
    case OrderStatus.shipping:
      return 'shipping';
    case OrderStatus.delivered:
      return 'delivered';
    case OrderStatus.cancelled:
      return 'cancelled';
  }
}

/// Parse PaymentMethod from String (for @JsonKey annotations).
PaymentMethod paymentMethodFromJson(dynamic json) {
  if (json == null) return PaymentMethod.cash;
  if (json is PaymentMethod) return json;
  if (json is String) {
    final normalized = json.toLowerCase().trim();
    switch (normalized) {
      case 'cash':
        return PaymentMethod.cash;
      case 'transfer':
        return PaymentMethod.transfer;
      default:
        return PaymentMethod.cash;
    }
  }
  return PaymentMethod.cash;
}

/// Convert PaymentMethod to String (for @JsonKey annotations).
String paymentMethodToJson(PaymentMethod object) {
  switch (object) {
    case PaymentMethod.cash:
      return 'cash';
    case PaymentMethod.transfer:
      return 'transfer';
  }
}

// ============================================================================
// SAFE PRIMITIVE CONVERTERS - Static functions for @JsonKey annotations
// ============================================================================

/// Parse String with null safety and whitespace trimming (for @JsonKey annotations).
String safeStringFromJson(dynamic json) {
  if (json == null) return '';
  if (json is String) return json.trim();
  return json.toString().trim();
}

/// Convert String to JSON (for @JsonKey annotations).
String safeStringToJson(String object) => object;

/// Parse DateTime from ISO8601 string (for @JsonKey annotations).
DateTime safeDateTimeFromJson(dynamic json) {
  if (json == null) return DateTime.now();
  if (json is DateTime) return json;
  if (json is String) {
    return DateTime.tryParse(json) ?? DateTime.now();
  }
  return DateTime.now();
}

/// Convert DateTime to ISO8601 string (for @JsonKey annotations).
String safeDateTimeToJson(DateTime object) => object.toIso8601String();

/// Parse double with flexible input types (for @JsonKey annotations).
double safeDoubleFromJson(dynamic json) {
  if (json == null) return 0.0;
  if (json is double) return json;
  if (json is int) return json.toDouble();
  if (json is String) {
    return double.tryParse(json.trim()) ?? 0.0;
  }
  return 0.0;
}

/// Convert double to JSON (for @JsonKey annotations).
double safeDoubleToJson(double object) => object;

/// Parse int with flexible input types (for @JsonKey annotations).
int safeIntFromJson(dynamic json) {
  if (json == null) return 0;
  if (json is int) return json;
  if (json is double) return json.toInt();
  if (json is String) {
    return int.tryParse(json.trim()) ?? 0;
  }
  return 0;
}

/// Convert int to JSON (for @JsonKey annotations).
int safeIntToJson(int object) => object;

/// Parse bool with flexible input types (for @JsonKey annotations).
bool safeBoolFromJson(dynamic json) {
  if (json == null) return false;
  if (json is bool) return json;
  if (json is int) return json == 1;
  if (json is String) {
    final normalized = json.toLowerCase().trim();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}

/// Convert bool to int (for @JsonKey annotations).
int safeBoolToJson(bool object) => object ? 1 : 0;

// ============================================================================
// NULLABLE STRING CONVERTERS - For String? fields
// ============================================================================

/// Parse nullable String with null safety and whitespace trimming (for String? fields).
String? nullableSafeStringFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) {
    final trimmed = json.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  final result = json.toString().trim();
  return result.isEmpty ? null : result;
}

/// Convert nullable String to JSON (for String? fields).
dynamic nullableSafeStringToJson(String? object) => object;

/// Parse nullable DateTime from ISO8601 string (for DateTime? fields).
DateTime? nullableSafeDateTimeFromJson(dynamic json) {
  if (json == null) return null;
  if (json is DateTime) return json;
  if (json is String) {
    return DateTime.tryParse(json);
  }
  return null;
}

/// Convert nullable DateTime to ISO8601 string (for DateTime? fields).
dynamic nullableSafeDateTimeToJson(DateTime? object) =>
    object?.toIso8601String();
