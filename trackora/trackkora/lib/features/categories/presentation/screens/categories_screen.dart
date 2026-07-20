import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackkora/features/categories/domain/entities/category.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _CategoryTile(category: category, ref: ref);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    int selectedIconIndex = 0;
    int selectedColorIndex = 0;

    final icons = [
      Icons.star,
      Icons.card_giftcard,
      Icons.flight,
      Icons.pets,
      Icons.fitness_center,
      Icons.coffee,
      Icons.music_note,
      Icons.sports_esports,
    ];

    final colors = [
      0xFF2E7D32,
      0xFFC62828,
      0xFF1565C0,
      0xFFF9A825,
      0xFF6A1B9A,
      0xFF00838F,
      0xFFEF6C00,
      0xFFE91E63,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                  ),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(icons.length, (i) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedIconIndex = i),
                      child: CircleAvatar(
                        backgroundColor: selectedIconIndex == i
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade200,
                        child: Icon(
                          icons[i],
                          color: selectedIconIndex == i ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(colors.length, (i) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => selectedColorIndex = i),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(colors[i]),
                          shape: BoxShape.circle,
                          border: selectedColorIndex == i
                              ? Border.all(color: Colors.black, width: 3)
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final category = Category(
                  id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  iconCodePoint: icons[selectedIconIndex].codePoint,
                  colorValue: colors[selectedColorIndex],
                  isCustom: true,
                );
                ref.read(categoryActionsProvider).add(category);
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  final WidgetRef ref;

  const _CategoryTile({required this.category, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(category.colorValue).withValues(alpha: 0.2),
          child: Icon(
            IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
            color: Color(category.colorValue),
          ),
        ),
        title: Text(category.name),
        subtitle: Text(category.isCustom ? 'Custom' : 'Default'),
        trailing: category.isCustom
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Category'),
                      content: Text('Delete "${category.name}"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            ref.read(categoryActionsProvider).delete(category.id);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
