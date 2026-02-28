import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/category_type.dart';
import '../../../core/error/failures.dart';
import '../../entities/brand.dart';
import '../../entities/vehicle_make.dart';
import '../../entities/tire_spec.dart';
import '../../repositories/brand_repository.dart';
import '../../repositories/vehicle_make_repository.dart';
import '../../repositories/tire_spec_repository.dart';

class UpdateCategoryUseCase {
  final TireBrandRepository tireBrandRepository;
  final VehicleMakeRepository vehicleMakeRepository;
  final TireSpecRepository tireSpecRepository;

  UpdateCategoryUseCase({
    required this.tireBrandRepository,
    required this.vehicleMakeRepository,
    required this.tireSpecRepository,
  });

  Future<Either<Failure, Unit>> call({
    required CategoryType type,
    required dynamic category,
  }) {
    switch (type) {
      case CategoryType.tireBrand:
        return tireBrandRepository.update(category as Brand);

      case CategoryType.vehicleMake:
        return vehicleMakeRepository.update(category as VehicleMake);

      case CategoryType.tireSpec:
        return tireSpecRepository.update(category as TireSpec);
    }
  }
}