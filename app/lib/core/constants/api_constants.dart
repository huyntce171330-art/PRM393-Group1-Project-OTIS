// This file contains API endpoint constants.

class ApiConstants {
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Assuming standard local server port 3000
  static const String productsEndpoint = '/products';
  static const String cartEndpoint = '/cart';
  static const String ordersEndpoint = '/orders';
}
