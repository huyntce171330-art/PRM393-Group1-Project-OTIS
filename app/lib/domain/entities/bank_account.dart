import 'package:equatable/equatable.dart';

/// Domain entity representing a bank account for transfers.
class BankAccount extends Equatable {
  final String id;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final String? branch;
  final String? qrImageUrl;
  final bool isActive;
  final DateTime createdAt;
  final String userId;

  const BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    this.branch,
    this.qrImageUrl,
    required this.isActive,
    required this.createdAt,
    required this.userId,
  });

  @override
  List<Object?> get props => [
    id,
    bankName,
    accountNumber,
    accountHolder,
    branch,
    qrImageUrl,
    isActive,
    createdAt,
    userId,
  ];
}
