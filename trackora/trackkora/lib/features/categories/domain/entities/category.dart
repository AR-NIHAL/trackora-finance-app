import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required int iconCodePoint,
    required int colorValue,
    @Default(false) bool isCustom,
  }) = _Category;
}
