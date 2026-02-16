// Screen to edit an existing product.
//
// Features:
// - Form with validation for all product fields
// - Pre-fill existing product data
// - Basic info: name, SKU (read-only), price, stock
// - Category & Brand selection
// - Tire specifications
// - Image URL with preview
// - Active status toggle
// - Submit with loading state
// - Error handling with snackbar
// - Discard confirmation dialog
//
// Follows the Thai Phung design system and Clean Architecture pattern.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/data/models/brand_model.dart';
import 'package:frontend_otis/data/models/product_model.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/product.dart';
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_vehicle_makes_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/create_vehicle_make_usecase.dart';
import 'package:frontend_otis/domain/usecases/product/get_product_detail_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';

/// Screen to edit an existing product.
///
/// Follows the Thai Phung design system and Clean Architecture pattern.
/// Uses BLoC for state management.
class AdminEditProductScreen extends StatefulWidget {
  final String productId;

  const AdminEditProductScreen({
    super.key,
    required this.productId,
  });

  @override
  State<AdminEditProductScreen> createState() =>
      _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _aspectRatioController = TextEditingController();
  final TextEditingController _rimController = TextEditingController();

  // Dropdown values
  BrandModel? _selectedBrand;
  VehicleMakeModel? _selectedVehicleMake;

  // Toggle value
  bool _isActive = true;

  // Loading state
  bool _isSubmitting = false;
  bool _isLoading = true;
  String? _loadingError;

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _skuFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _stockFocus = FocusNode();

  // Lists for dropdowns
  List<BrandModel> _brands = [];
  List<VehicleMakeModel> _vehicleMakes = [];

