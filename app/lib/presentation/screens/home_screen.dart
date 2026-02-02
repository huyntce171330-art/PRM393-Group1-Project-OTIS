import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../../core/injections/auth_injection.dart';
import '../screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthInjection.provideAuthBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTIS Home'),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return _authenticatedView(context);
            }

            return _unauthenticatedView(context);
          },
        ),
      ),
    );
  }

  Widget _unauthenticatedView(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AuthBloc>(),
                child: const LoginScreen(),
              ),
            ),
          );
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget _authenticatedView(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutEvent());
        },
        child: const Text('Logout'),
      ),
    );
  }
}
