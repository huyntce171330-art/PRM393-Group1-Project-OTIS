import 'package:frontend_otis/domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {
  const BankAccountModel({
    required super.id,
    required super.bankName,
    required super.accountNumber,
    required super.accountHolder,
    super.branch,
    super.qrImageUrl,
    required super.isActive,
    required super.createdAt,
    required super.userId,
  });

  /// Factory constructor to create BankAccountModel from JSON map
  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['bank_account_id'].toString(),
      bankName: json['bank_name'] as String,
      accountNumber: json['account_number'] as String,
      accountHolder: json['account_holder'] as String,
      branch: json['branch'] as String?,
      qrImageUrl: json['qr_image_url'] as String?,
      isActive: (json['is_active'] as int? ?? 1) == 1,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      userId: json['user_id'].toString(),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'bank_account_id': id,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_holder': accountHolder,
      'branch': branch,
      'qr_image_url': qrImageUrl,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  /// Convert from domain entity
  factory BankAccountModel.fromDomain(BankAccount account) {
    return BankAccountModel(
      id: account.id,
      bankName: account.bankName,
      accountNumber: account.accountNumber,
      accountHolder: account.accountHolder,
      branch: account.branch,
      qrImageUrl: account.qrImageUrl,
      isActive: account.isActive,
      createdAt: account.createdAt,
      userId: account.userId,
    );
  }
}
