// Widget tests for ProductDetailScreen.
//
// Tests the product detail screen UI and interactions.
// Follows the testing guidelines from the Cursor Rules.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:frontend_otis/presentation/screens/product/product_detail_screen.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockProductBloc mockBloc;
  const testProductId = '1';
  final testProduct = Product(
    id: '1',
    sku: 'SKU001',
    name: 'Michelin Primacy 4',
    imageUrl: 'https://example.com/tire.jpg',
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  setUp(() {
    mockBloc = MockProductBloc();
    // Register the mock bloc with GetIt so ProductDetailScreen can find it
    get_it.GetIt.instance.registerSingleton<ProductBloc>(mockBloc);
  });

  tearDown(() {
    mockBloc.close();
    // Unregister the mock bloc after each test
    if (get_it.GetIt.instance.isRegistered<ProductBloc>()) {
      get_it.GetIt.instance.unregister<ProductBloc>();
    }
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ProductDetailScreen(productId: testProductId),
    );
  }

  testWidgets('should trigger GetProductDetailEvent on init', (tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(ProductState.initial());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    verify(() => mockBloc.add(const GetProductDetailEvent(id: testProductId)))
        .called(1);
  });

  testWidgets('shows loading indicator when state is loading', (tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.value(ProductState.loading()),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading product details...'), findsOneWidget);
  });

  testWidgets('shows product name when state is detailLoaded', (tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.value(ProductState.detailLoaded(product: testProduct)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('Michelin Primacy 4'), findsOneWidget);
  });

  testWidgets('shows Add to Cart and Buy Now buttons when state is detailLoaded',
      (tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.value(ProductState.detailLoaded(product: testProduct)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text('Buy Now'), findsOneWidget);
  });

  testWidgets('shows In Stock badge when product is in stock', (tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.value(ProductState.detailLoaded(product: testProduct)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('In Stock'), findsOneWidget);
  });

  testWidgets('shows Out of Stock badge when product is out of stock',
      (tester) async {
    // Arrange
    final outOfStockProduct = testProduct.copyWith(stockQuantity: 0);
    whenListen(
      mockBloc,
      Stream.value(ProductState.detailLoaded(product: outOfStockProduct)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text('Out of Stock'), findsOneWidget);
  });

  testWidgets('shows error message when state is error', (tester) async {
    // Arrange
    const errorMessage = 'Product not found';
    whenListen(
      mockBloc,
      Stream.value(const ProductState.error(message: errorMessage)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry button triggers GetProductDetailEvent again',
      (tester) async {
    // Arrange
    const errorMessage = 'Product not found';
    whenListen(
      mockBloc,
      Stream.value(const ProductState.error(message: errorMessage)),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.text('Retry'));
    await tester.pump();

    // Assert - Should trigger the event again
    verify(() => mockBloc.add(const GetProductDetailEvent(id: testProductId)))
        .called(2);
  });

  testWidgets('displays app bar with back button and cart icon',
      (tester) async {
    // Arrange
    whenListen(
      mockBloc,
      Stream.value(ProductState.loading()),
      initialState: ProductState.initial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });
}
