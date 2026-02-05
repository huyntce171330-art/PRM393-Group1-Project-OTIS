import 'package:flutter/material.dart';
import 'package:frontend_otis/presentation/screens/home_screen.dart';
import 'package:frontend_otis/presentation/screens/product/product_list_screen.dart';

class OtisApp extends StatelessWidget {
  const OtisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection (simplified for MVP)
    return MaterialApp(
      title: 'OTIS Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Home screen
      home: const HomeScreen(),
      // Routes
      routes: {
        '/product-list': (_) => const ProductListScreen(),
      },
    );
  }
}
