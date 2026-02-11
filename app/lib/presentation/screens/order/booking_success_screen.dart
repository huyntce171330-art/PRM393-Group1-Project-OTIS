import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/domain/entities/order.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Order order;

  const BookingSuccessScreen({super.key, required this.order});

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Branding
                _buildBranding(),
                const SizedBox(height: 24),

                // Main Ticket Card
                _buildTicketCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.tire_repair, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          'OTIS TIRE SHOP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Success & QR
          _buildTopSection(),

          // Cut Line Visual
          _buildCutLine(),

          // Bottom Section: Details & Actions
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          // Success Indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.check, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),

          // Title
          const Text(
            'Order Confirmed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // Reference ID
          Text(
            'Order ID: ${order.code}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: QrImageView(
                data: order.code,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Scan instruction
          Text(
            'SHOW THIS AT PICKUP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCutLine() {
    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          // Left Notch
          Positioned(
            left: -12,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Dotted Line
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomPaint(
                size: const Size(double.infinity, 2),
                painter: DashedLinePainter(),
              ),
            ),
          ),

          // Right Notch
          Positioned(
            right: -12,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          // Details Grid
          _buildDetailsGrid(),
          const SizedBox(height: 32),

          // Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Date', _formatDate(order.createdAt)),
            ),
            Expanded(
              child: _buildDetailItem(
                'Time',
                _formatTime(order.createdAt),
                alignment: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
          child: _buildDetailItem(
            'Shipping Address',
            order.shippingAddress,
            icon: Icons.location_on,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDetailItem('Status', order.status.displayName),
            ),
            Expanded(
              child: _buildDetailItem(
                'Total Amount',
                order.formattedTotalAmount,
                alignment: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    IconData? icon,
    TextAlign? alignment,
  }) {
    return Column(
      crossAxisAlignment: alignment == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        if (icon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            value,
            textAlign: alignment,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Back to My Orders Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.go('/orders');
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text('Back to My Orders'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4F0F0),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Back to Home Button
        TextButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text(
            'Back to Home',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Custom Painter for Dashed Line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 8;
    const dashSpace = 8;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
