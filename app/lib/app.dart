import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injections/injection_container.dart' as di;
import 'presentation/screens/home_screen.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

class OtisApp extends StatelessWidget {
  const OtisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp(
        title: 'OTIS Project',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
