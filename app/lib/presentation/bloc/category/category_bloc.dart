import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/category_type.dart';
import '../../../domain/usecases/category/create_category_usecase.dart';
import '../../../domain/usecases/category/delete_category_usecase.dart';
import '../../../domain/usecases/category/get_categories_usecase.dart';
import '../../../domain/usecases/category/get_category_detail_usecase.dart';
import '../../../domain/usecases/category/update_category_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryDetailUseCase getCategoryDetailUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryBloc({
    required this.getCategoriesUseCase,
    required this.getCategoryDetailUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.deleteCategoryUseCase,
  }) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  // ================= LOAD =================

  Future<void> _onLoadCategories(
      LoadCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getCategoriesUseCase(event.type);

    result.fold(
          (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
          (data) {
        final updated =
        Map<CategoryType, List<dynamic>>.from(state.categories);
        updated[event.type] = data;

        emit(
          state.copyWith(
            isLoading: false,
            categories: updated,
          ),
        );
      },
    );
  }

  // ================= CREATE =================

  Future<void> _onCreateCategory(
      CreateCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await createCategoryUseCase(
      type: event.type,
      category: event.category,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
          (_) async {
        // Reload that specific type after creation
        add(LoadCategories(event.type));
      },
    );
  }

  // ================= UPDATE =================

  Future<void> _onUpdateCategory(
      UpdateCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await updateCategoryUseCase(
      type: event.type,
      category: event.category,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
          (_) => add(LoadCategories(event.type)),
    );
  }

  // ================= DELETE =================

  Future<void> _onDeleteCategory(
      DeleteCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await deleteCategoryUseCase(
      type: event.type,
      id: event.id,
    );

    result.fold(
          (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
          (_) => add(LoadCategories(event.type)),
    );
  }
}