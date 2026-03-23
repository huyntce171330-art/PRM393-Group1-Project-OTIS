import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

/// Map Picker Screen - Allows user to select a location on the map.
/// Returns the selected latitude and longitude when user confirms.
/// Uses flutter_map with OpenStreetMap tiles - no API key required.
/// Includes Nominatim geocoding for location search.
class MapPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _NominatimResult {
  final String displayName;
  final double lat;
  final double lon;

  const _NominatimResult({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory _NominatimResult.fromJson(Map<String, dynamic> json) {
    return _NominatimResult(
      displayName: json['display_name'] as String,
      lat: double.parse(json['lat'] as String),
      lon: double.parse(json['lon'] as String),
    );
  }
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Default location: Ho Chi Minh City
  static const _defaultLat = 10.8231;
  static const _defaultLng = 106.6297;

  late LatLng _selectedLocation;
  String? _selectedAddress;
  bool _isLoadingAddress = false;

  // Search state
  List<_NominatimResult> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;
  String? _searchError;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(
      widget.initialLatitude ?? _defaultLat,
      widget.initialLongitude ?? _defaultLng,
    );

    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus && _showResults) {
        setState(() => _showResults = false);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    _searchFocusNode.unfocus();
    setState(() {
      _selectedLocation = point;
      _selectedAddress = null;
      _isLoadingAddress = true;
      _showResults = false;
      _searchError = null;
    });
    _reverseGeocode(point.latitude, point.longitude);
  }

  Future<void> _reverseGeocode(double lat, double lon) async {
    try {
      final uri = Uri(
        scheme: 'https',
        host: 'nominatim.openstreetmap.org',
        path: '/reverse',
        queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'format': 'json',
        },
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'OTIS-App/1.0'},
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final address = data['display_name'] as String?;
        if (address != null && address.isNotEmpty) {
          setState(() {
            _selectedAddress = _formatAddress(address);
            _isLoadingAddress = false;
          });
        } else {
          setState(() => _isLoadingAddress = false);
        }
      } else {
        setState(() => _isLoadingAddress = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingAddress = false);
    }
  }

  /// Returns the full address as-is for precise display (street, ward, district, city, etc.).
  String _formatAddress(String fullAddress) {
    return fullAddress.trim();
  }

  void _confirmLocation() {
    Navigator.of(context).pop({
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'address': _selectedAddress,
    });
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().length < 2) {
      setState(() {
        _searchResults = [];
        _showResults = false;
        _isSearching = false;
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;
    // Capture query at the time of the call to prevent stale results
    final currentQuery = query;
    try {
      final uri = Uri(
        scheme: 'https',
        host: 'nominatim.openstreetmap.org',
        path: '/search',
        queryParameters: {
          'q': currentQuery,
          'format': 'json',
          'limit': '6',
          'addressdetails': '1',
          'accept-language': 'vi,en',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'OtisApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      // Discard result if user has already typed something different
      if (_searchController.text.trim() != currentQuery &&
          _searchController.text.trim().isNotEmpty) return;

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        setState(() {
          _searchResults = data
              .map((e) => _NominatimResult.fromJson(e as Map<String, dynamic>))
              .toList();
          _showResults = true; // always show panel (empty or not)
          _isSearching = false;
          _searchError = null;
        });
      } else {
        setState(() {
          _isSearching = false;
          _searchError = 'Server error (${response.statusCode})';
          _showResults = true;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchError = 'Request timed out. Check your connection.';
          _showResults = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchError = 'Could not reach search service.';
          _showResults = true;
        });
        if (kDebugMode) debugPrint('Nominatim error: $e');
      }
    }
  }

  void _selectSearchResult(_NominatimResult result) {
    final point = LatLng(result.lat, result.lon);
    _debounceTimer?.cancel();
    _searchFocusNode.unfocus();
    setState(() {
      _selectedLocation = point;
      _selectedAddress = _formatAddress(result.displayName);
      _isLoadingAddress = false;
      _showResults = false;
      _searchError = null;
      _searchResults = [];
      _searchController.text = result.displayName;
    });
    // Move the map after the current frame finishes rebuilding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mapController.move(point, 16);
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showResults = false;
      _isSearching = false;
      _searchError = null;
    });
    _searchFocusNode.unfocus();
  }

  Widget _buildSearchStatus({
    required IconData icon,
    required Color color,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.otis_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Search bar + results overlay
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Column(
              children: [
                // Search input card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: false,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (v) {
                      _debounceTimer?.cancel();
                      if (v.trim().length >= 2) _performSearch(v.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: _clearSearch,
                                )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                // Results / empty / error panel
                if (_showResults)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _searchError != null
                          ? _buildSearchStatus(
                              icon: Icons.wifi_off_rounded,
                              color: Colors.orange,
                              message: _searchError!,
                            )
                          : _searchResults.isEmpty
                              ? _buildSearchStatus(
                                  icon: Icons.search_off,
                                  color: Colors.grey,
                                  message: 'No results found',
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: _searchResults.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final result = _searchResults[index];
                                    return ListTile(
                                      leading: const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                        size: 22,
                                      ),
                                      title: Text(
                                        result.displayName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      onTap: () =>
                                          _selectSearchResult(result),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
              ],
            ),
          ),

          // Instruction hint (tap to pin)
          if (!_showResults)
            Positioned(
              top: 80,
              left: 16,
              right: 16,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Search or tap on the map to pin location',
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Selected location display (address or coordinates)
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Selected Location',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _isLoadingAddress
                            ? const Text(
                                'Loading address...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                              )
                            : Text(
                                _selectedAddress ??
                                    'Lat: ${_selectedLocation.latitude.toStringAsFixed(5)}, Lng: ${_selectedLocation.longitude.toStringAsFixed(5)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmLocation,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.check),
        label: const Text('Confirm Location'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
