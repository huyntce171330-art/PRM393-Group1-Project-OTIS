import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_bloc.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_state.dart';
import 'package:frontend_otis/presentation/widgets/header_bar.dart';
import 'package:frontend_otis/core/injections/database_helper.dart';
import 'package:frontend_otis/presentation/bloc/auth/auth_event.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _nameController = TextEditingController(text: state.user.fullName);
      _addressController = TextEditingController(text: state.user.address);
      _phoneController = TextEditingController(text: state.user.phone);
    } else {
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: HeaderBar(
        title: 'Update Profile',
        showBack: true,
        backgroundColor: isDarkMode
            ? const Color(0xFF2a1515)
            : Colors.white.withOpacity(0.9),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _buildPhotoSection(context),
                  const SizedBox(height: 24),
                  _buildFormFields(context),
                ],
              ),
            ),
          ),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    String avatarUrl = '';
    if (state is Authenticated) {
      avatarUrl = state.user.avatarUrl;
    }
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode ? const Color(0xFF3a1d1d) : Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrl.isNotEmpty
                      ? avatarUrl
                      : 'https://lh3.googleusercontent.com/aida-public/AB6AXuAMCUeekNgSb6TcXkXThWVg18_gXC-x54JhLCQ-T959hsZMR3nSWR3ujSww43byXOJi2tMYC8rZBqrKu1_I1sd18G7waBmV3mm4O-Fi266NKe4UCZZeoECW2KpRRiW3K1nowgCVrzvBrtNUkCoTHymyUa8Iemgzq-0AZAMzQ4qT8VNBCNBYKaRoiUFSNPuWpn8GyFzYdF_rXZJF-S5u2PS0vB658k6OmCEjT_7IILGijS4Ik6NXvI1Wgq1NYR9mp8ThKE_WarnejUs',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 64),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? const Color(0xFF2a1515) : Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Change Photo',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        _buildTextField(
          label: 'Full Name',
          controller: _nameController,
          placeholder: 'Enter your full name',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Residential Address',
          controller: _addressController,
          placeholder: 'Enter your address',
          isDarkMode: isDarkMode,
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Phone Number',
          controller: _phoneController,
          placeholder: '0XX-XXX-XXXX',
          isDarkMode: isDarkMode,
          icon: Icons.call,
          inputType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isDarkMode,
    IconData? icon,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.grey[200] : const Color(0xFF181111),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF3a1d1d) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? const Color(0xFF553333)
                  : const Color(0xFFe6dbdb),
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: inputType,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : const Color(0xFF181111),
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey[500] : const Color(0xFF896161),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: icon != null
                  ? Icon(
                      icon,
                      color: isDarkMode
                          ? Colors.grey[400]
                          : const Color(0xFF896161),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2a1515) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode ? const Color(0xFF3a1d1d) : Colors.transparent,
          ),
        ),
      ),
      child: SafeArea(
        // Ensure button is safe on iPhone X+
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              final fullName = _nameController.text.trim();
              final address = _addressController.text.trim();
              final phone = _phoneController.text.trim();

              if (fullName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Full Name is required')),
                );
                return;
              }

              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone Number is required')),
                );
                return;
              }

              // 1) xác định userId
              int userId = 2; // demo default
              final state = context.read<AuthBloc>().state;
              if (state is Authenticated) {
                final parsed = int.tryParse(state.user.id.toString());
                if (parsed != null) userId = parsed;
              }

              try {
                // 2) Update DB
                final affected = await DatabaseHelper.updateUserProfile(
                  userId: userId,
                  fullName: fullName,
                  address: address,
                  phone: phone,
                );

                // 3) Query lại DB để kiểm tra
                final row = await DatabaseHelper.getUserById(userId);

                // 4) LOG ra console cho chắc
                // ignore: avoid_print
                print('UPDATE_PROFILE userId=$userId affected=$affected row=$row');

                if (!mounted) return;

                if (affected == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Update FAILED (affected=0). userId=$userId')),
                  );
                  return;
                }

                // 5) Set lại controller từ DB để "nhận thông tin update"
                if (row != null) {
                  _nameController.text = (row['full_name'] ?? '').toString();
                  _addressController.text = (row['address'] ?? '').toString();
                  _phoneController.text = (row['phone'] ?? '').toString();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Updated OK! affected=$affected userId=$userId')),
                );
                final authState = context.read<AuthBloc>().state;
                if (authState is Authenticated) {
                  final updatedUser = authState.user.copyWith(
                    fullName: fullName,
                    address: address,
                    phone: phone,
                  );
                  context.read<AuthBloc>().add(AuthUserUpdated(updatedUser));
                }

                context.pop();
              } catch (e) {
                // ignore: avoid_print
                print('UPDATE_PROFILE ERROR: $e');

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update failed: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
