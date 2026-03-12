import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/category_type.dart';
import '../../../core/error/failures.dart';
import '../../repositories/brand_repository.dart';
import '../../repositories/vehicle_make_repository.dart';
import '../../repositories/tire_spec_repository.dart';

class DeleteCategoryUseCase {
  final TireBrandRepository tireBrandRepository;
  final VehicleMakeRepository vehicleMakeRepository;
  final TireSpecRepository tireSpecRepository;

  DeleteCategoryUseCase({
    required this.tireBrandRepository,
    required this.vehicleMakeRepository,
    required this.tireSpecRepository,
  });

  Future<Either<Failure, Unit>> call({
    required CategoryType type,
    required String id,
  }) {
    switch (type) {
      case CategoryType.tireBrand:
        return tireBrandRepository.delete(id);

      case CategoryType.vehicleMake:
        return vehicleMakeRepository.delete(id);

      case CategoryType.tireSpec:
        return tireSpecRepository.delete(id);
    }
  }
}