import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_event.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/usecases/profile/update_user_profile_usecase.dart';
import 'package:frontend_otis/domain/usecases/profile/get_user_by_id_usecase.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/widgets/common/header_bar.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _nameController.text = state.user.fullName;
      _phoneController.text = state.user.phone;
      _addressController.text = state.user.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final fullName = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if (fullName.isEmpty || phone.isEmpty) {
      _showSnackBar('Full name and Phone number cannot be empty', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      int userId = 2; // Default fallback
      final state = context.read<AuthBloc>().state;
      if (state is Authenticated) {
        final parsed = int.tryParse(state.user.id.toString());
        if (parsed != null) userId = parsed;
      }

      // 1) Update DB via UseCase
      final affectedResult = await sl<UpdateUserProfileUseCase>()(
        userId: userId,
        fullName: fullName,
        address: address,
        phone: phone,
      );
      final affected = affectedResult.getOrElse(() => 0);

      // 2) Query back for the latest entity
      final userResult = await sl<GetUserByIdUseCase>()(userId);
      final user = userResult.fold((_) => null, (u) => u);

      if (!mounted) return;

      if (affected == 0) {
        _showSnackBar('Update failed (no changes detected)', isError: true);
        setState(() => _isSubmitting = false);
        return;
      }

      // 3) Sync UI and Bloc
      if (user != null) {
        _nameController.text = user.fullName;
        _addressController.text = user.address;
        _phoneController.text = user.phone;
        context.read<AuthBloc>().add(AuthUserUpdated(user));
      }

      _showSnackBar('Profile updated successfully!');
      context.pop();
    } catch (e) {
      if (mounted) {
        _showSnackBar('An error occurred: $e', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AuthBloc>().state;
    final avatarUrl = (state is Authenticated) ? state.user.avatarUrl : null;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: HeaderBar(
        title: 'Update Profile',
        showBack: true,
        backgroundColor: isDarkMode 
            ? const Color(0xFF1a0c0c).withOpacity(0.95) 
            : Colors.white.withOpacity(0.95),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar Section
            _buildAvatarSection(isDarkMode, avatarUrl),
            const SizedBox(height: 30),
            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: 'Address',
                      controller: _addressController,
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 40),
                    _buildUpdateButton(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(bool isDarkMode, String? avatarUrl) {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Icon(Icons.person, size: 60, color: isDarkMode ? Colors.grey[600] : Colors.grey[400])
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // Future: Pick image
                _showSnackBar('Photo selection feature will be available soon');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isDarkMode = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: isDarkMode ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
            filled: true,
            fillColor: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