  // Original product entity for comparison
  Product? _originalProductEntity;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadingError = null;
    });

    try {
      // Load brands first
      final getBrandsUsecase = GetBrandsUsecase(productRepository: sl());
      final getVehicleMakesUsecase = GetVehicleMakesUsecase(productRepository: sl());
      final brandsResult = await getBrandsUsecase();
      final vehicleMakesResult = await getVehicleMakesUsecase();

      if (!mounted) return;

      // Handle brands
      brandsResult.fold(
        (failure) {
          print('DEBUG: Failed to load brands: $failure');
        },
        (brands) {
          if (mounted) {
            setState(() => _brands = brands);
          }
        },
      );

      // Handle vehicle makes
      vehicleMakesResult.fold(
        (failure) {
          print('DEBUG: Failed to load vehicle makes: $failure');
        },
        (vehicleMakes) {
          if (mounted) {
            setState(() => _vehicleMakes = vehicleMakes);
          }
        },
      );

      // Then load product detail
      final getProductDetailUsecase = GetProductDetailUsecase(productRepository: sl());
      final productResult = await getProductDetailUsecase(widget.productId);

      if (!mounted) return;

      // Handle product detail
      productResult.fold(
        (failure) {
          setState(() {
            _loadingError = failure.message;
            _isLoading = false;
          });
        },
        (product) {
          if (mounted) {
            _populateForm(product);
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingError = 'Có lỗi xảy ra: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _populateForm(Product product) {
    // Store product entity for comparison
    _originalProductEntity = product;
    
    _nameController.text = product.name;
    _skuController.text = product.sku;
    _priceController.text = product.price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    ) + ' đ';
    _stockController.text = product.stockQuantity.toString();
    _imageUrlController.text = product.imageUrl;
    _widthController.text = product.tireSpec?.width != null && product.tireSpec!.width > 0 
        ? product.tireSpec!.width.toString() 
        : '';
    _aspectRatioController.text = product.tireSpec?.aspectRatio != null && product.tireSpec!.aspectRatio > 0 
        ? product.tireSpec!.aspectRatio.toString() 
        : '';
    _rimController.text = product.tireSpec?.rimDiameter != null && product.tireSpec!.rimDiameter > 0 
        ? product.tireSpec!.rimDiameter.toString() 
        : '';
    _isActive = product.isActive;

    // Find matching brand
    final brandId = product.brand?.id;
    if (brandId != null) {
      for (final brand in _brands) {
        if (brand.id == brandId) {
          _selectedBrand = brand;
          break;
        }
      }
    }

    // Find matching vehicle make
    final vehicleMakeId = product.vehicleMake?.id;
    if (vehicleMakeId != null) {
      for (final make in _vehicleMakes) {
        if (make.id == vehicleMakeId) {
          _selectedVehicleMake = make;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _widthController.dispose();
    _aspectRatioController.dispose();
    _rimController.dispose();
    _nameFocus.dispose();
    _skuFocus.dispose();
    _priceFocus.dispose();
    _stockFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên sản phẩm là bắt buộc';
    }
    if (value.trim().length < 2) {
      return 'Tên sản phẩm phải có ít nhất 2 ký tự';
    }
    if (value.trim().length > 200) {
      return 'Tên sản phẩm không được quá 200 ký tự';
    }
    return null;
  }

  String? _validateSku(String? value) {
    // SKU is read-only in edit mode, so we don't validate
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giá là bắt buộc';
    }
    // Remove all non-digit characters (including , . đ VND)
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) {
      return 'Giá không hợp lệ';
    }
    final price = double.tryParse(cleanValue);
    if (price == null || price <= 0) {
      return 'Giá phải lớn hơn 0';
    }
    if (price > 999999999) {
      return 'Giá không được vượt quá 999,999,999 VND';
    }
    return null;
  }

  String? _validateStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số lượng tồn kho là bắt buộc';
    }
    final stock = int.tryParse(value);
    if (stock == null) {
      return 'Số lượng phải là số nguyên';
    }
    if (stock < 0) {
      return 'Số lượng không được âm';
    }
    if (stock > 999999) {
      return 'Số lượng không được vượt quá 999,999';
    }
    return null;
  }

  String? _validateBrand(BrandModel? value) {
    if (value == null) {
      return 'Vui lòng chọn thương hiệu';
    }
    return null;
  }

  String? _validateWidth(String? value) {
    // If this field has a value, always validate the range
    if (value != null && value.isNotEmpty) {
      final width = int.tryParse(value);
      if (width == null) {
        return 'Chiều rộng phải là số';
      }
      if (width < 145 || width > 455) {
        return 'Chiều rộng phải từ 145 đến 455 mm';
      }
    }
    // If empty and other tire specs are filled, this field is required
    if (value == null || value.isEmpty) {
      final aspectFilled = _aspectRatioController.text.trim().isNotEmpty;
      final rimFilled = _rimController.text.trim().isNotEmpty;
      if (aspectFilled || rimFilled) {
        return 'Chiều rộng là bắt buộc khi nhập thông số lốp';
      }
    }
    return null;
  }

  String? _validateAspectRatio(String? value) {
    // If this field has a value, always validate the range
    if (value != null && value.isNotEmpty) {
      final ratio = int.tryParse(value);
      if (ratio == null) {
        return 'Tỷ lệ aspect phải là số';
      }
      if (ratio < 20 || ratio > 95) {
        return 'Tỷ lệ aspect phải từ 20% đến 95%';
      }
    }
    // If empty and other tire specs are filled, this field is required
    if (value == null || value.isEmpty) {
      final widthFilled = _widthController.text.trim().isNotEmpty;
      final rimFilled = _rimController.text.trim().isNotEmpty;
      if (widthFilled || rimFilled) {
        return 'Tỷ lệ aspect là bắt buộc khi nhập thông số lốp';
      }
    }
    return null;
  }

  String? _validateRim(String? value) {
    // If this field has a value, always validate the range
    if (value != null && value.isNotEmpty) {
      final rim = int.tryParse(value);
      if (rim == null) {
        return 'Đường kính mâm phải là số';
      }
      if (rim < 10 || rim > 30) {
        return 'Đường kính mâm phải từ 10 đến 30 inch';
      }
    }
    // If empty and other tire specs are filled, this field is required
    if (value == null || value.isEmpty) {
      final widthFilled = _widthController.text.trim().isNotEmpty;
      final aspectFilled = _aspectRatioController.text.trim().isNotEmpty;
      if (widthFilled || aspectFilled) {
        return 'Đường kính mâm là bắt buộc khi nhập thông số lốp';
      }
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    // Check for missing protocol first
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      return 'URL phải bắt đầu bằng http:// hoặc https://';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || !uri.isAbsolute) {
      return 'URL hình ảnh không hợp lệ';
    }
    if (!['http', 'https'].contains(uri.scheme)) {
      return 'URL phải bắt đầu bằng http:// hoặc https://';
    }
    return null;
  }

  void _onPriceChanged(String value) {
    // Remove all non-digit characters
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _priceController.value = const TextEditingValue(text: '');
      return;
    }

    // Parse safely with tryParse
    final number = int.tryParse(digits) ?? 0;
    final formatted = number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    _priceController.value = TextEditingValue(
      text: '$formatted đ',
      selection: TextSelection.collapsed(
        offset: formatted.length + 2, // +2 for " đ"
      ),
    );
  }

  bool _hasChanges() {
    if (_originalProductEntity == null) return false;

    final currentName = _nameController.text.trim();
    final currentPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final currentStock = _stockController.text.trim();
    final currentImageUrl = _imageUrlController.text.trim();
    final currentWidth = _widthController.text.trim();
    final currentAspectRatio = _aspectRatioController.text.trim();
    final currentRim = _rimController.text.trim();
    final original = _originalProductEntity!;

    return currentName != original.name ||
        currentPrice != original.price.toInt().toString() ||
        currentStock != original.stockQuantity.toString() ||
        currentImageUrl != original.imageUrl ||
        currentWidth != (original.tireSpec?.width != null && original.tireSpec!.width > 0 
            ? original.tireSpec!.width.toString() 
            : '') ||
        currentAspectRatio != (original.tireSpec?.aspectRatio != null && original.tireSpec!.aspectRatio > 0 
            ? original.tireSpec!.aspectRatio.toString() 
            : '') ||
        currentRim != (original.tireSpec?.rimDiameter != null && original.tireSpec!.rimDiameter > 0 
            ? original.tireSpec!.rimDiameter.toString() 
            : '') ||
        _isActive != original.isActive ||
        (_selectedBrand?.id != original.brand?.id) ||
        (_selectedVehicleMake?.id != original.vehicleMake?.id);
  }

  Future<bool> _showDiscardDialog() async {
    if (!_hasChanges()) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy thay đổi?'),
        content: const Text(
          'Bạn có thay đổi chưa lưu. Bạn có chắc muốn hủy bỏ không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Hủy bỏ'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _focusInvalidField();
      return;
    }

    // Check for changes
    if (!_hasChanges()) {
      _showErrorSnackBar('Không có thay đổi để lưu');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Create ProductModel from form data
      final productModel = ProductModel(
        id: widget.productId,
        sku: _skuController.text.trim(),
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        brand: _selectedBrand!,
        vehicleMake: _selectedVehicleMake ?? VehicleMakeModel(id: '', name: '', logoUrl: ''),
        tireSpec: TireSpecModel(
          id: _originalProductEntity?.tireSpec?.id ?? '',
          width: int.tryParse(_widthController.text.trim()) ?? 0,
          aspectRatio: int.tryParse(_aspectRatioController.text.trim()) ?? 0,
          rimDiameter: int.tryParse(_rimController.text.trim()) ?? 0,
        ),
        price: double.parse(
          _priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ),
        stockQuantity: int.parse(_stockController.text.trim()),
        isActive: _isActive,
        createdAt: _originalProductEntity?.createdAt ?? DateTime.now(),
      );

      // Dispatch event to Bloc
      context.read<AdminProductBloc>().updateProduct(widget.productId, productModel);
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorSnackBar('Có lỗi xảy ra: $e');
    }
  }

  void _focusInvalidField() {
    // Find first invalid field and request focus
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cập nhật sản phẩm thành công!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showAddVehicleMakeDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm hãng xe mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tên hãng xe',
            hintText: 'Nhập tên hãng xe',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );

    if (result != null) {
      // Create new VehicleMakeModel in database
      final createVehicleMakeUsecase = CreateVehicleMakeUsecase(productRepository: sl());
      final createResult = await createVehicleMakeUsecase(name: result);

      createResult.fold(
        (failure) {
          // Show error if creation failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi tạo hãng xe: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (newMake) {
          // Success - add to list and select
          setState(() {
            _vehicleMakes.add(newMake);
            _selectedVehicleMake = newMake;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_loadingError != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _loadingError!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldDiscard = await _showDiscardDialog();
            if (shouldDiscard && mounted) {
              context.pop();
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () async {
          final shouldDiscard = await _showDiscardDialog();
          if (shouldDiscard) {
            context.pop();
          }
        },
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
      ),
      title: const Text(
        'Chỉnh sửa sản phẩm',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody() {
    return BlocListener<AdminProductBloc, AdminProductState>(
      listener: (context, state) {
        if (state is AdminProductUpdating) {
          if (!_isSubmitting) {
            setState(() => _isSubmitting = true);
          }
        } else if (state is AdminProductUpdateSuccess) {
          if (_isSubmitting) {
            setState(() => _isSubmitting = false);
          }
          _showSuccessSnackBar();
          context.pop(true);
        } else if (state is AdminProductUpdateError) {
          if (_isSubmitting) {
            setState(() => _isSubmitting = false);
          }
          _showErrorSnackBar(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info Section
              _buildSectionTitle('Thông tin cơ bản'),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // Category & Brand Section
              _buildSectionTitle('Danh mục & Thương hiệu'),
              _buildCategoryBrandSection(),
              const SizedBox(height: 24),

              // Tire Specs Section
              _buildSectionTitle('Thông số lốp'),
              _buildTireSpecsSection(),
              const SizedBox(height: 24),

              // Media Section
              _buildSectionTitle('Hình ảnh'),
              _buildMediaSection(),
              const SizedBox(height: 24),

              // Status Section
              _buildSectionTitle('Trạng thái'),
              _buildStatusSection(),
              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Product Name
          TextFormField(
            controller: _nameController,
            focusNode: _nameFocus,
            decoration: _buildInputDecoration(
              'Tên sản phẩm',
              'Nhập tên sản phẩm',
              Icons.inventory_2_outlined,
            ),
            validator: _validateName,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _priceFocus.requestFocus(),
          ),
          const SizedBox(height: 12),

          // SKU (Read-only for edit)
          TextFormField(
            controller: _skuController,
            focusNode: _skuFocus,
            readOnly: true,
            enabled: false,
            decoration: _buildInputDecoration(
              'SKU',
              'Nhập mã SKU',
              Icons.qr_code,
            ).copyWith(
              filled: true,
              fillColor: Colors.grey[100],
            ),
            validator: _validateSku,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),

          // Price
          TextFormField(
            controller: _priceController,
            focusNode: _priceFocus,
            decoration: _buildInputDecoration(
              'Giá (VND)',
              'Nhập giá sản phẩm',
              Icons.attach_money,
            ),
            validator: _validatePrice,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _stockFocus.requestFocus(),
            onChanged: _onPriceChanged,
          ),
          const SizedBox(height: 12),

          // Stock Quantity
          TextFormField(
            controller: _stockController,
            focusNode: _stockFocus,
            decoration: _buildInputDecoration(
              'Số lượng tồn kho',
              'Nhập số lượng',
              Icons.inventory,
            ),
            validator: _validateStock,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBrandSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Brand Dropdown
          DropdownButtonFormField<BrandModel>(
            value: _selectedBrand,
            decoration: _buildInputDecoration(
              'Thương hiệu',
              'Chọn thương hiệu',
              Icons.business,
            ),
            validator: _validateBrand,
            items: _brands.map((brand) {
              return DropdownMenuItem<BrandModel>(
                value: brand,
                child: Text(brand.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedBrand = value);
            },
          ),
          const SizedBox(height: 16),

          // Vehicle Make Dropdown
          DropdownButtonFormField<VehicleMakeModel>(
            value: _selectedVehicleMake,
            decoration: _buildInputDecoration(
              'Hãng xe tương thích',
              'Chọn hãng xe',
              Icons.directions_car,
            ),
            items: [
              ..._vehicleMakes.map((make) {
                return DropdownMenuItem<VehicleMakeModel>(
                  value: make,
                  child: Text(make.name),
                );
              }),
              const DropdownMenuItem<VehicleMakeModel>(
                value: null,
                child: Text(
                  'Thêm hãng xe mới',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == null) {
                // User selected "Thêm hãng xe mới"
                _showAddVehicleMakeDialog();
              } else {
                setState(() => _selectedVehicleMake = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTireSpecsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Width + Aspect Ratio
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chiều rộng lốp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _widthController,
                      decoration:
                          _buildInputDecoration(
                            'Chiều rộng',
                            '205',
                            Icons.straighten,
                          ).copyWith(
                            suffixText: 'mm',
                            helperText: '145-455 mm',
                            helperMaxLines: 1,
                          ),
                      validator: _validateWidth,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tỷ lệ aspect',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _aspectRatioController,
                      decoration:
                          _buildInputDecoration(
                            'Aspect',
                            '55',
                            Icons.percent,
                          ).copyWith(
                            suffixText: '%',
                            helperText: '20-95%',
                            helperMaxLines: 1,
                          ),
                      validator: _validateAspectRatio,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Rim Diameter
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đường kính mâm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _rimController,
                      decoration:
                          _buildInputDecoration(
                            'Mâm',
                            '16',
                            Icons.tire_repair,
                          ).copyWith(
                            suffixText: 'inch',
                            helperText: '10-30 inch',
                            helperMaxLines: 1,
                          ),
                      validator: _validateRim,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Image URL
          TextFormField(
            controller: _imageUrlController,
            decoration:
                _buildInputDecoration(
                  'URL Hình ảnh',
                  'https://example.com/image.jpg',
                  Icons.image,
                ).copyWith(
                  helperText: 'Đường dẫn hình ảnh (tùy chọn)',
                  helperMaxLines: 2,
                ),
            validator: _validateImageUrl,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Image Preview
          if (_imageUrlController.text.isNotEmpty)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _imageUrlController.text,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            _isActive ? Icons.check_circle : Icons.cancel,
            color: _isActive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trạng thái hoạt động',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _isActive ? 'Sản phẩm đang được hiển thị' : 'Sản phẩm bị ẩn',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() => _isActive = value);
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Lưu thay đổi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
