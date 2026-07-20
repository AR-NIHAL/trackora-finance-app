import 'package:hive_ce/hive.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/features/categories/data/default_categories.dart';
import 'package:trackkora/features/categories/data/models/category_model.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';
import 'package:trackkora/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  late Box<CategoryModel> _box;

  CategoryRepositoryImpl() {
    _box = Hive.box<CategoryModel>(HiveBoxes.categories);
  }

  @override
  Future<void> initializeDefaults() async {
    if (_box.isEmpty) {
      for (final category in DefaultCategories.all) {
        final model = CategoryModel.fromEntity(category);
        await _box.put(category.id, model);
      }
    }
  }

  @override
  Future<List<Category>> getAll() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final model = _box.get(id);
    return model?.toEntity();
  }

  @override
  Future<void> add(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _box.put(category.id, model);
  }

  @override
  Future<void> update(Category category) async {
    final model = CategoryModel.fromEntity(category);
    await _box.put(category.id, model);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
