import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/category_type.dart';
import '../../../core/error/failures.dart';
import '../../repositories/brand_repository.dart';
import '../../repositories/vehicle_make_repository.dart';
import '../../repositories/tire_spec_repository.dart';

class GetCategoriesUseCase {
  final TireBrandRepository tireBrandRepository;
  final VehicleMakeRepository vehicleMakeRepository;
  final TireSpecRepository tireSpecRepository;

  GetCategoriesUseCase({
    required this.tireBrandRepository,
    required this.vehicleMakeRepository,
    required this.tireSpecRepository,
  });

  Future<Either<Failure, List<dynamic>>> call(CategoryType type) {
    switch (type) {
      case CategoryType.tireBrand:
        return tireBrandRepository.getAll();

      case CategoryType.vehicleMake:
        return vehicleMakeRepository.getAll();

      case CategoryType.tireSpec:
        return tireSpecRepository.getAll();
    }
  }
}