import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_client.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/presentation/screens/product_list_screen.dart';

class OtisApp extends StatelessWidget {
  const OtisApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection (simplified for MVP)
    final httpClient = http.Client();
    final apiClient = ApiClient(client: httpClient);
    final remoteDataSource = ProductRemoteDataSourceImpl(apiClient: apiClient);
    final productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return MaterialApp(
      title: 'OTIS Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductListScreen(repository: productRepository),
      debugShowCheckedModeBanner: false,
    );
  }
}
