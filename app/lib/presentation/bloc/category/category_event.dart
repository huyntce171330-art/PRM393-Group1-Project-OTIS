import 'package:equatable/equatable.dart';
import '../../../core/enums/category_type.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final CategoryType type;

  const LoadCategories(this.type);

  @override
  List<Object?> get props => [type];
}

class LoadCategoryDetail extends CategoryEvent {
  final CategoryType type;
  final String id;

  const LoadCategoryDetail({
    required this.type,
    required this.id,
  });

  @override
  List<Object?> get props => [type, id];
}

class CreateCategory extends CategoryEvent {
  final CategoryType type;
  final dynamic category;

  const CreateCategory({
    required this.type,
    required this.category,
  });

  @override
  List<Object?> get props => [type, category];
}

class UpdateCategory extends CategoryEvent {
  final CategoryType type;
  final dynamic category;

  const UpdateCategory({
    required this.type,
    required this.category,
  });

  @override
  List<Object?> get props => [type, category];
}

class DeleteCategory extends CategoryEvent {
  final CategoryType type;
  final String id;

  const DeleteCategory({
    required this.type,
    required this.id,
  });

  @override
  List<Object?> get props => [type, id];
}