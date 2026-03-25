import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/utils/ui_utils.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptedTerms = false;
  String? _serverError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    setState(() => _serverError = null);
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        setState(() => _serverError = 'You must agree to the Terms of Service');
        return;
      }

      context.read<AuthBloc>().add(
            RegisterEvent(
              fullName: _fullNameController.text.trim(),
              phone: _phoneController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
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
                  setState(() => _serverError = state.message);
                }
                if (state is Authenticated) {
                  UiUtils.showSuccessPopup(context, "Registration successful!");
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  });
                }
              },
              builder: (context, state) {
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
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
                                'Professional Tire & Auto Service',
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
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_serverError != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    _serverError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 13),
                                  ),
                                ),

                              _input(
                                controller: _fullNameController,
                                label: 'Full Name',
                                icon: Icons.person,
                                validator: (val) => val == null || val.isEmpty ? 'Name cannot be empty' : null,
                              ),
                              const SizedBox(height: 16),

                              _input(
                                controller: _phoneController,
                                label: 'Phone Number',
                                icon: Icons.phone_iphone,
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Enter phone number';
                                  if (val.length < 10) return 'Invalid phone number';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              _input(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock,
                                obscure: true,
                                validator: (val) => val == null || val.length < 6 ? 'Password min 6 chars' : null,
                              ),
                              const SizedBox(height: 16),

                              _input(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                icon: Icons.lock_outline,
                                obscure: true,
                                validator: (val) {
                                  if (val != _passwordController.text) return 'Passwords do not match';
                                  return null;
                                },
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
                                      'I agree to the Terms of Service and Privacy Policy',
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
                                      ? const SizedBox(
                                          height: 20, width: 20,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text(
                                          'REGISTER',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Already have an account? Sign In',
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
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
