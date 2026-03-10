import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class AdminViewUserDetailScreen extends StatefulWidget {
  final int userId;
  const AdminViewUserDetailScreen({super.key, required this.userId});

  @override
  State<AdminViewUserDetailScreen> createState() =>
      _AdminViewUserDetailScreenState();
}

class _AdminViewUserDetailScreenState extends State<AdminViewUserDetailScreen> {
  bool _loading = true;
  Map<String, Object?>? _row;

  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final db = await DatabaseHelper.database;
    final rows = await db.rawQuery('''
      SELECT 
        u.user_id,
        u.phone,
        u.full_name,
        u.address,
        u.shop_name,
        u.avatar_url,
        u.status,
        u.created_at,
        u.role_id,
        r.role_name
      FROM users u
      INNER JOIN user_roles r ON r.role_id = u.role_id
      WHERE u.user_id = ?
      LIMIT 1
    ''', [widget.userId]);

    if (!mounted) return;

    _row = rows.isNotEmpty ? rows.first : null;
    _status = (_row?['status'] ?? 'active').toString();

    setState(() => _loading = false);
  }

  Future<void> _save() async {
    try {
      await DatabaseHelper.updateUserStatus(
        userId: widget.userId,
        status: _status,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
    isDarkMode ? const Color(0xFF101622) : const Color(0xFFF8F9FB);
    final surfaceColor = isDarkMode ? const Color(0xFF1A2230) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF333333);
    final textSecondaryColor =
    isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: HeaderBar(
        title: 'Customer Detail',
        showBack: true,
        backgroundColor: surfaceColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _row == null
          ? Center(
        child: Text(
          'User not found',
          style: TextStyle(color: textSecondaryColor),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(surfaceColor, textColor, textSecondaryColor),
            const SizedBox(height: 14),
            _buildInfoCard(surfaceColor, textColor, textSecondaryColor),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
      Color surfaceColor,
      Color textColor,
      Color? textSecondaryColor,
      ) {
    final fullName = (_row?['full_name'] ?? '').toString().trim();
    final phone = (_row?['phone'] ?? '').toString().trim();
    final avatarUrl = (_row?['avatar_url'] ?? '').toString().trim();
    final roleName = (_row?['role_name'] ?? '').toString().trim();

    final title = fullName.isNotEmpty ? fullName : phone;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? Text(
              title.isNotEmpty ? title[0].toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.w900),
            )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$phone • ${roleName.isNotEmpty ? roleName : 'customer'}',
                  style: TextStyle(
                    color: textSecondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: _statusColor(_status).withValues(alpha: 0.12),
              border: Border.all(
                color: _statusColor(_status).withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              _status.toUpperCase(),
              style: TextStyle(
                color: _statusColor(_status),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      Color surfaceColor,
      Color textColor,
      Color? textSecondaryColor,
      ) {
    final address = (_row?['address'] ?? '').toString().trim();
    final shopName = (_row?['shop_name'] ?? '').toString().trim();
    final createdAt = (_row?['created_at'] ?? '').toString().trim();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information',
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),

          _kv('Shop', shopName.isNotEmpty ? shopName : '-', textSecondaryColor),
          const SizedBox(height: 8),
          _kv('Address', address.isNotEmpty ? address : '-', textSecondaryColor),
          const SizedBox(height: 8),
          _kv('Created At', createdAt.isNotEmpty ? createdAt : '-', textSecondaryColor),

          const SizedBox(height: 16),
          Text(
            'Status',
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _statusChip('active'),
              _statusChip('inactive'),
              _statusChip('banned'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, Color? textSecondaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            k,
            style: TextStyle(
              color: textSecondaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(String value) {
    final selected = _status == value;
    final c = _statusColor(value);

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => setState(() => _status = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? c.withValues(alpha: 0.14) : Colors.grey.withValues(alpha: 0.08),
          border: Border.all(
            color: selected ? c.withValues(alpha: 0.35) : Colors.grey.withValues(alpha: 0.20),
          ),
        ),
        child: Text(
          value.toUpperCase(),
          style: TextStyle(
            color: selected ? c : Colors.grey[700],
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}