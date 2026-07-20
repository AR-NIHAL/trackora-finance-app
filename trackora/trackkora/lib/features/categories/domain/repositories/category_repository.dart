import 'package:trackkora/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Future<Category?> getById(String id);
  Future<void> add(Category category);
  Future<void> update(Category category);
  Future<void> delete(String id);
  Future<void> initializeDefaults();
}
