import 'package:sqflite/sqflite.dart';

import '../../models/brand_model.dart';
import 'brand_datasource.dart';

class TireBrandDataSourceImpl implements TireBrandDataSource {
  final Database database;

  TireBrandDataSourceImpl(this.database);

  @override
  Future<List<BrandModel>> getAll() async {
    final result = await database.query('brands');

    return result.map((e) => BrandModel.fromJson(e)).toList();
  }

  @override
  Future<BrandModel> getById(String id) async {
    final result = await database.query(
      'brands',
      where: 'brand_id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      throw Exception('Brand not found');
    }

    return BrandModel.fromJson(result.first);
  }

  @override
  Future<void> create(BrandModel brand) async {
    await database.insert('brands', brand.toJson());
  }

  @override
  Future<void> update(BrandModel brand) async {
    await database.update(
      'brands',
      brand.toJson(),
      where: 'brand_id = ?',
      whereArgs: [brand.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await database.delete(
      'brands',
      where: 'brand_id = ?',
      whereArgs: [id],
    );
  }
}