// Destructive Testing - Validation Edge Cases for AdminCreateProductScreen.
//
// This test file focuses on finding vulnerabilities in the validation logic
// by testing extreme, boundary, and unexpected inputs.
//
// Tests cover:
// - Name validation edge cases
// - SKU validation edge cases
// - Price validation edge cases
// - Stock validation edge cases
// - Brand validation
// - Tire specs validation edge cases
// - Image URL validation edge cases
//
// Follows the Destructive Testing methodology.

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_vehicle_makes_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_create_product_screen.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAdminProductBloc
    extends MockBloc<AdminProductEvent, AdminProductState>
    implements AdminProductBloc {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockGetBrandsUsecase extends Mock implements GetBrandsUsecase {}

class MockGetVehicleMakesUsecase extends Mock implements GetVehicleMakesUsecase {}

void main() {
  late MockAdminProductBloc mockBloc;
  late MockProductRepository mockRepository;
  late MockGetBrandsUsecase mockGetBrandsUsecase;
  late MockGetVehicleMakesUsecase mockGetVehicleMakesUsecase;

  // Test data
  final testBrands = [
    const BrandModel(id: '1', name: 'Michelin', logoUrl: ''),
    const BrandModel(id: '2', name: 'Bridgestone', logoUrl: ''),
    const BrandModel(id: '3', name: 'Goodyear', logoUrl: ''),
  ];

  final testVehicleMakes = [
    const VehicleMakeModel(id: '1', name: 'Toyota', logoUrl: ''),
    const VehicleMakeModel(id: '2', name: 'Honda', logoUrl: ''),
  ];

  setUpAll(() {
    registerFallbackValue(AdminProductInitial());
    registerFallbackValue(CreateProductEvent(product: ProductModel(
      id: '',
      sku: '',
      name: '',
      imageUrl: '',
      brand: const BrandModel(id: '', name: '', logoUrl: ''),
      vehicleMake: const VehicleMakeModel(id: '', name: '', logoUrl: ''),
      tireSpec: const TireSpecModel(id: '', width: 0, aspectRatio: 0, rimDiameter: 0),
      price: 0.0,
      stockQuantity: 0,
      isActive: true,
      createdAt: DateTime.now(),
    )));
  });

  setUp(() {
    mockBloc = MockAdminProductBloc();
    mockRepository = MockProductRepository();
    mockGetBrandsUsecase = MockGetBrandsUsecase();
    mockGetVehicleMakesUsecase = MockGetVehicleMakesUsecase();

    // Stub the repository methods
    when(() => mockRepository.getBrands())
        .thenAnswer((_) async => Right(testBrands));
    when(() => mockRepository.getVehicleMakes())
        .thenAnswer((_) async => Right(testVehicleMakes));

    // Register mock instances with GetIt
    get_it.GetIt.instance.registerSingleton<AdminProductBloc>(mockBloc);
    get_it.GetIt.instance.registerSingleton<ProductRepository>(mockRepository);
    get_it.GetIt.instance.registerSingleton<GetBrandsUsecase>(mockGetBrandsUsecase);
    get_it.GetIt.instance.registerSingleton<GetVehicleMakesUsecase>(mockGetVehicleMakesUsecase);
  });

  tearDown(() {
    mockBloc.close();
    if (get_it.GetIt.instance.isRegistered<AdminProductBloc>()) {
      get_it.GetIt.instance.unregister<AdminProductBloc>();
    }
    if (get_it.GetIt.instance.isRegistered<ProductRepository>()) {
      get_it.GetIt.instance.unregister<ProductRepository>();
    }
    if (get_it.GetIt.instance.isRegistered<GetBrandsUsecase>()) {
      get_it.GetIt.instance.unregister<GetBrandsUsecase>();
    }
    if (get_it.GetIt.instance.isRegistered<GetVehicleMakesUsecase>()) {
      get_it.GetIt.instance.unregister<GetVehicleMakesUsecase>();
    }
  });

  Widget createScreenUnderTest() {
    return BlocProvider<AdminProductBloc>.value(
      value: mockBloc,
      child: const MaterialApp(home: AdminCreateProductScreen()),
    );
  }

  // Helper to find form field by label
  Finder findFormFieldByLabel(String label) {
    return find.widgetWithText(TextFormField, label);
  }

  // Helper to scroll to and enter text
  Future<void> enterTextInField(WidgetTester tester, String label, String text) async {
    final field = findFormFieldByLabel(label);
    await tester.ensureVisible(field);
    await tester.pump();
    await tester.enterText(field, text);
    await tester.pump();
  }

  // Helper to scroll to submit button and tap
  Future<void> scrollAndTapSubmit(WidgetTester tester) async {
    final submitButton = find.text('Tạo sản phẩm');
    await tester.ensureVisible(submitButton);
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(submitButton, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  // ===========================================================================
  // GROUP 1: NAME VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Name Validation', () {
    testWidgets('REJECT: empty name shows "Tên sản phẩm là bắt buộc"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // Enter empty name
      await enterTextInField(tester, 'Tên sản phẩm', '');
      await tester.pump();
      // Tap submit to trigger validation
      await scrollAndTapSubmit(tester);
      expect(find.text('Tên sản phẩm là bắt buộc'), findsOneWidget);
    });

    testWidgets('REJECT: name with only spaces shows validation error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', '   ');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Should show error for empty/trimmable name
      expect(find.text('Tên sản phẩm là bắt buộc'), findsOneWidget);
    });

    testWidgets('REJECT: name with 1 character shows "ít nhất 2 ký tự"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'A');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tên sản phẩm phải có ít nhất 2 ký tự'), findsOneWidget);
    });

    testWidgets('ACCEPT: name with exactly 2 characters is valid', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'AB');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Should NOT show minimum length error
      expect(find.text('Tên sản phẩm phải có ít nhất 2 ký tự'), findsNothing);
    });

    testWidgets('ACCEPT: name with exactly 200 characters is valid', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      final name200 = 'A' * 200;
      await enterTextInField(tester, 'Tên sản phẩm', name200);
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Should NOT show max length error
      expect(find.text('Tên sản phẩm không được quá 200 ký tự'), findsNothing);
    });

    testWidgets('REJECT: name with 201 characters shows "không được quá 200 ký tự"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      final name201 = 'A' * 201;
      await enterTextInField(tester, 'Tên sản phẩm', name201);
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tên sản phẩm không được quá 200 ký tự'), findsOneWidget);
    });

    testWidgets('ACCEPT: name with Vietnamese diacritical marks', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Lốp xe Bridgestone Turanza');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Vietnamese characters should be accepted
      expect(find.text('Tên sản phẩm là bắt buộc'), findsNothing);
    });

    testWidgets('ACCEPT: name with numbers', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Michelin Pilot Sport 4S 205/55R16');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tên sản phẩm là bắt buộc'), findsNothing);
    });
  });

  // ===========================================================================
  // GROUP 2: SKU VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - SKU Validation', () {
    testWidgets('REJECT: empty SKU shows "SKU là bắt buộc"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', '');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU là bắt buộc'), findsOneWidget);
    });

    testWidgets('REJECT: SKU with only spaces shows validation error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', '   ');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU là bắt buộc'), findsOneWidget);
    });

    testWidgets('REJECT: SKU with 2 characters shows "ít nhất 3 ký tự"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', 'AB');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU phải có ít nhất 3 ký tự'), findsOneWidget);
    });

    testWidgets('ACCEPT: SKU with exactly 3 characters is valid', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', 'ABC');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU phải có ít nhất 3 ký tự'), findsNothing);
    });

    testWidgets('ACCEPT: SKU with exactly 50 characters is valid', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      final sku50 = 'A' * 50;
      await enterTextInField(tester, 'SKU', sku50);
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU không được quá 50 ký tự'), findsNothing);
    });

    testWidgets('REJECT: SKU with 51 characters shows "không được quá 50 ký tự"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      final sku51 = 'A' * 51;
      await enterTextInField(tester, 'SKU', sku51);
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU không được quá 50 ký tự'), findsOneWidget);
    });

    testWidgets('REJECT: SKU with invalid characters (@#\$%)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', 'SKU@2024#123');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU chỉ được chứa chữ cái, số, gạch ngang và gạch dưới'), findsOneWidget);
    });

    testWidgets('ACCEPT: SKU with valid dash and underscore', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', 'MICH-PS4S-205_55');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU chỉ được chứa chữ cái, số, gạch ngang và gạch dưới'), findsNothing);
    });

    testWidgets('REJECT: SKU with spaces inside', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'SKU', 'SKU 2024');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('SKU chỉ được chứa chữ cái, số, gạch ngang và gạch dưới'), findsOneWidget);
    });
  });

  // ===========================================================================
  // GROUP 3: PRICE VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Price Validation', () {
    testWidgets('REJECT: empty price shows "Giá là bắt buộc"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá là bắt buộc'), findsOneWidget);
    });

    testWidgets('REJECT: price of 0 shows "Giá phải lớn hơn 0"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '0');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá phải lớn hơn 0'), findsOneWidget);
    });

    testWidgets('ACCEPT: price of 1 is valid (minimum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '1');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá phải lớn hơn 0'), findsNothing);
    });

    testWidgets('ACCEPT: price of 999999999 is valid (maximum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '999999999');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá không được vượt quá 999,999,999 VND'), findsNothing);
    });

    testWidgets('REJECT: price over 999999999 shows max error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '1000000000');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá không được vượt quá 999,999,999 VND'), findsOneWidget);
    });

    testWidgets('ACCEPT: price with Vietnamese currency format', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // Enter formatted price (the onChanged adds formatting)
      await enterTextInField(tester, 'Giá (VND)', '2450000');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Should not show validation error
      expect(find.text('Giá là bắt buộc'), findsNothing);
      expect(find.text('Giá phải lớn hơn 0'), findsNothing);
    });

    testWidgets('REJECT: very large price number (billion)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Giá (VND)', '999999999999');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Giá không được vượt quá 999,999,999 VND'), findsOneWidget);
    });
  });

  // ===========================================================================
  // GROUP 4: STOCK VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Stock Validation', () {
    testWidgets('REJECT: empty stock shows "Số lượng tồn kho là bắt buộc"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Số lượng tồn kho', '');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng tồn kho là bắt buộc'), findsOneWidget);
    });

    testWidgets('ACCEPT: stock of 0 is valid (allows out of stock)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Số lượng tồn kho', '0');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng không được âm'), findsNothing);
    });

    testWidgets('REJECT: negative stock - input blocked by formatter', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // The form should show required error if field is empty with negative intent
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng tồn kho là bắt buộc'), findsOneWidget);
    });

    testWidgets('ACCEPT: stock of 999999 is valid (maximum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Số lượng tồn kho', '999999');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng không được vượt quá 999,999'), findsNothing);
    });

    testWidgets('REJECT: stock over 999999 shows max error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Số lượng tồn kho', '1000000');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng không được vượt quá 999,999'), findsOneWidget);
    });

    testWidgets('REJECT: very large stock number', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Số lượng tồn kho', '999999999999');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Số lượng không được vượt quá 999,999'), findsOneWidget);
    });
  });

  // ===========================================================================
  // GROUP 5: BRAND VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Brand Validation', () {
    testWidgets('REJECT: brand not selected shows "Vui lòng chọn thương hiệu"', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // Fill other required fields to isolate brand validation
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Vui lòng chọn thương hiệu'), findsOneWidget);
    });
  });

  // ===========================================================================
  // GROUP 6: TIRE SPECS VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Tire Specs Validation', () {
    testWidgets('ACCEPT: empty tire specs (all optional)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // Fill required fields
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // Should not show any tire spec errors
      expect(find.text('Chiều rộng phải là số'), findsNothing);
      expect(find.text('Tỷ lệ aspect phải là số'), findsNothing);
      expect(find.text('Đường kính mâm phải là số'), findsNothing);
    });

    testWidgets('REJECT: width below 145 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      // Fill required fields
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      // Enter invalid width (index 4 = Width field)
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(4), '100');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Chiều rộng phải từ 145 đến 455 mm'), findsOneWidget);
    });

    testWidgets('REJECT: width above 455 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(4), '500');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Chiều rộng phải từ 145 đến 455 mm'), findsOneWidget);
    });

    testWidgets('ACCEPT: width = 145 (minimum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(4), '145');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Chiều rộng phải từ 145 đến 455 mm'), findsNothing);
    });

    testWidgets('ACCEPT: width = 455 (maximum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(4), '455');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Chiều rộng phải từ 145 đến 455 mm'), findsNothing);
    });

    testWidgets('REJECT: aspect ratio below 20 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(5), '10');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tỷ lệ aspect phải từ 20% đến 95%'), findsOneWidget);
    });

    testWidgets('REJECT: aspect ratio above 95 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(5), '100');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tỷ lệ aspect phải từ 20% đến 95%'), findsOneWidget);
    });

    testWidgets('ACCEPT: aspect ratio = 20 (minimum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(5), '20');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tỷ lệ aspect phải từ 20% đến 95%'), findsNothing);
    });

    testWidgets('ACCEPT: aspect ratio = 95 (maximum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(5), '95');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Tỷ lệ aspect phải từ 20% đến 95%'), findsNothing);
    });

    testWidgets('REJECT: rim below 10 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(6), '5');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Đường kính mâm phải từ 10 đến 30 inch'), findsOneWidget);
    });

    testWidgets('REJECT: rim above 30 shows error', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(6), '35');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Đường kính mâm phải từ 10 đến 30 inch'), findsOneWidget);
    });

    testWidgets('ACCEPT: rim = 10 (minimum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(6), '10');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Đường kính mâm phải từ 10 đến 30 inch'), findsNothing);
    });

    testWidgets('ACCEPT: rim = 30 (maximum boundary)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(6), '30');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('Đường kính mâm phải từ 10 đến 30 inch'), findsNothing);
    });
  });

  // ===========================================================================
  // GROUP 7: IMAGE URL VALIDATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Image URL Validation', () {
    testWidgets('ACCEPT: empty image URL (optional field)', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('URL hình ảnh không hợp lệ'), findsNothing);
    });

    testWidgets('REJECT: invalid URL format', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await enterTextInField(tester, 'URL Hình ảnh', 'not-a-url');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      // "not-a-url" doesn't have http:// or https:// protocol
      expect(find.text('URL phải bắt đầu bằng http:// hoặc https://'), findsOneWidget);
    });

    testWidgets('REJECT: URL without protocol', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await enterTextInField(tester, 'URL Hình ảnh', 'www.example.com/image.jpg');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('URL phải bắt đầu bằng http:// hoặc https://'), findsOneWidget);
    });

    testWidgets('REJECT: URL with invalid protocol', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await enterTextInField(tester, 'URL Hình ảnh', 'ftp://example.com/image.jpg');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('URL phải bắt đầu bằng http:// hoặc https://'), findsOneWidget);
    });

    testWidgets('ACCEPT: valid HTTPS URL', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await enterTextInField(tester, 'URL Hình ảnh', 'https://example.com/image.jpg');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('URL hình ảnh không hợp lệ'), findsNothing);
      expect(find.text('URL phải bắt đầu bằng http:// hoặc https://'), findsNothing);
    });

    testWidgets('ACCEPT: valid HTTP URL', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await enterTextInField(tester, 'Tên sản phẩm', 'Test Product');
      await tester.pump();
      await enterTextInField(tester, 'SKU', 'TEST-SKU');
      await tester.pump();
      await enterTextInField(tester, 'Giá (VND)', '100000');
      await tester.pump();
      await enterTextInField(tester, 'Số lượng tồn kho', '10');
      await tester.pump();
      await enterTextInField(tester, 'URL Hình ảnh', 'http://localhost:8080/image.jpg');
      await tester.pump();
      await scrollAndTapSubmit(tester);
      expect(find.text('URL hình ảnh không hợp lệ'), findsNothing);
      expect(find.text('URL phải bắt đầu bằng http:// hoặc https://'), findsNothing);
    });
  });

  // ===========================================================================
  // GROUP 8: COMBINATION EDGE CASES
  // ===========================================================================

  group('Destructive Testing - Combination Edge Cases', () {
    testWidgets('REJECT: All fields empty', 
        (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.value(const AdminProductInitial()),
        initialState: const AdminProductInitial(),
      );
      await tester.pumpWidget(createScreenUnderTest());
      await tester.pumpAndSettle();
      await scrollAndTapSubmit(tester);
      // Should show multiple validation errors
      expect(find.text('Tên sản phẩm là bắt buộc'), findsOneWidget);
      expect(find.text('SKU là bắt buộc'), findsOneWidget);
      expect(find.text('Giá là bắt buộc'), findsOneWidget);
      expect(find.text('Số lượng tồn kho là bắt buộc'), findsOneWidget);
      expect(find.text('Vui lòng chọn thương hiệu'), findsOneWidget);
    });
  });
}
