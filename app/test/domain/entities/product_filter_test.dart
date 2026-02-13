import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';

void main() {
  group('ProductFilter', () {
    group('assertions', () {
      test('throws when page < 1', () {
        expect(() => ProductFilter(page: 0), throwsAssertionError);
      });

      test('throws when page = 0', () {
        expect(() => ProductFilter(page: 0), throwsAssertionError);
      });

      test('throws when limit < 1', () {
        expect(() => ProductFilter(limit: 0), throwsAssertionError);
      });

      test('throws when limit = 0', () {
        expect(() => ProductFilter(limit: 0), throwsAssertionError);
      });

      test('throws when minPrice > maxPrice', () {
        expect(
          () => ProductFilter(minPrice: 100, maxPrice: 50),
          throwsAssertionError,
        );
      });

      test('throws when minPrice == maxPrice is allowed', () {
        expect(
          () => ProductFilter(minPrice: 100, maxPrice: 100),
          returnsNormally,
        );
      });

      test('accepts valid filter with page=1, limit=10', () {
        expect(
          () => const ProductFilter(page: 1, limit: 10),
          returnsNormally,
        );
      });
    });

    group('default values', () {
      test('has default page = 1', () {
        const filter = ProductFilter();
        expect(filter.page, equals(1));
      });

      test('has default limit = 10', () {
        const filter = ProductFilter();
        expect(filter.limit, equals(10));
      });

      test('has default sortAscending = true', () {
        const filter = ProductFilter();
        expect(filter.sortAscending, isTrue);
      });

      test('all filter fields are null by default', () {
        const filter = ProductFilter();
        expect(filter.searchQuery, isNull);
        expect(filter.categoryId, isNull);
        expect(filter.brandId, isNull);
        expect(filter.vehicleMakeId, isNull);
        expect(filter.minPrice, isNull);
        expect(filter.maxPrice, isNull);
        expect(filter.sortBy, isNull);
      });
    });

    group('hasFilters', () {
      test('returns false for default filter', () {
        expect(const ProductFilter().hasFilters, isFalse);
      });

      test('returns true when searchQuery is set', () {
        expect(
          const ProductFilter(searchQuery: 'test').hasFilters,
          isTrue,
        );
      });

      test('returns true when searchQuery is empty string', () {
        expect(
          const ProductFilter(searchQuery: '').hasFilters,
          isTrue,
        );
      });

      test('returns true when categoryId is set', () {
        expect(
          const ProductFilter(categoryId: 'cat1').hasFilters,
          isTrue,
        );
      });

      test('returns true when brandId is set', () {
        expect(
          const ProductFilter(brandId: 'brand1').hasFilters,
          isTrue,
        );
      });

      test('returns true when vehicleMakeId is set', () {
        expect(
          const ProductFilter(vehicleMakeId: 'make1').hasFilters,
          isTrue,
        );
      });

      test('returns true when minPrice is set', () {
        expect(
          const ProductFilter(minPrice: 100).hasFilters,
          isTrue,
        );
      });

      test('returns true when maxPrice is set', () {
        expect(
          const ProductFilter(maxPrice: 500).hasFilters,
          isTrue,
        );
      });

      test('returns true when sortBy is set', () {
        expect(
          const ProductFilter(sortBy: 'price').hasFilters,
          isTrue,
        );
      });

      test('returns true when sortAscending is false', () {
        // Even though sortAscending is different from default,
        // hasFilters should still check if sortBy is set
        expect(
          const ProductFilter(sortAscending: false).hasFilters,
          isFalse,
        );
      });

      test('returns true when multiple filters are set', () {
        expect(
          const ProductFilter(
            categoryId: 'cat1',
            brandId: 'brand1',
            minPrice: 100,
            maxPrice: 500,
          ).hasFilters,
          isTrue,
        );
      });
    });

    group('isSearch', () {
      test('returns true when searchQuery is not empty', () {
        expect(
          const ProductFilter(searchQuery: 'michelin').isSearch,
          isTrue,
        );
      });

      test('returns false when searchQuery is null', () {
        expect(const ProductFilter().isSearch, isFalse);
      });

      test('returns false when searchQuery is empty string', () {
        expect(
          const ProductFilter(searchQuery: '').isSearch,
          isFalse,
        );
      });

      test('returns true when searchQuery contains spaces', () {
        expect(
          const ProductFilter(searchQuery: 'michelin primacy').isSearch,
          isTrue,
        );
      });
    });

    group('copyWith', () {
      test('preserves unspecified values', () {
        const original = ProductFilter(
          page: 2,
          limit: 20,
          searchQuery: 'test',
        );
        final copy = original.copyWith(page: 3);
        expect(copy.page, equals(3));
        expect(copy.limit, equals(20));
        expect(copy.searchQuery, equals('test'));
      });

      test('updates specified values', () {
        const original = ProductFilter(page: 1, limit: 10);
        final copy = original.copyWith(
          page: 2,
          limit: 20,
          searchQuery: 'michelin',
        );
        expect(copy.page, equals(2));
        expect(copy.limit, equals(20));
        expect(copy.searchQuery, equals('michelin'));
      });

      test('can set null values', () {
        const original = ProductFilter(
          page: 2,
          limit: 20,
          searchQuery: 'test',
          categoryId: 'cat1',
        );
        final copy = original.copyWith(
          searchQuery: null,
          categoryId: null,
        );
        expect(copy.searchQuery, isNull);
        expect(copy.categoryId, isNull);
        expect(copy.page, equals(2));
        expect(copy.limit, equals(20));
      });

      test('can update sort parameters', () {
        const original = ProductFilter(sortBy: 'name', sortAscending: true);
        final copy = original.copyWith(
          sortBy: 'price',
          sortAscending: false,
        );
        expect(copy.sortBy, equals('price'));
        expect(copy.sortAscending, isFalse);
      });
    });

    group('withSearch', () {
      test('resets page to 1 when searching', () {
        const filter = ProductFilter(page: 5, limit: 20);
        final searchFilter = filter.withSearch('michelin');
        expect(searchFilter.page, equals(1));
        expect(searchFilter.limit, equals(20));
      });

      test('sets searchQuery correctly', () {
        const filter = ProductFilter();
        final searchFilter = filter.withSearch('michelin');
        expect(searchFilter.searchQuery, equals('michelin'));
      });

      test('preserves other filter parameters', () {
        const filter = ProductFilter(
          page: 3,
          limit: 20,
          categoryId: 'cat1',
          brandId: 'brand1',
        );
        final searchFilter = filter.withSearch('michelin');
        expect(searchFilter.categoryId, equals('cat1'));
        expect(searchFilter.brandId, equals('brand1'));
        expect(searchFilter.limit, equals(20));
      });

      test('resets page even when already on page 1', () {
        const filter = ProductFilter(page: 1, limit: 10);
        final searchFilter = filter.withSearch('test');
        expect(searchFilter.page, equals(1));
      });
    });

    group('withPage', () {
      test('updates page number', () {
        const filter = ProductFilter(page: 1, limit: 10);
        final nextPageFilter = filter.withPage(2);
        expect(nextPageFilter.page, equals(2));
        expect(nextPageFilter.limit, equals(10));
      });

      test('preserves search query', () {
        const filter = ProductFilter(
          page: 1,
          limit: 10,
          searchQuery: 'michelin',
        );
        final nextPageFilter = filter.withPage(2);
        expect(nextPageFilter.searchQuery, equals('michelin'));
      });
    });

    group('clearFilters', () {
      test('clears all filter parameters', () {
        const filter = ProductFilter(
          page: 3,
          limit: 20,
          searchQuery: 'michelin',
          categoryId: 'cat1',
          brandId: 'brand1',
          minPrice: 100,
          maxPrice: 500,
          sortBy: 'price',
        );
        final clearedFilter = filter.clearFilters();
        expect(clearedFilter.page, equals(3));
        expect(clearedFilter.limit, equals(20));
        expect(clearedFilter.searchQuery, isNull);
        expect(clearedFilter.categoryId, isNull);
        expect(clearedFilter.brandId, isNull);
        expect(clearedFilter.minPrice, isNull);
        expect(clearedFilter.maxPrice, isNull);
        expect(clearedFilter.sortBy, isNull);
      });

      test('preserves pagination parameters', () {
        const filter = ProductFilter(
          page: 5,
          limit: 25,
          searchQuery: 'test',
        );
        final clearedFilter = filter.clearFilters();
        expect(clearedFilter.page, equals(5));
        expect(clearedFilter.limit, equals(25));
      });
    });

    group('clearSearch', () {
      test('clears only searchQuery', () {
        const filter = ProductFilter(
          page: 2,
          limit: 20,
          searchQuery: 'michelin',
          categoryId: 'cat1',
        );
        final clearedFilter = filter.clearSearch();
        expect(clearedFilter.searchQuery, isNull);
        expect(clearedFilter.page, equals(2));
        expect(clearedFilter.limit, equals(20));
        expect(clearedFilter.categoryId, equals('cat1'));
      });
    });

    group('toQueryParameters', () {
      test('includes pagination params', () {
        final params = const ProductFilter(page: 2, limit: 20).toQueryParameters();
        expect(params['page'], equals(2));
        expect(params['limit'], equals(20));
      });

      test('omits null filter params', () {
        final params = const ProductFilter(page: 1, limit: 10).toQueryParameters();
        expect(params.containsKey('search_query'), isFalse);
        expect(params.containsKey('category_id'), isFalse);
        expect(params.containsKey('brand_id'), isFalse);
        expect(params.containsKey('vehicle_make_id'), isFalse);
        expect(params.containsKey('min_price'), isFalse);
        expect(params.containsKey('max_price'), isFalse);
        expect(params.containsKey('sort_by'), isFalse);
        expect(params.containsKey('sort_order'), isFalse);
      });

      test('includes search_query when set', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          searchQuery: 'michelin',
        ).toQueryParameters();
        expect(params['search_query'], equals('michelin'));
      });

      test('includes category_id when set', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          categoryId: 'cat1',
        ).toQueryParameters();
        expect(params['category_id'], equals('cat1'));
      });

      test('includes brand_id when set', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          brandId: 'brand1',
        ).toQueryParameters();
        expect(params['brand_id'], equals('brand1'));
      });

      test('includes vehicle_make_id when set', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          vehicleMakeId: 'make1',
        ).toQueryParameters();
        expect(params['vehicle_make_id'], equals('make1'));
      });

      test('includes min_price and max_price when set', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          minPrice: 100,
          maxPrice: 500,
        ).toQueryParameters();
        expect(params['min_price'], equals(100));
        expect(params['max_price'], equals(500));
      });

      test('includes sort params correctly', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          sortBy: 'price',
          sortAscending: false,
        ).toQueryParameters();
        expect(params['sort_by'], equals('price'));
        expect(params['sort_order'], equals('DESC'));
      });

      test('sortAscending true produces ASC', () {
        final params = const ProductFilter(
          page: 1,
          limit: 10,
          sortBy: 'name',
          sortAscending: true,
        ).toQueryParameters();
        expect(params['sort_order'], equals('ASC'));
      });

      test('full filter with all params', () {
        final params = const ProductFilter(
          page: 2,
          limit: 20,
          searchQuery: 'michelin',
          categoryId: 'cat1',
          brandId: 'brand1',
          vehicleMakeId: 'make1',
          minPrice: 100,
          maxPrice: 500,
          sortBy: 'price',
          sortAscending: false,
        ).toQueryParameters();

        expect(params['page'], equals(2));
        expect(params['limit'], equals(20));
        expect(params['search_query'], equals('michelin'));
        expect(params['category_id'], equals('cat1'));
        expect(params['brand_id'], equals('brand1'));
        expect(params['vehicle_make_id'], equals('make1'));
        expect(params['min_price'], equals(100));
        expect(params['max_price'], equals(500));
        expect(params['sort_by'], equals('price'));
        expect(params['sort_order'], equals('DESC'));
      });
    });

    group('toString', () {
      test('includes all parameters when set', () {
        const filter = ProductFilter(
          page: 2,
          limit: 20,
          searchQuery: 'michelin',
          categoryId: 'cat1',
        );
        final string = filter.toString();
        expect(string, contains('page: 2'));
        expect(string, contains('limit: 20'));
        expect(string, contains('searchQuery: michelin'));
        expect(string, contains('categoryId: cat1'));
      });

      test('shows null for unset parameters', () {
        const filter = ProductFilter();
        final string = filter.toString();
        expect(string, contains('searchQuery: null'));
        expect(string, contains('categoryId: null'));
      });
    });

    group('props (Equatable)', () {
      test('two filters with same values are equal', () {
        const filter1 = ProductFilter(page: 1, limit: 10, searchQuery: 'test');
        const filter2 = ProductFilter(page: 1, limit: 10, searchQuery: 'test');
        expect(filter1, equals(filter2));
      });

      test('two filters with different values are not equal', () {
        const filter1 = ProductFilter(page: 1, limit: 10);
        const filter2 = ProductFilter(page: 2, limit: 10);
        expect(filter1, isNot(equals(filter2)));
      });

      test('filters with different searchQuery are not equal', () {
        const filter1 = ProductFilter(searchQuery: 'michelin');
        const filter2 = ProductFilter(searchQuery: 'bridgestone');
        expect(filter1, isNot(equals(filter2)));
      });

      test('default filters are equal', () {
        const filter1 = ProductFilter();
        const filter2 = ProductFilter();
        expect(filter1, equals(filter2));
      });
    });

    group('edge cases', () {
      test('handles maximum page number', () {
        const filter = ProductFilter(page: 999999);
        expect(filter.page, equals(999999));
      });

      test('handles maximum limit', () {
        const filter = ProductFilter(limit: 1000);
        expect(filter.limit, equals(1000));
      });

      test('handles very long search query', () {
        final longQuery = List.generate(1000, (_) => 'a').join();
        final filter = ProductFilter(searchQuery: longQuery);
        expect(filter.searchQuery, hasLength(1000));
      });

      test('handles special characters in search query', () {
        const filter = ProductFilter(searchQuery: 'test@domain.com');
        expect(filter.searchQuery, equals('test@domain.com'));
      });

      test('handles Vietnamese characters in search query', () {
        const filter = ProductFilter(searchQuery: 'lốp xe Michelin');
        expect(filter.searchQuery, equals('lốp xe Michelin'));
      });

      test('handles unicode characters in search query', () {
        const filter = ProductFilter(searchQuery: 'Michelin 205/55R16');
        expect(filter.searchQuery, equals('Michelin 205/55R16'));
      });
    });
  });
}
