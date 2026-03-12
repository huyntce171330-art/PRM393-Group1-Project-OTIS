import '../../models/vehicle_make_model.dart';

abstract class VehicleMakeDataSource {
  Future<List<VehicleMakeModel>> getAll();
  Future<VehicleMakeModel> getById(String id);
  Future<void> create(VehicleMakeModel make);
  Future<void> update(VehicleMakeModel make);
  Future<void> delete(String id);
}