import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';
import 'package:frontend_otis/domain/repositories/map_repository.dart';

class ShopLocationsMapScreen extends StatefulWidget {
  const ShopLocationsMapScreen({super.key});

  @override
  State<ShopLocationsMapScreen> createState() => _ShopLocationsMapScreenState();
}

class _ShopLocationsMapScreenState extends State<ShopLocationsMapScreen> {
  final MapRepository _mapRepository = sl<MapRepository>();
  final MapController _mapController = MapController();

  List<ShopLocation>? _shopLocations;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadShops();
  }

  Future<void> _loadShops() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _mapRepository.getShopLocations();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _shopLocations = null;
        _errorMessage = failure.message;
        _isLoading = false;
      }),
      (shops) => setState(() {
        _shopLocations = shops;
        _isLoading = false;
      }),
    );
  }

  void _moveToShop(ShopLocation shop) {
    final target = LatLng(shop.latitude, shop.longitude);
    _mapController.move(target, 15);
  }

  LatLng _defaultCenter() {
    if (_shopLocations != null && _shopLocations!.isNotEmpty) {
      final first = _shopLocations!.first;
      return LatLng(first.latitude, first.longitude);
    }
    return const LatLng(10.8231, 106.6297);
  }

  void _copyToClipboard(ShopLocation shop) {
    final text =
        '${shop.name}\nLat: ${shop.latitude.toStringAsFixed(6)}, Lng: ${shop.longitude.toStringAsFixed(6)}\n${shop.address}\nĐiện thoại: ${shop.phone}';
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép thông tin cửa hàng bao gồm tọa độ')),
    );
  }

  ImageProvider<Object>? _shopImageProvider(ShopLocation shop) {
    final rawPath = shop.imageUrl?.trim();
    if (rawPath == null || rawPath.isEmpty) return null;

    final parsed = Uri.tryParse(rawPath);
    if (parsed != null &&
        parsed.hasScheme &&
        (parsed.scheme == 'http' || parsed.scheme == 'https')) {
      return NetworkImage(rawPath);
    }

    try {
      final file = File(parsed?.isAbsolute == true ? parsed!.toFilePath() : rawPath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    } catch (_) {
      // Ignore failures reading local file.
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _errorMessage != null
              ? _buildErrorContent(context)
              : _buildMapContent(context),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Không thể tải dữ liệu',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Đã có lỗi xảy ra.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _loadShops,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapContent(BuildContext context) {
    final shops = _shopLocations ?? [];
    final center = _defaultCenter();
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
          height: 320,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
              minZoom: 3,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.otis_app',
              ),
              MarkerLayer(
                markers: shops
                    .map(
                      (shop) => Marker(
                        point: LatLng(shop.latitude, shop.longitude),
                        width: 56,
                        height: 110,
                        child: _MapMarker(
                          shop: shop,
                          imageProvider: _shopImageProvider(shop),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: shops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final shop = shops[index];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                tileColor: Theme.of(context).colorScheme.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  shop.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      shop.address,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    SelectableText('Điện thoại: ${shop.phone}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _moveToShop(shop),
                      icon: const Icon(Icons.my_location),
                      color: AppColors.primary,
                    ),
                    IconButton(
                      onPressed: () => _copyToClipboard(shop),
                      icon: const Icon(Icons.copy),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                onTap: () => _moveToShop(shop),
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.shop, required this.imageProvider});

  final ShopLocation shop;
  final ImageProvider<Object>? imageProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (imageProvider != null)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image(
                image: imageProvider!,
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.storefront,
              color: AppColors.primary,
              size: 16,
            ),
          ),
        const SizedBox(height: 4),
        const Icon(
          Icons.location_pin,
          color: AppColors.primary,
          size: 38,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            shop.name,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
