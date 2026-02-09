import 'package:flutter/material.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/presentation/widgets/custom_button.dart';

/// Bottom sheet for filtering products.
///
/// Features:
/// - Price range slider or text fields
/// - Sort order dropdown
/// - Category selection
/// - Apply button returns ProductFilter object
/// - Reset button to clear filters
class FilterBottomSheet extends StatefulWidget {
  final ProductFilter? initialFilter;
  final List<String>? categories;
  final VoidCallback? onReset;

  const FilterBottomSheet({
    super.key,
    this.initialFilter,
    this.categories,
    this.onReset,
  });

  static Future<ProductFilter?> show({
    required BuildContext context,
    ProductFilter? initialFilter,
    List<String>? categories,
  }) {
    return showModalBottomSheet<ProductFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        initialFilter: initialFilter,
        categories: categories,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late String _sortBy;
  late String? _selectedCategory;
  bool _isResetEnabled = false;

  @override
  void initState() {
    super.initState();
    final filter = widget.initialFilter;

    _minPriceController = TextEditingController(
      text: filter?.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: filter?.maxPrice?.toString() ?? '',
    );
    _sortBy = filter?.sortBy ?? 'createdAt';
    _selectedCategory = filter?.categoryId;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _minPriceController.clear();
      _maxPriceController.clear();
      _sortBy = 'createdAt';
      _selectedCategory = null;
      _isResetEnabled = false;
    });
    widget.onReset?.call();
  }

  void _applyFilters() {
    final minPrice = double.tryParse(_minPriceController.text);
    final maxPrice = double.tryParse(_maxPriceController.text);

    final filter = ProductFilter(
      searchQuery: widget.initialFilter?.searchQuery,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: _sortBy,
      categoryId: _selectedCategory,
    );

    Navigator.of(context).pop(filter);
  }

  void _updateResetState() {
    final hasChanges = _minPriceController.text.isNotEmpty ||
        _maxPriceController.text.isNotEmpty ||
        _selectedCategory != null ||
        _sortBy != 'createdAt';

    setState(() {
      _isResetEnabled = hasChanges;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = widget.categories ?? ['Lốp xe', 'Mâm xe', 'Phụ tùng'];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bộ lọc',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_isResetEnabled)
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text('Xóa bộ lọc'),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Price Range
          Text(
            'Khoảng giá',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  onChanged: (_) => _updateResetState(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Từ',
                    prefixText: '₫ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  onChanged: (_) => _updateResetState(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Đến',
                    prefixText: '₫ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sort Options
          Text(
            'Sắp xếp theo',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip('Mới nhất', 'createdAt'),
              _buildSortChip('Giá tăng', 'price', asc: true),
              _buildSortChip('Giá giảm', 'price', asc: false),
              _buildSortChip('Tên A-Z', 'name', asc: true),
            ],
          ),
          const SizedBox(height: 24),

          // Category
          Text(
            'Danh mục',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                    _updateResetState();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: 'Áp dụng',
              onPressed: _applyFilters,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String sortBy, {bool asc = true}) {
    final isSelected = _sortBy == sortBy;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sortBy = sortBy;
            _updateResetState();
          });
        }
      },
    );
  }
}

/// Sort option enum matching ProductFilter
enum SortOption {
  newest,
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc,
  popular,
}

extension SortOptionExtension on SortOption {
  String get label {
    switch (this) {
      case SortOption.newest: return 'Mới nhất';
      case SortOption.priceAsc: return 'Giá tăng dần';
      case SortOption.priceDesc: return 'Giá giảm dần';
      case SortOption.nameAsc: return 'Tên A-Z';
      case SortOption.nameDesc: return 'Tên Z-A';
      case SortOption.popular: return 'Phổ biến nhất';
    }
  }

  String get sortBy {
    switch (this) {
      case SortOption.newest: return 'createdAt';
      case SortOption.priceAsc:
      case SortOption.priceDesc: return 'price';
      case SortOption.nameAsc:
      case SortOption.nameDesc: return 'name';
      case SortOption.popular: return 'stockQuantity';
    }
  }

  bool get ascending {
    switch (this) {
      case SortOption.newest: return false;
      case SortOption.priceAsc: return true;
      case SortOption.priceDesc: return false;
      case SortOption.nameAsc: return true;
      case SortOption.nameDesc: return false;
      case SortOption.popular: return false;
    }
  }
}
