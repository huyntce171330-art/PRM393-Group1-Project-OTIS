// Implementation of NetworkInfo using connectivity_plus.
//
// This implementation checks actual network connectivity.
// Replace with mock for testing.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:frontend_otis/core/network/network_info.dart';

/// Implementation of [NetworkInfo] using connectivity_plus.
///
/// Checks actual network connectivity status.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
