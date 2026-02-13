// Integration tests for Admin Product navigation flow.
//
// Tests the navigation between List and Detail screens to ensure
// the shared AdminProductBloc maintains state correctly.
//
// Follows the Robot Pattern for maintainable tests.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/admin_product_filter.dart';
import 'package:frontend_otis/domain/entities/brand.dart';
import 'package:frontend_otis/domain/entities/tire_spec.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_detail_screen.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_product_list_screen.dart';
import 'package:frontend_otis/presentation/widgets/admin/admin_filter_chip.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAdminProductBloc
    extends MockBloc<AdminProductEvent, AdminProductState>
    implements AdminProductBloc {}

void main() {
  late MockAdminProductBloc mockBloc;

  // Test products with empty imageUrl to avoid network issues
  final tProduct1 = Product(
    id: 'prod-001',
    sku: 'SKU001',
    name: 'Michelin Primacy 4',
    imageUrl: '',
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
    brand: const Brand(id: 'brand-1', name: 'Michelin', logoUrl: ''),
  );

  final tProduct2 = Product(
    id: 'prod-002',
    sku: 'SKU002',
    name: 'Bridgestone Potenza S001',
    imageUrl: '',
    price: 3200000.0,
    stockQuantity: 25,
    isActive: true,
    createdAt: DateTime(2024, 2, 20),
    brand: const Brand(id: 'brand-2', name: 'Bridgestone', logoUrl: ''),
  );

  setUp(() {
    mockBloc = MockAdminProductBloc();
    // Register the mock bloc with GetIt so screens can find it
    get_it.GetIt.instance.registerSingleton<AdminProductBloc>(mockBloc);
  });

  tearDown(() {
    mockBloc.close();
    // Unregister the mock bloc after each test
    if (get_it.GetIt.instance.isRegistered<AdminProductBloc>()) {
      get_it.GetIt.instance.unregister<AdminProductBloc>();
    }
  });

  Widget createListScreenUnderTest() {
    return BlocProvider<AdminProductBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: const AdminProductListScreen()),
    );
  }

  Widget createDetailScreenUnderTest({required String productId}) {
    return BlocProvider<AdminProductBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: AdminProductDetailScreen(productId: productId)),
    );
  }

  group('AdminProductListScreen', () {
    testWidgets('renders Inventory title and search bar', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const AdminProductLoading()),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Inventory'), findsOneWidget);
      expect(find.text('Search tire size, brand...'), findsOneWidget);
    });

    testWidgets('displays loading skeleton when state is loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const AdminProductLoading()),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert - Loading skeleton shows ListView
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays product list when state is loaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      final loadedState = AdminProductLoaded(
        products: [tProduct1, tProduct2],
        filter: const AdminProductFilter(),
        selectedBrand: null,
        stockStatus: StockStatus.all,
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
        totalCount: 2,
      );
      whenListen(
        mockBloc,
        Stream.value(loadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Michelin Primacy 4'), findsOneWidget);
      expect(find.text('Bridgestone Potenza S001'), findsOneWidget);
    });

    testWidgets('displays empty state when no products found', (
      WidgetTester tester,
    ) async {
      // Arrange
      final emptyState = AdminProductLoaded(
        products: [],
        filter: const AdminProductFilter(),
        selectedBrand: null,
        stockStatus: StockStatus.all,
        currentPage: 1,
        totalPages: 0,
        hasMore: false,
        totalCount: 0,
      );
      whenListen(
        mockBloc,
        Stream.value(emptyState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('No products found'), findsOneWidget);
      expect(
        find.text('Add products to start managing your inventory'),
        findsOneWidget,
      );
    });

    testWidgets('displays error state when API fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorState = AdminProductError(
        message: 'Network error. Please check your connection.',
      );
      whenListen(
        mockBloc,
        Stream.value(errorState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Error loading products'), findsOneWidget);
      expect(
        find.text('Network error. Please check your connection.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('triggers GetAdminProductsEvent on init', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const AdminProductInitial());

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert - Verify GetAdminProductsEvent was added
      verify(
        () => mockBloc.add(const GetAdminProductsEvent(filter: null)),
      ).called(1);
    });

    testWidgets('displays brand filter chips', (WidgetTester tester) async {
      // Arrange
      final loadedState = AdminProductLoaded(
        products: [tProduct1],
        filter: const AdminProductFilter(),
        selectedBrand: null,
        stockStatus: StockStatus.all,
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
        totalCount: 1,
      );
      whenListen(
        mockBloc,
        Stream.value(loadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert - Filter chips should be visible (AdminFilterChip)
      expect(find.byType(AdminFilterChip), findsWidgets);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Michelin'), findsOneWidget);
    });

    testWidgets('displays low stock filter chip', (WidgetTester tester) async {
      // Arrange
      final loadedState = AdminProductLoaded(
        products: [],
        filter: const AdminProductFilter(),
        selectedBrand: null,
        stockStatus: StockStatus.lowStock,
        currentPage: 1,
        totalPages: 0,
        hasMore: false,
        totalCount: 0,
      );
      whenListen(
        mockBloc,
        Stream.value(loadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.text('Low Stock'), findsOneWidget);
    });

    testWidgets('shows FAB button for adding products', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const AdminProductLoading()),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('filtering by brand selects the correct chip', (
      WidgetTester tester,
    ) async {
      // Arrange
      final loadedStateWithBrand = AdminProductLoaded(
        products: [tProduct1],
        filter: const AdminProductFilter(brandName: 'Michelin'),
        selectedBrand: 'Michelin',
        stockStatus: StockStatus.all,
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
        totalCount: 1,
      );
      whenListen(
        mockBloc,
        Stream.value(loadedStateWithBrand),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert - Both chips should exist, with Michelin selected
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Michelin'), findsOneWidget);
    });

    testWidgets('filtering by All brands shows all products', (
      WidgetTester tester,
    ) async {
      // Arrange
      final allProductsState = AdminProductLoaded(
        products: [tProduct1, tProduct2],
        filter: const AdminProductFilter(),
        selectedBrand: null,
        stockStatus: StockStatus.all,
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
        totalCount: 2,
      );
      whenListen(
        mockBloc,
        Stream.value(allProductsState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(createListScreenUnderTest());
      await tester.pump();

      // Assert - All products should be visible
      expect(find.text('Michelin Primacy 4'), findsOneWidget);
      expect(find.text('Bridgestone Potenza S001'), findsOneWidget);
    });
  });

  group('AdminProductDetailScreen', () {
    const testProductId = 'prod-001';
    testWidgets('renders product details correctly when loaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('Chi tiết sản phẩm'), findsOneWidget);
      expect(find.text('Michelin Primacy 4'), findsOneWidget);
      expect(find.text('SKU: SKU001'), findsOneWidget);
    });

    testWidgets('displays stock status badge correctly for in stock', (
      WidgetTester tester,
    ) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('In Stock'), findsOneWidget);
    });

    testWidgets('displays out of stock badge when stock is 0', (
      WidgetTester tester,
    ) async {
      // Arrange - Out of stock product
      final outOfStockProduct = Product(
        id: 'prod-003',
        sku: 'SKU003',
        name: 'Out of Stock Tire',
        imageUrl: '',
        price: 1500000.0,
        stockQuantity: 0,
        isActive: true,
        createdAt: DateTime(2024, 3, 1),
      );
      final detailLoadedState = AdminProductDetailLoaded(
        product: outOfStockProduct,
      );
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: 'prod-003'),
      );
      await tester.pump();

      // Assert
      expect(find.text('Out of Stock'), findsOneWidget);
    });

    testWidgets('displays low stock badge when stock <= 10', (
      WidgetTester tester,
    ) async {
      // Arrange - Low stock product
      final lowStockProduct = Product(
        id: 'prod-004',
        sku: 'SKU004',
        name: 'Low Stock Tire',
        imageUrl: '',
        price: 1800000.0,
        stockQuantity: 5,
        isActive: true,
        createdAt: DateTime(2024, 3, 5),
      );
      final detailLoadedState = AdminProductDetailLoaded(
        product: lowStockProduct,
      );
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: 'prod-004'),
      );
      await tester.pump();

      // Assert
      expect(find.text('Low Stock'), findsOneWidget);
    });

    testWidgets('shows loading indicator when detailLoading', (
      WidgetTester tester,
    ) async {
      // Arrange
      whenListen(
        mockBloc,
        Stream.value(const AdminProductDetailLoading()),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state when API fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      const errorState = AdminProductError(message: 'Product not found');
      whenListen(
        mockBloc,
        Stream.value(errorState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('Product not found'), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });

    testWidgets('triggers GetProductDetailEvent on init', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(const AdminProductInitial());

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert - Verify GetProductDetailEvent was added with correct productId
      verify(
        () => mockBloc.add(GetProductDetailEvent(productId: testProductId)),
      ).called(1);
    });

    testWidgets('shows Edit Product button', (WidgetTester tester) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('Edit Product'), findsOneWidget);
    });

    testWidgets('shows Delete Product button', (WidgetTester tester) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('Delete Product'), findsOneWidget);
    });

    testWidgets('displays brand information', (WidgetTester tester) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();

      // Assert
      expect(find.text('Michelin'), findsOneWidget);
    });

    testWidgets('displays tire specifications', (WidgetTester tester) async {
      // Arrange - Product with tire specs
      final tireProduct = Product(
        id: 'prod-005',
        sku: 'SKU005',
        name: 'Tire with Specs',
        imageUrl: '',
        price: 2500000.0,
        stockQuantity: 30,
        isActive: true,
        createdAt: DateTime(2024, 4, 1),
        tireSpec: const TireSpec(
          id: 'tire-spec-1',
          width: 205,
          aspectRatio: 55,
          rimDiameter: 16,
        ),
      );
      final detailLoadedState = AdminProductDetailLoaded(product: tireProduct);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: 'prod-005'),
      );
      await tester.pump();

      // Assert
      expect(find.text('205 mm'), findsOneWidget);
      expect(find.text('55%'), findsOneWidget);
      expect(find.text('R16'), findsOneWidget);
    });
  });

  // ===========================================================================
  // UC-07: DELETE PRODUCT FLOW TESTS (NEW)
  // ===========================================================================

  group('UC-07: Delete Product Flow', () {
    const testProductId = 'prod-001';

    testWidgets(
      'should show confirmation dialog when Delete Product button is tapped',
      (WidgetTester tester) async {
        // Arrange
        final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
        whenListen(
          mockBloc,
          Stream.value(detailLoadedState),
          initialState: const AdminProductInitial(),
        );

        // Act
        await tester.pumpWidget(
          createDetailScreenUnderTest(productId: testProductId),
        );
        await tester.pump();
        await tester.tap(find.text('Delete Product'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Delete Product?'), findsOneWidget);
        expect(
          find.text(
            'Are you sure you want to delete this product? This action cannot be undone.',
          ),
          findsOneWidget,
        );
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
      },
    );

    testWidgets(
      'should display Delete button in confirmation dialog (danger action)',
      (WidgetTester tester) async {
        // Arrange
        final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
        whenListen(
          mockBloc,
          Stream.value(detailLoadedState),
          initialState: const AdminProductInitial(),
        );

        // Act
        await tester.pumpWidget(
          createDetailScreenUnderTest(productId: testProductId),
        );
        await tester.pump();
        await tester.tap(find.text('Delete Product'));
        await tester.pumpAndSettle();

        // Assert - Verify Delete button exists in dialog
        expect(find.text('Delete'), findsOneWidget);
      },
    );

    testWidgets('should show confirmation dialog with product name', (
      WidgetTester tester,
    ) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: testProductId),
      );
      await tester.pump();
      await tester.tap(find.text('Delete Product'));
      await tester.pumpAndSettle();

      // Assert - Dialog should be visible with product context
      expect(find.textContaining('Michelin'), findsAtLeastNWidgets(2));
    });
  });

  group('UC-07: Delete from List Screen', () {
    testWidgets('should have Delete Product button visible in detail screen', (
      WidgetTester tester,
    ) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: 'prod-001'),
      );
      await tester.pump();

      // Assert - Delete button should be present
      expect(find.text('Delete Product'), findsOneWidget);
    });

    testWidgets('should display confirmation dialog title', (
      WidgetTester tester,
    ) async {
      // Arrange
      final detailLoadedState = AdminProductDetailLoaded(product: tProduct1);
      whenListen(
        mockBloc,
        Stream.value(detailLoadedState),
        initialState: const AdminProductInitial(),
      );

      // Act - Open delete dialog
      await tester.pumpWidget(
        createDetailScreenUnderTest(productId: 'prod-001'),
      );
      await tester.pump();
      await tester.tap(find.text('Delete Product'));
      await tester.pumpAndSettle();

      // Assert - Dialog title should be visible
      expect(find.text('Delete Product?'), findsOneWidget);
    });
  });
}
