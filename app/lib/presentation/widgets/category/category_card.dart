// Card widget to display a category.
//
// Steps:
// 1. `Card` with `InkWell`.
// 2. Display Image (or icon) and Name.
// 3. `onTap` callback.
import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

class AdminCategoryCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminCategoryCard({
    super.key,
    required this.name,
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
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
        ),
      ),
      child: Row(
        children: [
          _buildImage(isDark),
          const SizedBox(width: 12),
          _buildInfo(isDark),
          const SizedBox(width: 8),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        height: 72,
        color: isDark ? Colors.grey[800] : Colors.grey[50],
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
    return const Center(
      child: Icon(
        Icons.category,
        size: 28,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInfo(bool isDark) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton(Icons.edit, AppColors.primary, onEdit),
        const SizedBox(height: 4),
        _actionButton(Icons.delete, Colors.grey[400]!, onDelete),
      ],
    );
  }

  Widget _actionButton(
      IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}