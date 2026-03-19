import 'package:flutter/material.dart';
import 'app_enums.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final CategoryType type;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type,
    required this.color,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    CategoryType? type,
    Color? color,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, iconName: $iconName, type: $type, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.iconName == iconName &&
        other.type == type &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        iconName.hashCode ^
        type.hashCode ^
        color.hashCode;
  }
}
