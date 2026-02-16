// Unit tests for Admin Product Validations
//
// Tests the new validation logic:
// - Search debounce and sanitization
// - Price range validation

import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

void main() {
  group('validatePriceRange', () {
    test('returns null for valid price range', () {
      final result = validatePriceRange(500000.0, 2000000.0);
      expect(result, isNull);
    });

    test('returns null when both prices are null', () {
      final result = validatePriceRange(null, null);
      expect(result, isNull);
    });

    test('returns null when only minPrice is set', () {
      final result = validatePriceRange(500000.0, null);
      expect(result, isNull);
    });

    test('returns null when only maxPrice is set', () {
      final result = validatePriceRange(null, 2000000.0);
      expect(result, isNull);
    });

    test('returns error when minPrice is negative', () {
      final result = validatePriceRange(-100.0, 2000000.0);
      expect(result, 'Giá tối thiểu không được âm');
    });

    test('returns error when maxPrice exceeds limit', () {
      final result = validatePriceRange(500000.0, 15000000.0);
      expect(result, 'Giá tối đa không được vượt quá 10.000.000 VND');
    });

    test('returns error when minPrice > maxPrice', () {
      final result = validatePriceRange(2000000.0, 500000.0);
      expect(result, 'Giá tối thiểu không được lớn hơn giá tối đa');
    });

    test('allows equal minPrice and maxPrice', () {
      final result = validatePriceRange(1000000.0, 1000000.0);
      expect(result, isNull);
    });

    test('handles edge case at lower limit (0)', () {
      final result = validatePriceRange(0.0, 1000000.0);
      expect(result, isNull);
    });

    test('handles edge case at upper limit (10000000)', () {
      final result = validatePriceRange(0.0, 10000000.0);
      expect(result, isNull);
    });
  });

  group('AdminProductFilter price filter', () {
    test('hasPriceFilter returns false when no price filter', () {
      const filter = AdminProductFilter();
      expect(filter.hasPriceFilter, isFalse);
    });

    test('hasPriceFilter returns true when minPrice is set', () {
      final filter = AdminProductFilter(
        baseFilter: const ProductFilter(minPrice: 500000.0),
      );
      expect(filter.hasPriceFilter, isTrue);
    });

    test('hasPriceFilter returns true when maxPrice is set', () {
      final filter = AdminProductFilter(
        baseFilter: const ProductFilter(maxPrice: 2000000.0),
      );
      expect(filter.hasPriceFilter, isTrue);
    });

    test('clearPriceFilter removes price filters', () {
      final filter = AdminProductFilter(
        baseFilter: const ProductFilter(
          minPrice: 500000.0,
          maxPrice: 2000000.0,
          searchQuery: 'test',
        ),
        brandName: 'Michelin',
      );

      final cleared = filter.clearPriceFilter();

      expect(cleared.minPrice, isNull);
      expect(cleared.maxPrice, isNull);
      expect(cleared.searchQuery, 'test'); // Preserves other filters
      expect(cleared.brandName, 'Michelin');
    });
  });
}
