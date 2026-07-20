import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/categories/data/repositories/category_repository_impl.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';
import 'package:trackkora/features/categories/domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final repo = CategoryRepositoryImpl();
  repo.initializeDefaults();
  return repo;
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getAll();
});

final categoryByIdProvider =
    FutureProvider.family<Category?, String>((ref, id) async {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getById(id);
});

class CategoryActions {
  final CategoryRepository _repo;
  final Ref _ref;

  CategoryActions(this._repo, this._ref);

  Future<void> add(Category category) async {
    await _repo.add(category);
    _ref.invalidate(categoriesProvider);
  }

  Future<void> update(Category category) async {
    await _repo.update(category);
    _ref.invalidate(categoriesProvider);
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _ref.invalidate(categoriesProvider);
  }
}

final categoryActionsProvider = Provider<CategoryActions>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return CategoryActions(repo, ref);
});
