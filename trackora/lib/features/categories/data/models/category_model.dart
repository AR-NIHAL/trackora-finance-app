import 'package:hive_ce/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
enum CategoryTypeModel {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CategoryTypeModel type;

  @HiveField(3)
  final int iconCodePoint;

  @HiveField(4)
  final int colorValue;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCodePoint,
    required this.colorValue,
  });
}
