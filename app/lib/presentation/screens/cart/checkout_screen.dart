import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/domain/entities/order_item.dart';
import 'package:frontend_otis/domain/entities/cart_item.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_bloc.dart';
import 'package:frontend_otis/presentation/bloc/cart/cart_event.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_bloc.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_event.dart';
import 'package:frontend_otis/presentation/bloc/payment/payment_state.dart';

// --- Types ---
enum DeliveryType { HOME, SHOP }

// --- UI Components ---

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethod type;
  final String label;
  final String sublabel;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  const PaymentMethodItem({
    super.key,
    required this.type,
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : Colors.grey[200]!;
    final bgColor = selected
        ? AppColors.primary.withOpacity(0.05)
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.grey[300]!,
                  width: 2,
                ),
                color: selected ? AppColors.primary : Colors.white,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final String checkoutSource; // 'cart' or 'buyNow'
  final List<CartItem> items; // Used if source == 'cart'
  final Product? product; // Used if source == 'buyNow'
  final int? quantity; // Used if source == 'buyNow'

  const CheckoutScreen({
    super.key,
    required this.checkoutSource,
    this.items = const [],
    this.product,
    this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  DeliveryType _deliveryType = DeliveryType.HOME;
  PaymentMethod _paymentMethod = PaymentMethod.cash;

  final Map<String, dynamic> _selectedBranch = {
    'name': 'OTIS Shop - D1',
    'district': 'District 1, HCMC',
    'distance': '2.5 km away',
  };
  String _bookingTime = 'Today, 14:00';
  final double _discount = 50000;

  // State for Buy Now quantity
  late int _buyNowQuantity;

  @override
  void initState() {
    super.initState();
    if (widget.checkoutSource == 'buyNow') {
      _buyNowQuantity = widget.quantity ?? 1;
    } else {
      _buyNowQuantity = 0; // Not used
    }
  }

  // Helper to get effective items
  List<CartItem> get _effectiveItems {
    if (widget.checkoutSource == 'cart') {
      return widget.items;
    } else {
      if (widget.product != null) {
        return [
          CartItem(
            productId: widget.product!.id,
            quantity: _buyNowQuantity,
            product: widget.product,
          ),
        ];
      }
      return [];
    }
  }

  double get _tirePriceTotal =>
      _effectiveItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get _serviceFee => 0;
  double get _grandTotal => _tirePriceTotal + _serviceFee - _discount;

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)}₫';
  }

  void _incrementBuyNowQuantity() {
    if (widget.product != null &&
        _buyNowQuantity < widget.product!.stockQuantity) {
      setState(() {
        _buyNowQuantity++;
      });
    }
  }

  void _decrementBuyNowQuantity() {
    if (_buyNowQuantity > 1) {
      setState(() {
        _buyNowQuantity--;
      });
    }
  }

  void _onConfirmBooking() {
    // 1. Validation
    if (_effectiveItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No items to checkout')));
      return;
    }

    // Address validation (basic)
    final shippingAddress = _deliveryType == DeliveryType.HOME
        ? '123 User Address, HCMC'
        : '${_selectedBranch['name']}, ${_selectedBranch['district']}';

    if (shippingAddress.isEmpty) return;

    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code:
          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      items: _effectiveItems
          .map(
            (cartItem) => OrderItem(
              productId: cartItem.productId,
              quantity: cartItem.quantity,
              unitPrice: cartItem.product?.price ?? 0.0,
            ),
          )
          .toList(),
      totalAmount: _grandTotal,
      status: _paymentMethod == PaymentMethod.cash
          ? OrderStatus.processing
          : OrderStatus.pendingPayment,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
      source: widget.checkoutSource == 'buyNow' ? 'buy_now' : 'cart',
    );

    context.read<OrderBloc>().add(CreateOrderEvent(newOrder));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderCreated) {
              // IMPORTANT: Only clear cart if source is 'cart'
              if (widget.checkoutSource == 'cart') {
                for (var item in widget.items) {
                  context.read<CartBloc>().add(
                    RemoveFromCartEvent(productId: item.productId),
                  );
                }
              }

              final order = state.order;

              // Navigate based on payment method
              if (_paymentMethod == PaymentMethod.cash) {
                // COD: Create payment record in background for bookkeeping
                context.read<PaymentBloc>().add(
                  SelectPaymentMethodEvent(
                    orderId: order.id,
                    method: PaymentMethod.cash,
                    amount: order.totalAmount,
                  ),
                );
                // Go directly to success
                context.go('/booking-success', extra: order);
              } else {
                // Bank Transfer: Go to payment screen to show QR
                context.push(
                  '/payment',
                  extra: {'order': order, 'method': _paymentMethod},
                );
              }
            } else if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order Failed: ${state.message}')),
              );
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentFailure) {
              print(
                "Background Payment Record Creation Failed: ${state.message}",
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const HeaderBar(title: 'Checkout'),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[50],
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery vs. Service',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Switch(
                                value: _deliveryType == DeliveryType.SHOP,
                                onChanged: (val) {
                                  setState(() {
                                    _deliveryType = val
                                        ? DeliveryType.SHOP
                                        : DeliveryType.HOME;
                                  });
                                },
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildToggleOption(
                                    'Delivery to Home',
                                    _deliveryType == DeliveryType.HOME,
                                    () => setState(
                                      () => _deliveryType = DeliveryType.HOME,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: _buildToggleOption(
                                    'Install at Shop',
                                    _deliveryType == DeliveryType.SHOP,
                                    () => setState(
                                      () => _deliveryType = DeliveryType.SHOP,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              'Select Branch',
                              '${_selectedBranch['name']}\n${_selectedBranch['district']}',
                              _selectedBranch['distance'],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildDetailCard(
                              'Book Date & Time',
                              _bookingTime,
                              null,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SectionHeader(
                      title: 'Order Items (${_effectiveItems.length})',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _effectiveItems
                            .map((item) => _buildItemRow(item))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const SectionHeader(title: 'Payment Methods'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          PaymentMethodItem(
                            type: PaymentMethod.cash,
                            label: 'Cash on Delivery (COD)',
                            sublabel: 'Pay when you receive',
                            icon: '💵',
                            selected: _paymentMethod == PaymentMethod.cash,
                            onTap: () => setState(
                              () => _paymentMethod = PaymentMethod.cash,
                            ),
                          ),
                          PaymentMethodItem(
                            type: PaymentMethod.transfer,
                            label: 'Bank Transfer',
                            sublabel: 'Vietcombank, Techcombank',
                            icon: '🏦',
                            selected: _paymentMethod == PaymentMethod.transfer,
                            onTap: () => setState(
                              () => _paymentMethod = PaymentMethod.transfer,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const SectionHeader(title: 'Order Summary'),
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            'Tire Price (${_effectiveItems.length} items)',
                            _formatPrice(_tirePriceTotal),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Installation Service Fee',
                            _formatPrice(_serviceFee),
                            isFree: _serviceFee == 0,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(
                            'Discount',
                            '- ${_formatPrice(_discount)}',
                            isDiscount: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: Colors.grey[100]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Grand Total',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _formatPrice(_grandTotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total Payment',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _formatPrice(_grandTotal),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onConfirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Place Order',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, String? subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              image: item.product?.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(item.product!.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.product?.imageUrl == null
                ? const Icon(Icons.image, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product?.name ?? 'Unknown Product',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatPrice(item.product?.price ?? 0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Size: 245/45R18',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    if (widget.checkoutSource == 'cart')
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
                        ),
                      )
                    else
                      // Editable quantity for Buy Now
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: _buyNowQuantity > 1
                                  ? _decrementBuyNowQuantity
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.remove, size: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Text(
                                '$_buyNowQuantity',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap:
                                  widget.product != null &&
                                      _buyNowQuantity <
                                          widget.product!.stockQuantity
                                  ? _incrementBuyNowQuantity
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.add, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isFree = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            if (isFree) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Free',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDiscount ? Colors.green : Colors.grey[900],
          ),
        ),
      ],
    );
  }
}
