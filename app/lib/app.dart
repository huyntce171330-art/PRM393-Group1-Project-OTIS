import 'package:flutter/material.dart';
import 'presentation/screens/home_screen.dart';


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
      home: HomeScreen(),

    );
  }
}
