import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Use 10.0.2.2 for Android Emulator to access localhost of the host machine.
  // Use localhost or your IP if running on Web or iOS simulator.
  // Since we are likely on emulator:
  static const String baseUrl = 'http://10.0.2.2:3000';

  final http.Client client;

  ApiClient({required this.client});

  Future<dynamic> get(String path) async {
    final response = await client.get(Uri.parse('$baseUrl$path'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
