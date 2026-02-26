import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';

class AdminViewListUserScreen extends StatefulWidget {
  const AdminViewListUserScreen({super.key});

  @override
  State<AdminViewListUserScreen> createState() =>
      _AdminViewListUserScreenState();
}

class _AdminViewListUserScreenState extends State<AdminViewListUserScreen> {
  final TextEditingController _searchCtl = TextEditingController();

  String _statusFilter = 'all'; // all | active | inactive | banned
  String _sort = 'newest'; // newest | oldest
  bool _loading = true;
  List<Map<String, Object?>> _rows = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    final kw = _searchCtl.text.trim();
    final db = await DatabaseHelper.database;

    // Query customers only
    final whereParts = <String>[
      "r.role_name = 'customer'",
    ];
    final args = <Object?>[];

    if (kw.isNotEmpty) {
      whereParts.add("(u.full_name LIKE ? OR u.phone LIKE ? OR u.shop_name LIKE ?)");
      args.add('%$kw%');
      args.add('%$kw%');
      args.add('%$kw%');
    }

    if (_statusFilter != 'all') {
      whereParts.add("u.status = ?");
      args.add(_statusFilter);
    }

    final orderBy = _sort == 'oldest' ? 'u.user_id ASC' : 'u.user_id DESC';

    final sql = '''
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
      WHERE ${whereParts.join(' AND ')}
      ORDER BY $orderBy
    ''';

    final rows = await db.rawQuery(sql, args);

    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loading = false;
    });
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

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'banned':
        return 'Banned';
      default:
        return status;
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
        title: 'Customers',
        showBack: true,
        backgroundColor: surfaceColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search + Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Column(
                children: [
                  _buildSearchBar(surfaceColor, textColor, textSecondaryColor),
                  const SizedBox(height: 10),
                  _buildFiltersRow(surfaceColor, textColor, textSecondaryColor),
                ],
              ),
            ),

            // List
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _rows.isEmpty
                  ? Center(
                child: Text(
                  'No customers found',
                  style: TextStyle(color: textSecondaryColor),
                ),
              )
                  : RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final u = _rows[index];
                    return _buildUserCard(
                      context,
                      u,
                      surfaceColor,
                      textColor,
                      textSecondaryColor,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
      Color surfaceColor,
      Color textColor,
      Color? textSecondaryColor,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha: 0.10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.search, color: textSecondaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchCtl,
              onSubmitted: (_) => _load(),
              decoration: InputDecoration(
                hintText: 'Search name / phone / shop...',
                hintStyle: TextStyle(color: textSecondaryColor),
                border: InputBorder.none,
              ),
              style: TextStyle(color: textColor),
            ),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: _load,
            icon: Icon(Icons.arrow_forward, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(
      Color surfaceColor,
      Color textColor,
      Color? textSecondaryColor,
      ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _statusFilter,
                isExpanded: true,
                icon: Icon(Icons.filter_list, color: textSecondaryColor),
                dropdownColor: surfaceColor,
                style: TextStyle(color: textColor),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All status')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                  DropdownMenuItem(value: 'banned', child: Text('Banned')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _statusFilter = v);
                  _load();
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sort,
              icon: Icon(Icons.sort, color: textSecondaryColor),
              dropdownColor: surfaceColor,
              style: TextStyle(color: textColor),
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('Newest')),
                DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _sort = v);
                _load();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(
      BuildContext context,
      Map<String, Object?> u,
      Color surfaceColor,
      Color textColor,
      Color? textSecondaryColor,
      ) {
    final userId = (u['user_id'] as int?) ?? 0;
    final fullName = (u['full_name'] ?? '').toString().trim();
    final phone = (u['phone'] ?? '').toString().trim();
    final shop = (u['shop_name'] ?? '').toString().trim();
    final avatarUrl = (u['avatar_url'] ?? '').toString().trim();
    final status = (u['status'] ?? '').toString().trim();

    final title = fullName.isNotEmpty ? fullName : phone;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        // go to detail, then refresh when back
        await context.push('/admin/users/$userId');
        if (!mounted) return;
        _load();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(
                title.isNotEmpty ? title[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.w900),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shop.isNotEmpty ? '$phone • $shop' : phone,
                    style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: _statusColor(status).withValues(alpha: 0.12),
                border: Border.all(
                  color: _statusColor(status).withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                _statusLabel(status),
                style: TextStyle(
                  color: _statusColor(status),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right, color: textSecondaryColor),
          ],
        ),
      ),
    );
  }
}