import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/category_type.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryType? _selectedType;

  final _nameController = TextEditingController();
  final _widthController = TextEditingController();
  final _aspectRatioController = TextEditingController();
  final _rimController = TextEditingController();

  void _refresh(CategoryType type) {
    context.read<CategoryBloc>().add(LoadCategories(type));
  }

  void _addCategory() {
    if (_selectedType == null) return;

    dynamic category;

    switch (_selectedType!) {
      case CategoryType.tireBrand:
      case CategoryType.vehicleMake:
        category = {"name": _nameController.text};
        break;

      case CategoryType.tireSpec:
        category = {
          "width": int.tryParse(_widthController.text) ?? 0,
          "aspectRatio": int.tryParse(_aspectRatioController.text) ?? 0,
          "rimDiameter": int.tryParse(_rimController.text) ?? 0,
        };
        break;
    }

    context.read<CategoryBloc>().add(
      CreateCategory(
        type: _selectedType!,
        category: category,
      ),
    );

    _clearForm();
  }

  void _delete(CategoryType type, dynamic item) {
    final id = item.id?.toString() ?? item['id']?.toString();
    if (id == null) return;

    context.read<CategoryBloc>().add(
      DeleteCategory(type: type, id: id),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _widthController.clear();
    _aspectRatioController.clear();
    _rimController.clear();
    setState(() => _selectedType = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.isLoading && state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          return Column(
            children: [
              _buildCreateSection(),
              const Divider(),
              Expanded(
                child: ListView(
                  children: [
                    _buildSection(
                      CategoryType.tireBrand,
                      "Brands",
                      state,
                    ),
                    _buildSection(
                      CategoryType.vehicleMake,
                      "Vehicle Makes",
                      state,
                    ),
                    _buildSection(
                      CategoryType.tireSpec,
                      "Tire Specs",
                      state,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCreateSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<CategoryType>(
            value: _selectedType,
            hint: const Text("Select Category Type"),
            items: CategoryType.values
                .map(
                  (e) => DropdownMenuItem(
                value: e,
                child: Text(e.name),
              ),
            )
                .toList(),
            onChanged: (value) {
              setState(() => _selectedType = value);
            },
          ),
          const SizedBox(height: 12),
          if (_selectedType == CategoryType.tireBrand ||
              _selectedType == CategoryType.vehicleMake)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
          if (_selectedType == CategoryType.tireSpec) ...[
            TextField(
              controller: _widthController,
              decoration: const InputDecoration(labelText: "Width"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _aspectRatioController,
              decoration: const InputDecoration(labelText: "Aspect Ratio"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rimController,
              decoration: const InputDecoration(labelText: "Rim Diameter"),
              keyboardType: TextInputType.number,
            ),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _addCategory,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      CategoryType type,
      String title,
      CategoryState state,
      ) {
    final items = state.categories[type] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title (${items.length})",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Text("No data")
          else
            ...items.map(
                  (e) => ListTile(
                title: Text(e.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _delete(type, e),
                ),
              ),
            ),
        ],
      ),
    );
  }
}