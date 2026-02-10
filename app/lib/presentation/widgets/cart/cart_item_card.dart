import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectionChanged;

  const CartItemCard({
    super.key,
    required this.cartItem,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final product = cartItem.product;

    if (product == null) {
      return const SizedBox(); // Or loading/error state for item
    }

    Widget content = Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A1A1B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey[900],
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.fullSpecification,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cartItem.formattedTotalPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          ),
          const SizedBox(height: 12),

          // Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Controls
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFFF8F6F6),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    _buildQtyButton(
                      context,
                      icon: Icons.remove,
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          context.read<CartBloc>().add(
                            UpdateCartItemEvent(
                              productId: cartItem.productId,
                              quantity: cartItem.quantity - 1,
                            ),
                          );
                        }
                      },
                      isEnabled: cartItem.quantity > 1,
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${cartItem.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    _buildQtyButton(
                      context,
                      icon: Icons.add,
                      onTap: () {
                        context.read<CartBloc>().add(
                          UpdateCartItemEvent(
                            productId: cartItem.productId,
                            quantity: cartItem.quantity + 1,
                          ),
                        );
                      },
                      isEnabled: cartItem.isInStock,
                    ),
                  ],
                ),
              ),

              // Delete Button
              IconButton(
                onPressed: () {
                  context.read<CartBloc>().add(
                    RemoveFromCartEvent(productId: cartItem.productId),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Remove',
                color: Colors.red[400],
              ),
            ],
          ),
        ],
      ),
    );

    if (isSelectionMode) {
      return Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: onSelectionChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: content),
        ],
      );
    }

    return content;
  }

  Widget _buildQtyButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isEnabled
              ? (isDarkMode ? Colors.grey[800] : Colors.white)
              : (isDarkMode ? Colors.grey[900] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isEnabled
              ? (isDarkMode ? Colors.white : Colors.grey[800])
              : (isDarkMode ? Colors.grey[600] : Colors.grey[400]),
        ),
      ),
    );
  }
}
