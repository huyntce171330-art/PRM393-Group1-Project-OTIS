import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart' as di;
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_state.dart';
import 'package:frontend_otis/presentation/widgets/confirmation_dialog.dart';
import 'package:frontend_otis/presentation/widgets/cart/cart_item_card.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Check if CartBloc is already provided by parent context or needs injection
  // In a real app, CartBloc is often global. Assuming it's a singleton in DI.
  late CartBloc _cartBloc;
  final Set<String> _selectedItemIds = {};

  bool _hasInitializedSelection = false;

  @override
  void initState() {
    super.initState();
    // Assuming we want to use the global singleton instance from GetIt
    // and provide it if not already in context.
    try {
      _cartBloc = context.read<CartBloc>();
    } catch (_) {
      _cartBloc = di.sl<CartBloc>();
    }
    // Only load if not already loaded? Or always refresh?
    if (_cartBloc.state is CartInitial) {
      _cartBloc.add(LoadCartEvent());
    }
  }

  void _initializeSelection(CartLoaded state) {
    if (!_hasInitializedSelection) {
      _selectedItemIds.clear();
      _selectedItemIds.addAll(state.cartItems.map((e) => e.productId));
      _hasInitializedSelection = true;
    } else {
      // Maintain selection for existing items
      final currentIds = state.cartItems.map((e) => e.productId).toSet();
      _selectedItemIds.removeWhere((id) => !currentIds.contains(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If context doesn't have CartBloc, wrap with BlocProvider.value
    // But usually routes are wrapped or global.
    // For safety, let's wrap just in case this is a pushed route without provider.
    return BlocProvider.value(
      value: _cartBloc,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          int count = 0;
          if (state is CartLoaded) {
            count = state.itemCount;
          }

          return Scaffold(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.backgroundDark
                : const Color(0xFFF8F6F6), // background-light
            appBar: HeaderBar(
              title: 'My Cart ($count)',
              onBack: () => context.pop(),
              actions: const [],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is CartLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CartLoaded) {
                          if (state.cartItems.isEmpty) {
                            return _buildEmptyCart(context);
                          }
                          _initializeSelection(state);
                          return _buildCartContent(context, state);
                        } else if (state is CartError) {
                          return Center(child: Text('Error: ${state.message}'));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Calculate totals based on selected items
    double selectedSubtotal = 0;
    for (var item in state.cartItems) {
      if (_selectedItemIds.contains(item.productId)) {
        selectedSubtotal += item.totalPrice;
      }
    }
    final selectedVat = selectedSubtotal * 0.00; // 0%
    final selectedTotal = selectedSubtotal + selectedVat;

    return Column(
      children: [
        // Select All / Remove Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isDarkMode ? Colors.black26 : Colors.grey[50],
          child: Row(
            children: [
              // Select All Checkbox
              Checkbox(
                value:
                    _selectedItemIds.length == state.cartItems.length &&
                    state.cartItems.isNotEmpty,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedItemIds.addAll(
                        state.cartItems.map((item) => item.productId),
                      );
                    } else {
                      _selectedItemIds.clear();
                    }
                  });
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'Select All',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              // Remove Selected Button
              if (_selectedItemIds.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'Remove Items',
                        message:
                            'Are you sure you want to remove selected items from your cart?',
                        confirmLabel: 'Remove',
                        cancelLabel: 'Cancel',
                        isDestructive: true,
                        icon: Icons.delete_outline,
                        onConfirm: () {
                          for (var id in _selectedItemIds) {
                            context.read<CartBloc>().add(
                              RemoveFromCartEvent(productId: id),
                            );
                          }
                          setState(() {
                            _selectedItemIds.clear();
                          });
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.error,
                  ),
                  label: const Text(
                    'Remove All',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
            ],
          ),
        ),
        // List of items
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...state.cartItems.map(
                  (item) => CartItemCard(
                    cartItem: item,
                    isSelectionMode: true, // Always show checkbox
                    isSelected: _selectedItemIds.contains(item.productId),
                    onSelectionChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedItemIds.add(item.productId);
                        } else {
                          _selectedItemIds.remove(item.productId);
                        }
                      });
                    },
                  ),
                ),
                // Order Notes Removed as per request
              ],
            ),
          ),
        ),

        // Summary Footer
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2A1A1B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[500],
                        ),
                      ),
                      Text(
                        state.formatCurrency(selectedSubtotal),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // VAT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax (0% VAT)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[500],
                        ),
                      ),
                      Text(
                        state.formatCurrency(selectedVat),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    height: 24,
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  ),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            state.formatCurrency(selectedTotal),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Include VAT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedItemIds.isEmpty
                          ? null // Disable if nothing selected
                          : () {
                              // Checkout logic for _selectedItemIds
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Proceeding to Checkout...'),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[500],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Checkout (${_selectedItemIds.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Your Cart is Empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.pop(),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
