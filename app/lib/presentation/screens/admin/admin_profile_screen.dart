import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_event.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:go_router/go_router.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF101622)
        : const Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const HeaderBar(title: 'Admin Profile', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(context, isDarkMode),
            const SizedBox(height: 48),
            _buildLogoutButton(context, isDarkMode),
            const SizedBox(height: 24),
            Text(
              'Otis Admin Panel v1.0.0',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkMode ? const Color(0xFF2a1a1b) : Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD8YWidUUkqIitQsKH0Xj1BREkpvbhijdepzuqA_Da7KY6sVqLLfwQgwKUF9ajSgmIMnTK0j4b0lW5CkUPGvtwFsjNt2kHd8yr7_dEwL5bx51eY3jU3_u31A2YSvWEFA00LNez6c73az5gA1bCFT0EEn4VjFiJVlHZn88Ebl-X_XiKkoFtdil-UCs5KFqAl7wEnKq8OLGx60Cizj1NUiG97bPDbHHbp5LaKFDQzgFSHOcwQW9yHMP5fpRLrvtR7YpdR7Wd2dLwd7G4',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Thai Phung',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Administrator',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutEvent());
          context.go('/login');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: isDarkMode ? const Color(0xFF2a1a1b) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
