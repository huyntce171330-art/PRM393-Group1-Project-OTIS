import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_otis/core/utils/ui_utils.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'reset_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool otpPhase = false;
  String? _serverError;

  static const int _resendCooldown = 60;
  int _secondsLeft = _resendCooldown;
  Timer? _timer;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timerText {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onRequestOtp() {
    setState(() => _serverError = null);
    if (phoneController.text.trim().length < 10) {
      setState(() => _serverError = 'Invalid phone number');
      return;
    }
    context.read<AuthBloc>().add(
      RequestOtpEvent(
        phone: phoneController.text.trim(),
      ),
    );
  }

  void _onVerifyOtp() {
    setState(() => _serverError = null);
    if (otpController.text.length < 6) {
      setState(() => _serverError = 'Please enter 6-digit OTP');
      return;
    }
    context.read<AuthBloc>().add(
      VerifyOtpEvent(
        phone: phoneController.text.trim(),
        otp: otpController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 375),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                setState(() => _serverError = state.message);
              }

              if (state is OtpSent) {
                UiUtils.showSuccessPopup(context, "OTP has been sent to your phone");
                setState(() => otpPhase = true);
                _startResendTimer();
              }

              if (state is OtpVerified) {
                UiUtils.showSuccessPopup(context, "Verification successful!");
                Future.delayed(const Duration(milliseconds: 1000), () {
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: ResetPasswordScreen(
                            phone: phoneController.text.trim(),
                          ),
                        ),
                      ),
                    );
                  }
                });
              }
            },
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildAppBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            if (_serverError != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  _serverError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: otpPhase
                                  ? _buildOtpSection(state)
                                  : _buildPhoneSection(state),
                            ),
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
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildPhoneSection(AuthState state) {
    return Column(
      key: const ValueKey('phone'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Don't worry! It happens to the best of us.",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please enter the phone number associated with your account.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),

        const Text(
          'Phone Number',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration('ex: 0901234567'),
        ),

        const SizedBox(height: 32),
        _primaryButton(
          text: 'Send OTP',
          loading: state is AuthLoading,
          onTap: _onRequestOtp,
        ),
      ],
    );
  }

  Widget _buildOtpSection(AuthState state) {
    return Column(
      key: const ValueKey('otp'),
      children: [
        const Text(
          'OTP Verification',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter the 6-digit code sent to your device',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '● ● ● ● ● ●',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        const SizedBox(height: 24),
        _primaryButton(
          text: 'Verify OTP',
          loading: state is AuthLoading,
          onTap: _onVerifyOtp,
        ),

        const SizedBox(height: 16),

        TextButton(
          onPressed: _secondsLeft == 0 ? _onRequestOtp : null,
          child: Text(
            _secondsLeft == 0
                ? 'Resend OTP'
                : 'Resend in $_timerText',
            style: TextStyle(
              color: _secondsLeft == 0 ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEC1313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: loading ? null : onTap,
        child: loading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
