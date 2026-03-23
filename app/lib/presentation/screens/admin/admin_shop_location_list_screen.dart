import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';
import 'package:frontend_otis/presentation/bloc/map/map_bloc.dart';
import 'package:frontend_otis/presentation/bloc/map/map_event.dart';
import 'package:frontend_otis/presentation/bloc/map/map_state.dart';

/// Admin Shop Location List Screen for managing shop branches.
///
/// Features:
/// - Header with title and notifications
/// - Search bar for finding shops
/// - Shop list with edit and delete actions
/// - Floating action button for adding new shops
/// - Pull to refresh
/// - Loading, empty, and error states
class AdminShopLocationListScreen extends StatefulWidget {
  const AdminShopLocationListScreen({super.key});

  @override
  State<AdminShopLocationListScreen> createState() => _AdminShopLocationListScreenState();
}

class _AdminShopLocationListScreenState extends State<AdminShopLocationListScreen> {
  late final MapBloc _mapBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<ShopLocation> _allShops = [];
  List<ShopLocation> _filteredShops = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _loadShopLocations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadShopLocations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _mapBloc.add(const LoadShopLocationsEvent());
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredShops = _allShops;
      } else {
        _filteredShops = _allShops.where((shop) {
          return shop.name.toLowerCase().contains(_searchQuery) ||
              shop.address.toLowerCase().contains(_searchQuery) ||
              shop.phone.contains(_searchQuery);
        }).toList();
      }
    });
  }

  Future<void> _confirmDelete(String shopId, String shopName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shop'),
        content: Text('Are you sure you want to delete "$shopName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      _mapBloc.add(DeleteShopLocationEvent(shopId: shopId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Shop Locations'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is ShopLocationsLoaded) {
            setState(() {
              _allShops = state.shopLocations;
              _filteredShops = state.shopLocations;
              _isLoading = false;
            });
          } else if (state is ShopLocationDeleted) {
            _loadShopLocations();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shop deleted successfully')),
            );
          } else if (state is MapError) {
            setState(() {
              _errorMessage = state.message;
              _isLoading = false;
            });
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadShopLocations,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search branches...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Branch count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_filteredShops.length} branches found',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Shop list
              Expanded(
                child: _filteredShops.isEmpty
                    ? const Center(child: Text('No shops found'))
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount: _filteredShops.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final shop = _filteredShops[index];
                          return _ShopLocationListItem(
                            shop: shop,
                            onEdit: () async {
                              await context.push('/admin/shop-locations/${shop.id}/edit');
                              if (mounted) _loadShopLocations();
                            },
                            onDelete: () => _confirmDelete(shop.id, shop.name),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/admin/shop-locations/create');
          if (mounted) _loadShopLocations();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ShopLocationListItem extends StatelessWidget {
  final ShopLocation shop;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ShopLocationListItem({
    required this.shop,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.store, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shop.address,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      shop.phone,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit and delete buttons
          Column(
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.red),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
