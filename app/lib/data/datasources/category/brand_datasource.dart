import '../../models/brand_model.dart';

abstract class TireBrandDataSource {
  Future<List<BrandModel>> getAll();
  Future<BrandModel> getById(String id);
  Future<void> create(BrandModel brand);
  Future<void> update(BrandModel brand);
  Future<void> delete(String id);
}