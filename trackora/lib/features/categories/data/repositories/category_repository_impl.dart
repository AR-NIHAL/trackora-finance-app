import 'package:hive_ce/hive.dart';
import 'package:trackora/core/constants/app_constants.dart';
import 'package:trackora/features/categories/data/models/category_model.dart';
import 'package:trackora/features/categories/domain/entities/category.dart';
import 'package:trackora/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  Box<CategoryModel> get _box =>
      Hive.box<CategoryModel>(AppConstants.categoriesBox);

  Category _toEntity(CategoryModel model) {
    return Category(
      id: model.id,
      name: model.name,
      type: model.type == CategoryTypeModel.income
          ? CategoryType.income
          : CategoryType.expense,
      iconCodePoint: model.iconCodePoint,
      colorValue: model.colorValue,
    );
  }

  CategoryModel _toModel(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      type: entity.type == CategoryType.income
          ? CategoryTypeModel.income
          : CategoryTypeModel.expense,
      iconCodePoint: entity.iconCodePoint,
      colorValue: entity.colorValue,
    );
  }

  @override
  Future<List<Category>> getAll() async {
    return _box.values.map(_toEntity).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final model = _box.get(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<void> add(Category category) async {
    await _box.put(category.id, _toModel(category));
  }

  @override
  Future<void> update(Category category) async {
    await _box.put(category.id, _toModel(category));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
