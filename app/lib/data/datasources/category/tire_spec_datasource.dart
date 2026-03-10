import '../../models/tire_spec_model.dart';

abstract class TireSpecDataSource {
  Future<List<TireSpecModel>> getAll();
  Future<TireSpecModel> getById(String id);
  Future<void> create(TireSpecModel spec);
  Future<void> update(TireSpecModel spec);
  Future<void> delete(String id);
}