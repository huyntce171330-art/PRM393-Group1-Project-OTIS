import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';
import 'package:frontend_otis/presentation/bloc/order/order_bloc.dart';
import 'package:frontend_otis/presentation/bloc/order/order_event.dart';
import 'package:frontend_otis/presentation/bloc/order/order_state.dart';
import 'package:go_router/go_router.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<AdminOrderDetailsScreen> createState() =>
      _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(GetOrderDetailEvent(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFEC1313);
    final bgColor = isDarkMode
        ? const Color(0xFF221010)
        : const Color(0xFFF8F6F6);
    final surfaceColor = isDarkMode ? const Color(0xFF361B1B) : Colors.white;
    final textMain = isDarkMode ? Colors.white : const Color(0xFF181111);
    final textSub = isDarkMode ? Colors.grey[400]! : const Color(0xFF896161);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: surfaceColor.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textMain, size: 20),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            String title = 'Order Details';
            if (state is OrderDetailLoaded) {
              title =
                  'Order #${state.order.code.substring(state.order.code.length - 5)}';
            }
            return Text(
              title,
              style: TextStyle(
                color: textMain,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            );
          },
        ),
        shape: Border(
          bottom: BorderSide(
            color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
            width: 1,
          ),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEC1313)),
            );
          } else if (state is OrderDetailLoaded) {
            return Column(
              children: [
                Expanded(
                  child: _buildContent(
                    context,
                    state.order,
                    surfaceColor,
                    textMain,
                    textSub,
                    primaryColor,
                    isDarkMode,
                  ),
                ),
                _buildStickyBottomBar(state.order, surfaceColor, primaryColor),
              ],
            );
          } else if (state is OrderError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Customer Card
          _buildCustomerCard(
            order,
            surfaceColor,
            textMain,
            textSub,
            primaryColor,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          // Payment Status Section
          _buildPaymentStatusSection(
            order,
            surfaceColor,
            textMain,
            textSub,
            primaryColor,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          // Shipping Info Section
          _buildShippingInfoSection(
            order,
            surfaceColor,
            textMain,
            textSub,
            primaryColor,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          // Order Items Section
          _buildOrderItemsSection(
            order,
            surfaceColor,
            textMain,
            textSub,
            primaryColor,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          // Financial Summary
          _buildFinancialSummary(
            order,
            surfaceColor,
            textMain,
            textSub,
            primaryColor,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.white,
                    width: 2,
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAi4sYgmQPIM6M3CzGbezCW9ZxiPKCGcLd9SUZfxwsX4OmsAse7fPac0hAiWvf6eSSoFelIJmtVkBU3SgIUe8V2Tfu9kZzAkiONq36Y_eD8H0LjhFv3KamqwRujw67qzjSEn_213l1KQ66MEj6KN8nv5veXu_0fBJrkTW1wVlykVO7rV8A--pSS_hLoVdIE5QN5odc5EQtKJMijCK8NkkyxXQO3SAotJhCapl5SHbGiT9tlKtR_yT6PXdzSwWiux4e2DQmQ-tH4uQM',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCustomerName(order),
                      style: TextStyle(
                        color: textMain,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            order.shippingAddress,
                            style: TextStyle(color: textSub, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.call, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          '+84 123 456 789', // Placeholder phone
                          style: TextStyle(color: textSub, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildButton(
                  icon: Icons.call,
                  label: 'Call Customer',
                  onPressed: () {},
                  bgColor: primaryColor.withValues(alpha: 0.1),
                  textColor: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButton(
                  icon: Icons.map,
                  label: 'View Map',
                  onPressed: () {},
                  bgColor: isDarkMode
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey[100]!,
                  textColor: textMain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusSection(
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    bool isPaid =
        order.status == OrderStatus.paid ||
        order.status == OrderStatus.processing ||
        order.status == OrderStatus.completed;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xFFD1FAE5)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    color: isPaid
                        ? const Color(0xFF047857)
                        : const Color(0xFFB45309),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF221010)
                  : const Color(0xFFF8F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatusToggleItem(
                    'Paid',
                    Icons.check_circle,
                    isPaid,
                    isDarkMode,
                  ),
                ),
                Expanded(
                  child: _buildStatusToggleItem(
                    'Unpaid',
                    Icons.pending,
                    !isPaid,
                    isDarkMode,
                    isPrimaryColor: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToggleItem(
    String label,
    IconData icon,
    bool isSelected,
    bool isDarkMode, {
    bool isPrimaryColor = false,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode ? const Color(0xFF4A2A2A) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (isPrimaryColor
                        ? const Color(0xFFEC1313)
                        : Colors.green[600])
                  : Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isDarkMode
                          ? Colors.white
                          : (isPrimaryColor
                                ? const Color(0xFFEC1313)
                                : Colors.green[600]))
                    : Colors.grey[500],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfoSection(
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Info',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Driver
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF221010).withValues(alpha: 0.5)
                  : const Color(0xFFF8F6F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDeXAyjejsxRU7WFe0Sq0-F8Apnv0-MySSdiQko92tAHHUZPVtNzj8Rwz5iRf7Nd0DTXKIrcryQyRus28FagPsTe8M99yRHl2G0XS_rodztoBlUP1lUdXkowX8NOHU_sXmsU7nNYJJyxyQTwkkadtyCvqnWbu4L8dB5qDIHyyqpcvZrZ72Gr0U9J4-K0TRBwaW2eluEVq62_BEeouWzQUJGJvaLy0_R3zQOReRpG0UosVS5vgvZHOQ7i35EcmPkDzcSH2J1NpB5fc8',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mike Ross',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Assigned Driver',
                        style: TextStyle(color: textSub, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tracking
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRACKING NUMBER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textSub,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '#TRK-998877',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: primaryColor, size: 18),
                ],
              ),
              const Divider(height: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsSection(
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${order.items.length} Items',
                style: TextStyle(color: textSub, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDxxj1YV6zoC5YFIyQeKacONx06D4T-nyKv1N07AnhUuAXh0DFvE1VY2Om-09b4IK7e5WfWUCnLYVB7i1A3sTdb2zJbyryNTfZ_Ufs-ZSpCJEF7pU6u37nSTpwCnFYGIKWAdGHF8SZWHGV1r2oBX489pxTLb8qDUaZRfJ_ohgcYXPwOR-p_RFZS38ge2svuto9tmQNGdtMIQR9xoYZWtD_gqJloYId3aTaTJLcPQMTR8Cwlfye_2gQIgr36iaa5ESy3ou7LEJRapM4',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? 'Product #${item.productId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Service & Installation',
                          style: TextStyle(color: textSub, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.formattedTotalPrice,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(color: textSub, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary(
    Order order,
    Color surfaceColor,
    Color textMain,
    Color textSub,
    Color primaryColor,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF4A2A2A) : Colors.grey[100]!,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', order.formattedTotalAmount, textSub),
          const SizedBox(height: 8),
          _buildSummaryRow('Tax (8.5%)', '0 đ', textSub),
          const SizedBox(height: 8),
          _buildSummaryRow('Shipping', 'Free', const Color(0xFF047857)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Colors.transparent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                order.formattedTotalAmount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF181111),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(
    Order order,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: surfaceColor.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Cancel',
              onPressed: () {},
              bgColor: Colors.transparent,
              textColor: Colors.red[600]!,
              borderColor: Colors.red[100]!,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              label: 'Approve',
              onPressed: () {},
              bgColor: Colors.green[600]!,
              textColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.print_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCustomerName(Order order) {
    if (order.shippingAddress.contains(',')) {
      return order.shippingAddress.split(',').first;
    }
    return 'Customer #${order.id.substring(order.id.length - 4)}';
  }
}
