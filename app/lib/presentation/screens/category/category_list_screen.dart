import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/category_type.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/entities/tire_spec.dart';
import '../../../domain/entities/vehicle_make.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

import '../../widgets/category/category_dialog.dart';
import '../../widgets/admin/admin_header.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryType _activeTab = CategoryType.tireBrand;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories(_activeTab));
  }

  void _switchTab(CategoryType type) {
    setState(() => _activeTab = type);
    context.read<CategoryBloc>().add(LoadCategories(type));
  }

  void _delete(CategoryType type, dynamic item) {
    final id = item.id?.toString();
    if (id == null) return;

    context.read<CategoryBloc>().add(DeleteCategory(type: type, id: id));
  }

  void _openCreateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<CategoryBloc>(),
          child: CategoryDialog(type: _activeTab),
        );
      },
    );
  }

  void _openEditDialog(dynamic item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<CategoryBloc>(),
          child: CategoryDialog(
            type: _activeTab,
            existing: item,
          ),
        );
      },
    );
  }

  String _displayName(dynamic item) {
    if (item is Brand) return item.name;
    if (item is VehicleMake) return item.name;
    if (item is TireSpec) {
      return "${item.width}/${item.aspectRatio}R${item.rimDiameter}";
    }
    return '';
  }

  String? _imageUrl(dynamic item) {
    if (item is Brand) return item.logoUrl;
    if (item is VehicleMake) return item.logoUrl;
    return null;
  }

  String _subtitle(dynamic item) {
    if (item is Brand) return "Tire Brand";
    if (item is VehicleMake) return "Vehicle Make";
    if (item is TireSpec) return "Tire Specification";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);

    return Scaffold(
      backgroundColor: background,
      appBar: const AdminHeader(),

      body: Column(
        children: [
          _buildTabs(isDark),

          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state.isLoading && state.categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = state.categories[_activeTab] ?? [];

                if (items.isEmpty) {
                  return const Center(child: Text("No categories"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 12, bottom: 80),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];

                    return _CategoryCard(
                      title: _displayName(item),
                      subtitle: _subtitle(item),
                      imageUrl: _imageUrl(item),
                      onEdit: () => _openEditDialog(item),
                      onDelete: () => _delete(_activeTab, item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE53935),
        onPressed: _openCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    const primaryColor = Color(0xFFE53935);

    final tabs = {
      CategoryType.tireBrand: "Brands",
      CategoryType.vehicleMake: "Vehicle",
      CategoryType.tireSpec: "Specs",
    };

    return Container(
      height: 54,
      width: double.infinity,
      color: isDark
          ? const Color(0xFF101622).withValues(alpha: 0.9)
          : Colors.white.withValues(alpha: 0.9),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: tabs.entries.map((e) {
          final selected = _activeTab == e.key;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _switchTab(e.key),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? primaryColor
                      : (isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white),
                  borderRadius: BorderRadius.circular(99),
                  border: selected
                      ? null
                      : Border.all(
                    color: isDark
                        ? Colors.grey[800]!
                        : Colors.grey[200]!,
                  ),
                  boxShadow: selected
                      ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    e.value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : (isDark
                          ? Colors.grey[400]
                          : Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          _buildImage(isDark),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            children: [
              _actionButton(Icons.edit, const Color(0xFF135BEC), onEdit),
              const SizedBox(height: 6),
              _actionButton(Icons.delete, Colors.grey, onDelete),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 60,
        height: 60,
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
          imageUrl!,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _placeholder(),
        )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return const Icon(Icons.category, color: Colors.grey);
  }

  Widget _actionButton(
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}