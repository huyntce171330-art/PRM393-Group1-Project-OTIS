import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/domain/entities/shop_location.dart';
import 'package:frontend_otis/presentation/bloc/map/map_bloc.dart';
import 'package:frontend_otis/presentation/bloc/map/map_event.dart';
import 'package:frontend_otis/presentation/bloc/map/map_state.dart';
import 'package:frontend_otis/presentation/screens/map/map_picker_screen.dart';

/// Admin Shop Location Form Screen for creating/editing shop locations.
/// 
/// Features:
/// - Form: fields Name, Phone, Address
/// - Map picker for location selection
/// - Image upload for storefront
/// - Validation
class AdminShopLocationFormScreen extends StatefulWidget {
  final String? shopId; // null = create mode, non-null = edit mode

  const AdminShopLocationFormScreen({
    super.key,
    this.shopId,
  });

  @override
  State<AdminShopLocationFormScreen> createState() => _AdminShopLocationFormScreenState();
}

class _AdminShopLocationFormScreenState extends State<AdminShopLocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Location state
  double? _latitude;
  double? _longitude;
  String? _imageUrl;
  Uint8List? _pickedImageBytes;
  final ImagePicker _imagePicker = ImagePicker();

  bool _isEditMode = false;
  ShopLocation? _existingShop;
  bool _formPopulated = false; // Chỉ điền form một lần khi edit, tránh ghi đè khi user đang sửa

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.shopId != null;
    if (_isEditMode) {
      _loadExistingShop();
    }
  }

  void _loadExistingShop() {
    context.read<MapBloc>().add(LoadShopLocationByIdEvent(shopId: widget.shopId!));
  }

  void _populateForm(ShopLocation shop) {
    if (_formPopulated) return; // Đã điền rồi thì không ghi đè (để user có thể xóa/sửa)
    _formPopulated = true;
    _nameController.text = shop.name;
    _phoneController.text = shop.phone;
    _addressController.text = shop.address;
    _latitude = shop.latitude;
    _longitude = shop.longitude;
    _imageUrl = shop.imageUrl;
    _pickedImageBytes = null;
    _existingShop = shop;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation() async {
    // Open map screen for location selection
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
        ),
      ),
    );
    
    if (result != null && mounted) {
      setState(() {
        _latitude = result['latitude'] as double?;
        _longitude = result['longitude'] as double?;
        final address = result['address'] as String?;
        if (address != null && address.isNotEmpty) {
          _addressController.text = address;
        }
      });
    }
  }
 
  Future<void> _showImageSourceActionSheet() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Use Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      await _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1400,
        maxHeight: 1400,
        imageQuality: 85,
      );
      if (pickedFile == null || !mounted) return;
      final bytes = await pickedFile.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pickedImageBytes = bytes;
        _imageUrl = pickedFile.path;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể chọn ảnh: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  ImageProvider<Object>? _getPreviewImageProvider() {
    if (_pickedImageBytes != null) {
      return MemoryImage(_pickedImageBytes!);
    }

    if (_imageUrl == null || _imageUrl!.trim().isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(_imageUrl!);
    if (uri != null && uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return NetworkImage(_imageUrl!);
    }

    return null;
  }

  Widget _buildImageUploadContent() {
    final previewImage = _getPreviewImageProvider();
    if (previewImage != null) {
      return _buildImagePreview(previewImage);
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.camera_alt, size: 36, color: AppColors.primary),
        SizedBox(height: 8),
        Text('Upload Photo'),
        SizedBox(height: 4),
        Text(
          'PNG, JPG up to 5MB',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildImagePreview(ImageProvider<Object> provider) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.35),
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Center(
            child: Text(
              'Tap to change photo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set store location on map'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final now = DateTime.now();
    final shopLocation = ShopLocation(
      id: _existingShop?.id ?? '',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _latitude!,
      longitude: _longitude!,
      imageUrl: _imageUrl,
      isActive: true,
      createdAt: _existingShop?.createdAt ?? now,
      updatedAt: _isEditMode ? now : null,
    );

    if (_isEditMode) {
      context.read<MapBloc>().add(
        UpdateShopLocationEvent(
          shopId: widget.shopId!,
          shopLocation: shopLocation,
        ),
      );
    } else {
      context.read<MapBloc>().add(
        CreateShopLocationEvent(shopLocation: shopLocation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Store' : 'Add New Store'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
      ),
      body: BlocListener<MapBloc, MapState>(
        listener: (context, state) {
          if (state is ShopLocationCreated || state is ShopLocationUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditMode
                      ? 'Store updated successfully'
                      : 'Store created successfully',
                ),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          } else if (state is MapError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
        },
        child: BlocBuilder<MapBloc, MapState>(
          buildWhen: (previous, current) =>
              current is ShopLocationDetailLoaded && !_formPopulated,
          builder: (context, state) {
            if (state is ShopLocationDetailLoaded && !_formPopulated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_formPopulated) _populateForm(state.shopLocation);
              });
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Name
                    const Text(
                      'Store Name',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Thai Phung Central Branch',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Store name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact Phone (SĐT) - digits only
                    const Text(
                      'Contact Phone',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: InputDecoration(
                        hintText: 'e.g. 0332049654',
                        prefixIcon: const Icon(Icons.phone),
                        filled: true,
                        fillColor: Colors.white,
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        final digits = value.replaceAll(RegExp(r'\D'), '');
                        if (digits.length < 10 || digits.length > 11) {
                          return 'Số điện thoại phải 10-11 chữ số';
                        }
                        if (!RegExp(r'^0\d{9,10}$').hasMatch(digits)) {
                          return 'Số điện thoại không hợp lệ (ví dụ: 0332049654)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Full Address
                    const Text(
                      'Full Address',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      minLines: 2,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter street address, district, and city',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Store Location
                    Row(
                      children: const [
                        Text(
                          'Store Location',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Chip(
                          label: Text('Required'),
                          backgroundColor: Color(0xFFEFF1F4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Map picker container
                    GestureDetector(
                      onTap: _selectLocation,
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: _latitude == null
                              ? Border.all(color: Colors.red.withOpacity(0.4))
                              : null,
                        ),
                        child: _latitude != null && _longitude != null
                            ? _buildSelectedLocationView()
                            : _buildLocationPickerPrompt(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Storefront Photo
                    const Text(
                      'Storefront Photo',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _showImageSourceActionSheet,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                          color: Colors.grey[50],
                        ),
                        child: _buildImageUploadContent(),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onSubmit,
                        icon: const Icon(Icons.save),
                        label: Text(_isEditMode ? 'Update Store' : 'Save Store'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationPickerPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_location_alt, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _selectLocation,
            icon: const Icon(Icons.map),
            label: const Text('Set Location on Map'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedLocationView() {
    return Stack(
      children: [
        // Map placeholder (would be actual map in production)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blue.withOpacity(0.1),
          ),
          child: const Center(
            child: Icon(
              Icons.map,
              size: 64,
              color: Colors.blue,
            ),
          ),
        ),
        // Overlay gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.15),
            ),
          ),
        ),
        // Location info
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lat: ${_latitude!.toStringAsFixed(6)}, Lng: ${_longitude!.toStringAsFixed(6)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _selectLocation,
                      icon: const Icon(Icons.edit, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
