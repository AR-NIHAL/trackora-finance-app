import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackora/features/categories/data/repositories/category_repository_impl.dart';
import 'package:trackora/features/categories/domain/entities/category.dart';
import 'package:trackora/features/categories/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl();
});

final categoryListProvider =
    StateNotifierProvider<CategoryListNotifier, AsyncValue<List<Category>>>(
  (ref) => CategoryListNotifier(ref.read(categoryRepositoryProvider)),
);

class CategoryListNotifier extends StateNotifier<AsyncValue<List<Category>>> {
  final CategoryRepository _repository;

  CategoryListNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll());
  }

  Future<void> add(Category category) async {
    await _repository.add(category);
    await _load();
  }

  Future<void> update(Category category) async {
    await _repository.update(category);
    await _load();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await _load();
  }

  Future<void> refresh() async => _load();
}
