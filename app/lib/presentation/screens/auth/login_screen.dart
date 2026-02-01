// This screen handles user login.
//
// Steps to implement:
// 1. Create `StatefulWidget` `LoginScreen`.
// 2. Create `TextEditingController` for email and password.
// 3. Build UI with fields and a "Login" button.
// 4. On button press:
//    - Dispatch `LoginEvent(email, password)` to `AuthBloc`.
// 5. Use `BlocListener<AuthBloc, AuthState>`:
//    - If `Authenticated`: Navigate to `HomeScreen`.
//    - If `AuthError`: Show snackbar.
// 6. Add a "Register" button (TextButton) to navigate to `RegisterScreen`.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../core/injections/auth_injection.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthInjection.provideAuthBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              if (state is Authenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              }
            },

            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 24),
                    _buildLoginButton(context, state),
                    const SizedBox(height: 16),
                    _buildRegisterButton(context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: const [
        Icon(Icons.tire_repair, size: 64, color: Colors.red),
        SizedBox(height: 12),
        Text(
          'THAI PHUNG',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('Dịch vụ lốp & chăm sóc xe'),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email hoặc số điện thoại',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock_outline),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state is AuthLoading
            ? null
            : () {
          // STEP 1: DEBUG — confirm button press
          print('LOGIN CLICKED: ${_emailController.text}');

          context.read<AuthBloc>().add(
            LoginEvent(
              phone: _emailController.text,
              password: _passwordController.text,
            ),
          );
        },
        child: state is AuthLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('ĐĂNG NHẬP'),
      ),
    );
  }


  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to RegisterScreen
      },
      child: const Text('Chưa có tài khoản? Đăng ký'),
    );
  }
}
