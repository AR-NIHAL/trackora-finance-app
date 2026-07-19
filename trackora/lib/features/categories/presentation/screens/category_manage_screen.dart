import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackora/core/theme/app_radius.dart';
import 'package:trackora/core/theme/app_spacing.dart';
import 'package:trackora/core/utils/id_generator.dart';
import 'package:trackora/features/categories/domain/entities/category.dart';
import 'package:trackora/features/categories/presentation/providers/category_providers.dart';

class CategoryManageScreen extends ConsumerWidget {
  const CategoryManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories yet. Tap + to add one.'),
            );
          }

          final incomeCategories =
              categories.where((c) => c.type == CategoryType.income).toList();
          final expenseCategories =
              categories.where((c) => c.type == CategoryType.expense).toList();

          return ListView(
            padding: EdgeInsets.all(AppSpacing.md.toDouble()),
            children: [
              if (incomeCategories.isNotEmpty) ...[
                Text('Income', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: AppSpacing.sm.toDouble()),
                ...incomeCategories.map(
                  (cat) => _CategoryTile(
                    category: cat,
                    onDelete: () => ref
                        .read(categoryListProvider.notifier)
                        .delete(cat.id),
                  ),
                ),
                SizedBox(height: AppSpacing.md.toDouble()),
              ],
              if (expenseCategories.isNotEmpty) ...[
                Text('Expense', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: AppSpacing.sm.toDouble()),
                ...expenseCategories.map(
                  (cat) => _CategoryTile(
                    category: cat,
                    onDelete: () => ref
                        .read(categoryListProvider.notifier)
                        .delete(cat.id),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    CategoryType type = CategoryType.expense;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: AppSpacing.md.toDouble(),
            right: AppSpacing.md.toDouble(),
            top: AppSpacing.lg.toDouble(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Category',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: AppSpacing.md.toDouble()),
              SegmentedButton<CategoryType>(
                segments: const [
                  ButtonSegment(
                    value: CategoryType.income,
                    label: Text('Income'),
                  ),
                  ButtonSegment(
                    value: CategoryType.expense,
                    label: Text('Expense'),
                  ),
                ],
                selected: {type},
                onSelectionChanged: (sel) {
                  setSheetState(() => type = sel.first);
                },
              ),
              SizedBox(height: AppSpacing.md.toDouble()),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g. Salary, Groceries',
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: AppSpacing.md.toDouble()),
              FilledButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) return;

                  final category = Category(
                    id: generateId(),
                    name: name,
                    type: type,
                    iconCodePoint: Icons.category.codePoint,
                    colorValue: Colors.blue.toARGB32(),
                  );

                  ref.read(categoryListProvider.notifier).add(category);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Add Category'),
              ),
              SizedBox(height: AppSpacing.lg.toDouble()),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback onDelete;

  const _CategoryTile({
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);

    return Card(
      child: ListTile(
        leading: Container(
          width: AppSpacing.xxl.toDouble(),
          height: AppSpacing.xxl.toDouble(),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.allMd,
          ),
          child: Icon(
            IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
            color: color,
            size: AppSpacing.lg.toDouble(),
          ),
        ),
        title: Text(category.name),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, size: 20),
        ),
      ),
    );
  }
}
