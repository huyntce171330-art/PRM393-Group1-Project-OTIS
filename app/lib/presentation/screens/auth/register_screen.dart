// This screen handles user registration.
//
// Steps to implement:
// 1. Create `StatefulWidget` `RegisterScreen`.
// 2. Create controllers for name, email, password, phone, confirm password.
// 3. Build UI with form fields and "Register" button.
// 4. On button press:
//    - Validate inputs (e.g., passwords match).
//    - Dispatch `RegisterEvent(...)` to `AuthBloc`.
// 5. Listen to `AuthState`:
//    - If `Authenticated`: Navigate to `HomeScreen`.
//    - If `AuthError`: Show snackbar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    final fullName = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || phone.isEmpty || password.isEmpty) {
      _showError(context, 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (password != confirmPassword) {
      _showError(context, 'Mật khẩu không khớp');
      return;
    }

    if (!_acceptedTerms) {
      _showError(context, 'Bạn phải đồng ý điều khoản');
      return;
    }

    context.read<AuthBloc>().add(
      RegisterEvent(
        fullName: fullName,
        phone: phone,
        password: password,
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  _showError(context, state.message);
                }
                if (state is Authenticated) {
                  Navigator.pop(context);
                }
              },
              builder: (context, state) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔴 Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: const [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.tire_repair,
                                size: 40,
                                color: Color(0xFFD32F2F),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'OTIS',
                              style: TextStyle(
                                color: Color(0xFFD32F2F),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Dịch vụ lốp xe & ô tô chuyên nghiệp',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // 🧾 Form
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Text(
                              'Đăng ký tài khoản',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            _input(
                              controller: _fullNameController,
                              label: 'Họ và tên',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 16),

                            _input(
                              controller: _phoneController,
                              label: 'Số điện thoại',
                              icon: Icons.phone_iphone,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),

                            _input(
                              controller: _passwordController,
                              label: 'Mật khẩu',
                              icon: Icons.lock,
                              obscure: true,
                            ),
                            const SizedBox(height: 16),

                            _input(
                              controller: _confirmPasswordController,
                              label: 'Nhập lại mật khẩu',
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptedTerms,
                                  activeColor: const Color(0xFFD32F2F),
                                  onChanged: (v) =>
                                      setState(() => _acceptedTerms = v!),
                                ),
                                Expanded(
                                  child: Text(
                                    'Tôi đồng ý với Điều khoản dịch vụ và Chính sách bảo mật',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFFD32F2F),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: state is AuthLoading
                                    ? null
                                    : () => _register(context),
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : const Text(
                                  'ĐĂNG KÝ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Đã có tài khoản? Đăng nhập ngay',
                                style: TextStyle(
                                  color: Color(0xFFD32F2F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 🔻 Gradient bar
                      Container(
                        height: 6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Color(0xFFD32F2F),
                              Color(0xFFB71C1C),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
