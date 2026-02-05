// This file handles network connectivity checks.
//
// Steps:
// 1. Define an abstract class `NetworkInfo`.
// 2. Define a method `Future<bool> get isConnected;`.
// 3. Implement it using `internet_connection_checker` or `connectivity_plus`.

/// Abstract interface for network connectivity checks.
/// Used to determine if the device has an active internet connection.
abstract class NetworkInfo {
  /// Returns true if device is connected to the internet.
  Future<bool> get isConnected;
}
