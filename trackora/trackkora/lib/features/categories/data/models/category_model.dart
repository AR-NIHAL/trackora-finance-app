import 'package:hive_ce/hive.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';

class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    this.isCustom = false,
  });

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      iconCodePoint: category.iconCodePoint,
      colorValue: category.colorValue,
      isCustom: category.isCustom,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
      isCustom: isCustom,
    );
  }
}
