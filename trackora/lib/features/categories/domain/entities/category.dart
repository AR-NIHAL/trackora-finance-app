enum CategoryType { income, expense }

class Category {
  final String id;
  final String name;
  final CategoryType type;
  final int iconCodePoint;
  final int colorValue;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCodePoint,
    required this.colorValue,
  });

  Category copyWith({
    String? id,
    String? name,
    CategoryType? type,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
