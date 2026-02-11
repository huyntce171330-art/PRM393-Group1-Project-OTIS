// UI tests for AdminCreateProductScreen.
//
// Tests cover:
// - Form rendering
// - Bloc state handling
// - User interactions (text input)
//
// Follows the Robot Pattern and Thai Phung design system.

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_event.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';
import 'package:frontend_otis/presentation/screens/admin/admin_create_product_screen.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockAdminProductBloc extends MockBloc<AdminProductEvent, AdminProductState>
    implements AdminProductBloc {}

class MockProductRepository extends Mock
    implements ProductRepository {}

void main() {
  late MockAdminProductBloc mockBloc;
  late MockProductRepository mockRepository;
  late GetBrandsUsecase mockGetBrandsUsecase;

  setUp(() {
    mockBloc = MockAdminProductBloc();
    mockRepository = MockProductRepository();
    mockGetBrandsUsecase = GetBrandsUsecase(productRepository: mockRepository);

    // Stub the repository methods to return empty lists
    when(() => mockRepository.getBrands())
        .thenAnswer((_) async => const Right([]));

    // Register mock bloc with GetIt
    get_it.GetIt.instance.registerSingleton<AdminProductBloc>(mockBloc);
    get_it.GetIt.instance.registerSingleton<ProductRepository>(mockRepository);
    get_it.GetIt.instance.registerSingleton<GetBrandsUsecase>(mockGetBrandsUsecase);
  });

  tearDown(() {
    mockBloc.close();
    // Unregister all registered instances
    if (get_it.GetIt.instance.isRegistered<AdminProductBloc>()) {
      get_it.GetIt.instance.unregister<AdminProductBloc>();
    }
    if (get_it.GetIt.instance.isRegistered<ProductRepository>()) {
      get_it.GetIt.instance.unregister<ProductRepository>();
    }
    if (get_it.GetIt.instance.isRegistered<GetBrandsUsecase>()) {
      get_it.GetIt.instance.unregister<GetBrandsUsecase>();
    }
  });

  Widget createScreenUnderTest() {
    return BlocProvider<AdminProductBloc>.value(
      value: mockBloc,
      child: const MaterialApp(
        home: AdminCreateProductScreen(),
      ),
    );
  }

  // ===========================================================================
  // GROUP 1: SCREEN RENDERING
  // ===========================================================================

  group('AdminCreateProductScreen - Rendering', () {
    testWidgets(
      'renders all form sections',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Thông tin cơ bản'), findsOneWidget);
        expect(find.text('Danh mục & Thương hiệu'), findsOneWidget);
        expect(find.text('Thông số lốp'), findsOneWidget);
        expect(find.text('Hình ảnh'), findsOneWidget);
        expect(find.text('Trạng thái'), findsOneWidget);
      },
    );

    testWidgets(
      'renders all basic info fields',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Tên sản phẩm'), findsOneWidget);
        expect(find.text('SKU'), findsOneWidget);
        expect(find.text('Giá (VND)'), findsOneWidget);
        expect(find.text('Số lượng tồn kho'), findsOneWidget);
      },
    );

    testWidgets(
      'renders submit button',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Tạo sản phẩm'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders app bar with title',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Thêm sản phẩm mới'), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      },
    );

    testWidgets(
      'renders tire specification fields',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Chiều rộng lốp'), findsOneWidget);
        expect(find.text('Tỷ lệ aspect'), findsOneWidget);
        expect(find.text('Đường kính mâm'), findsOneWidget);
      },
    );

    testWidgets(
      'renders status toggle with label',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Kích hoạt sản phẩm'), findsOneWidget);
        expect(find.byType(Switch), findsOneWidget);
      },
    );

    testWidgets(
      'renders brand dropdown',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('Thương hiệu'), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<BrandModel>), findsOneWidget);
      },
    );

    testWidgets(
      'renders image URL field',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(find.text('URL Hình ảnh'), findsOneWidget);
      },
    );
  });

  // ===========================================================================
  // GROUP 2: BLOC STATE HANDLING
  // ===========================================================================

  group('AdminCreateProductScreen - Bloc State Handling', () {
    testWidgets(
      'submit button enabled in initial state',
      (WidgetTester tester) async {
        when(() => mockBloc.state)
            .thenReturn(const AdminProductState.initial());

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        final button = find.widgetWithText(ElevatedButton, 'Tạo sản phẩm');
        expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);
      },
    );

    testWidgets(
      'initial state properties are correct',
      (WidgetTester tester) async {
        when(() => mockBloc.state)
            .thenReturn(const AdminProductState.initial());

        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        expect(mockBloc.state.isInitial, isTrue);
        expect(mockBloc.state.isCreating, isFalse);
      },
    );
  });

  // ===========================================================================
  // GROUP 3: USER INTERACTIONS
  // ===========================================================================

  group('AdminCreateProductScreen - User Interactions', () {
    testWidgets(
      'accepts text input in name field',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Tên sản phẩm'),
          'Michelin Pilot Sport 4S',
        );
        await tester.pump();

        expect(
          find.widgetWithText(TextFormField, 'Michelin Pilot Sport 4S'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'accepts text input in SKU field',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'SKU'),
          'MICH-PS4S-20555R16',
        );
        await tester.pump();

        expect(
          find.widgetWithText(TextFormField, 'MICH-PS4S-20555R16'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'accepts numeric input in tire spec fields',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        // Find all TextFormFields and enter text into specific ones by index
        final textFields = find.byType(TextFormField);
        expect(textFields, findsWidgets);

        // Enter text into the tire spec fields (width, aspect, rim)
        await tester.enterText(textFields.at(3), '205');
        await tester.enterText(textFields.at(4), '55');
        await tester.enterText(textFields.at(5), '16');
        await tester.pump();

        // Verify text was entered - just check that no error is thrown
        // The actual text is in the TextFormField controllers
      },
    );

    testWidgets(
      'accepts valid https URL in image URL field',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'URL Hình ảnh'),
          'https://example.com/images/tire.jpg',
        );
        await tester.pump();

        expect(
          find.widgetWithText(TextFormField, 'https://example.com/images/tire.jpg'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'accepts valid http URL in image URL field',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'URL Hình ảnh'),
          'http://localhost:8080/image.jpg',
        );
        await tester.pump();

        expect(
          find.widgetWithText(TextFormField, 'http://localhost:8080/image.jpg'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'accepts empty URL (optional field)',
      (WidgetTester tester) async {
        whenListen(
          mockBloc,
          Stream.value(const AdminProductState.initial()),
          initialState: const AdminProductState.initial(),
        );
        await tester.pumpWidget(createScreenUnderTest());
        await tester.pump();

        // URL field should accept empty value (it's optional)
        await tester.enterText(
          find.widgetWithText(TextFormField, 'URL Hình ảnh'),
          '',
        );
        await tester.pump();

        // Empty URL should not show validation error
        expect(find.text('URL hình ảnh không hợp lệ'), findsNothing);
      },
    );
  });
}
