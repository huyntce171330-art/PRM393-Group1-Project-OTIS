import 'package:frontend_otis/core/enums/order_enums.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment(PaymentModel payment);
  Future<PaymentModel> processFakePayment(String orderId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  @override
  Future<PaymentModel> createPayment(PaymentModel payment) async {
    final db = await DatabaseHelper.database;
    return await db.transaction((txn) async {
      try {
        // Insert Payment
        // payment_id is auto-increment, but we might have generated a temp ID in Entity.
        // Let DB Generate ID.
        // We use order_id as foreign key.

        final paymentId = await txn.insert('payments', {
          'order_id': payment
              .orderId, // Ensure this is int if DB expects int, but model parses it. DB schema uses INTEGER order_id.
          'payment_code': payment.paymentCode,
          'amount': payment.amount,
          'method': const PaymentMethodConverter().toJson(payment.method),
          'status': const PaymentStatusConverter().toJson(payment.status),
          'created_at': DateTime.now().toIso8601String(),
        });

        // COD Logic: Update Order Status immediately
        if (payment.method == PaymentMethod.cash) {
          await txn.update(
            'orders',
            {'status': 'processing'},
            where: 'order_id = ?',
            whereArgs: [payment.orderId],
          );
        }

        // Return Payment with new ID
        // Construct new model
        return PaymentModel(
          id: paymentId.toString(),
          orderId: payment.orderId,
          paymentCode: payment.paymentCode,
          amount: payment.amount,
          method: payment.method,
          status: payment.status,
          createdAt: DateTime.now(),
        );
      } catch (e) {
        throw Exception("Create Payment Failed: $e");
      }
    });
  }

  @override
  Future<PaymentModel> processFakePayment(String orderId) async {
    // This is "Confirm Payment" action (I Have Paid)
    final db = await DatabaseHelper.database;
    return await db.transaction((txn) async {
      try {
        // Find existing payment for order
        final List<Map<String, dynamic>> maps = await txn.query(
          'payments',
          where: 'order_id = ?',
          whereArgs: [orderId],
        );

        int paymentId;
        PaymentModel currentPayment;

        if (maps.isNotEmpty) {
          // Update existing
          paymentId = maps.first['payment_id'];
          currentPayment = PaymentModel.fromJson(maps.first);

          await txn.update(
            'payments',
            {'status': 'success', 'paid_at': DateTime.now().toIso8601String()},
            where: 'payment_id = ?',
            whereArgs: [paymentId],
          );
        } else {
          // Should ideally exist if "Create Payment" was called.
          // If not, force create one (defensive)
          // Mock data if forcing
          paymentId = await txn.insert('payments', {
            'order_id': orderId,
            'payment_code':
                'TRX-FORCE-${DateTime.now().millisecondsSinceEpoch}',
            'amount': 0.0, // Unknown
            'method': 'transfer',
            'status': 'success',
            'created_at': DateTime.now().toIso8601String(),
            'paid_at': DateTime.now().toIso8601String(),
          });

          currentPayment = PaymentModel(
            id: paymentId.toString(),
            orderId: orderId,
            paymentCode: 'TRX-FORCE',
            amount: 0.0,
            method: PaymentMethod.transfer,
            status: PaymentStatus.success,
            createdAt: DateTime.now(),
          );
        }

        // Update Order Status to 'paid'
        await txn.update(
          'orders',
          {'status': 'paid'},
          where: 'order_id = ?',
          whereArgs: [
            orderId,
          ], // orderId is string in model, match DB type? DB order_id is INTEGER. SQLite allows string matching usually.
        );

        // Return updated payment model
        return PaymentModel(
          id: paymentId.toString(),
          orderId: orderId,
          paymentCode: currentPayment.paymentCode,
          amount: currentPayment.amount,
          method: currentPayment.method,
          status: PaymentStatus.success,
          createdAt: currentPayment.createdAt,
          paidAt: DateTime.now(),
        );
      } catch (e) {
        throw Exception("Process Payment Failed: $e");
      }
    });
  }
}
