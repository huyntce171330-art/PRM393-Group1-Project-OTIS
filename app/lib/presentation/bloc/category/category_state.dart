import 'package:equatable/equatable.dart';
import 'package:frontend_otis/core/enums/category_type.dart';

class CategoryState extends Equatable {
  final Map<CategoryType, List<dynamic>> categories;
  final bool isLoading;
  final String? error;

  const CategoryState({
    this.categories = const {},
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    Map<CategoryType, List<dynamic>>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, error];
}