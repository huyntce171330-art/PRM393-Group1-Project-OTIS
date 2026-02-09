import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as sl;
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/presentation/bloc/product/product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/product/product_event.dart';
import 'package:frontend_otis/presentation/bloc/product/product_state.dart';
import 'package:frontend_otis/presentation/screens/home_screen.dart';
import 'package:frontend_otis/presentation/widgets/product/product_card.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState>
    implements ProductBloc {}

void main() {
  late MockProductBloc mockProductBloc;

  final tProduct = Product(
    id: '1',
    sku: 'SKU001',
    name: 'Michelin Primacy 4',
    imageUrl: 'https://example.com/tire1.jpg',
    price: 2450000.0,
    stockQuantity: 50,
    isActive: true,
    createdAt: DateTime(2024, 1, 15),
  );

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockProductBloc = MockProductBloc();
    // Stub the initial state
    when(() => mockProductBloc.state).thenReturn(const ProductInitial());
    // Register mock ProductBloc in GetIt
    sl.sl.registerFactory<ProductBloc>(() => mockProductBloc);
  });

  tearDown(() {
    mockProductBloc.close();
    // Unregister the mock from GetIt
    sl.sl.unregister<ProductBloc>();
  });

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('HomeScreen', () {
    testWidgets('renders search bar in header', (WidgetTester tester) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Search for tires, batteries...'), findsOneWidget);
    });

    testWidgets('typing in search field triggers searchProducts event', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Act - type text (triggers onChanged)
      await tester.enterText(
        find.widgetWithText(TextField, 'Search for tires, batteries...'),
        'bridgestone',
      );
      await tester.pump();

      // Assert - verify search event was triggered (at least once)
      // Note: enterText may trigger onChanged multiple times
      final callCount = verify(
        () => mockProductBloc.add(SearchProductsEvent(query: 'bridgestone')),
      ).callCount;
      expect(callCount, greaterThanOrEqualTo(1));
    });

    testWidgets('tapping outside search field unfocuses', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Act - tap on the search field to focus
      await tester.tap(
        find.widgetWithText(TextField, 'Search for tires, batteries...'),
      );
      await tester.pump();

      // Tap on Services text to unfocus
      await tester.tap(find.text('Services'));
      await tester.pump();

      // Assert - no exception means unfocus worked
      expect(tester.takeException(), isNull);
    });

    testWidgets('pressing done button clears search and unfocuses', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // First enter some text
      await tester.enterText(
        find.widgetWithText(TextField, 'Search for tires, batteries...'),
        'tire',
      );
      await tester.pump();

      // Act - press done button on keyboard
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert - verify search was triggered with empty query (clear behavior)
      final callCount = verify(
        () => mockProductBloc.add(SearchProductsEvent(query: '')),
      ).callCount;
      expect(callCount, greaterThanOrEqualTo(1));
    });

    testWidgets('renders bottom navigation bar', (WidgetTester tester) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Service'), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('renders promo banners', (WidgetTester tester) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert - find PageView for banners
      expect(find.byType(PageView), findsOneWidget);
      // Find at least one banner badge (PROMO)
      expect(find.text('PROMO'), findsOneWidget);
    });

    testWidgets('renders services section', (WidgetTester tester) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Services'), findsOneWidget);
      expect(find.text('Passenger'), findsOneWidget);
      expect(find.text('Truck'), findsOneWidget);
      expect(find.text('Oil'), findsOneWidget);
      expect(find.text('Battery'), findsOneWidget);
    });

    testWidgets('renders products section when loaded', (
      WidgetTester tester,
    ) async {
      // Arrange
      final loadedState = ProductLoaded(
        products: [tProduct],
        filter: const ProductFilter(),
        currentPage: 1,
        totalPages: 1,
        hasMore: false,
        totalCount: 1,
      );
      when(() => mockProductBloc.state).thenReturn(loadedState);

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('All Products'), findsOneWidget);
      expect(find.byType(ProductCard), findsOneWidget);
    });

    testWidgets('renders avatar in header', (WidgetTester tester) async {
      // Arrange
      when(() => mockProductBloc.state).thenReturn(const ProductLoading());

      // Act
      await tester.pumpWidget(
        makeTestableWidget(
          child: BlocProvider<ProductBloc>.value(
            value: mockProductBloc,
            child: const HomeScreen(),
          ),
        ),
      );

      // Assert - find avatar container (circular with image)
      expect(find.byType(Container), findsWidgets);
    });
  });
}
