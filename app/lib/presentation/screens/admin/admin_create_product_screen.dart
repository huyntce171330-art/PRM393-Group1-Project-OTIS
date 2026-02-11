// Screen to create a new product.
//
// Features:
// - Form with validation for all product fields
// - Basic info: name, SKU, price, stock
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
import 'package:frontend_otis/domain/usecases/product/get_brands_usecase.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_bloc.dart';
import 'package:frontend_otis/presentation/bloc/admin_product/admin_product_state.dart';

/// Screen to create a new product.
///
/// Follows the Thai Phung design system and Clean Architecture pattern.
/// Uses BLoC for state management.
class AdminCreateProductScreen extends StatefulWidget {
  const AdminCreateProductScreen({super.key});

  @override
  State<AdminCreateProductScreen> createState() =>
      _AdminCreateProductScreenState();
}

class _AdminCreateProductScreenState extends State<AdminCreateProductScreen> {
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

  // Toggle value
  bool _isActive = true;

  // Loading state
  bool _isSubmitting = false;

  // Focus nodes
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _skuFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _stockFocus = FocusNode();

  // Lists for dropdowns
  List<BrandModel> _brands = [];

  @override
  void initState() {
    super.initState();
    _loadDropdowns();
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

  Future<void> _loadDropdowns() async {
    // Get use cases from the bloc (injected via GetIt in real app)
    final getBrandsUsecase = GetBrandsUsecase(productRepository: sl());

    // Load brands
    final brandsResult = await getBrandsUsecase();
    brandsResult.fold(
      (failure) {
        // Handle error - show snackbar or keep empty
        print('DEBUG: Failed to load brands: $failure');
      },
      (brands) {
        if (mounted) {
          setState(() => _brands = brands);
        }
      },
    );
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
    if (value == null || value.trim().isEmpty) {
      return 'SKU là bắt buộc';
    }
    if (value.trim().length < 3) {
      return 'SKU phải có ít nhất 3 ký tự';
    }
    if (value.trim().length > 50) {
      return 'SKU không được quá 50 ký tự';
    }
    // Check alphanumeric + dashes/underscores
    final regex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!regex.hasMatch(value)) {
      return 'SKU chỉ được chứa chữ cái, số, gạch ngang và gạch dưới';
    }
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
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final width = int.tryParse(value);
    if (width == null) {
      return 'Chiều rộng phải là số';
    }
    if (width < 145 || width > 455) {
      return 'Chiều rộng phải từ 145 đến 455 mm';
    }
    return null;
  }

  String? _validateAspectRatio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final ratio = int.tryParse(value);
    if (ratio == null) {
      return 'Tỷ lệ aspect phải là số';
    }
    if (ratio < 20 || ratio > 95) {
      return 'Tỷ lệ aspect phải từ 20% đến 95%';
    }
    return null;
  }

  String? _validateRim(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final rim = int.tryParse(value);
    if (rim == null) {
      return 'Đường kính mâm phải là số';
    }
    if (rim < 10 || rim > 30) {
      return 'Đường kính mâm phải từ 10 đến 30 inch';
    }
    return null;
  }

  String? _validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
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

  String _formatPrice(String value) {
    // Remove existing formatting
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.isEmpty) return '';

    final number = int.tryParse(cleanValue) ?? 0;
    final formatted = number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return '$formatted đ';
  }

  void _onPriceChanged(String value) {
    final cursorPos = _priceController.selection.base.offset;
    final oldLength = _priceController.text.length;

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

  Future<bool> _showDiscardDialog() async {
    final hasChanges =
        _nameController.text.isNotEmpty ||
        _skuController.text.isNotEmpty ||
        _priceController.text.isNotEmpty ||
        _stockController.text.isNotEmpty;

    if (!hasChanges) {
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
      // Focus first invalid field
      _focusInvalidField();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Create ProductModel from form data
      final productModel = ProductModel(
        id: '', // Will be generated by database
        sku: _skuController.text.trim(),
        name: _nameController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        brand: _selectedBrand!,
        vehicleMake: VehicleMakeModel(id: '', name: '', logoUrl: ''),
        tireSpec: TireSpecModel(
          id: '',
          width: int.tryParse(_widthController.text.trim()) ?? 0,
          aspectRatio: int.tryParse(_aspectRatioController.text.trim()) ?? 0,
          rimDiameter: int.tryParse(_rimController.text.trim()) ?? 0,
        ),
        price: double.parse(
          _priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ),
        stockQuantity: int.parse(_stockController.text.trim()),
        isActive: _isActive,
        createdAt: DateTime.now(),
      );

      // Dispatch event to Bloc
      context.read<AdminProductBloc>().createProduct(productModel);
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showErrorSnackBar('Có lỗi xảy ra: $e');
    }
  }

  void _focusInvalidField() {
    // Find first invalid field and request focus
    // This is a simple implementation - can be enhanced
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tạo sản phẩm thành công!'),
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

  @override
  Widget build(BuildContext context) {
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
        'Thêm sản phẩm mới',
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
        if (state is AdminProductCreating) {
          // Show loading indicator
          if (!_isSubmitting) {
            setState(() => _isSubmitting = true);
          }
        } else if (state is AdminProductCreateSuccess) {
          // Dismiss loading
          if (_isSubmitting) {
            setState(() => _isSubmitting = false);
            Navigator.of(context).pop(); // Dismiss loading dialog
          }
          // Show success message
          _showSuccessSnackBar();
          // Navigate back with success result
          context.pop(true);
        } else if (state is AdminProductCreateError) {
          // Dismiss loading
          if (_isSubmitting) {
            setState(() => _isSubmitting = false);
            Navigator.of(context).pop(); // Dismiss loading dialog
          }
          // Show error message
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
            onFieldSubmitted: (_) => _skuFocus.requestFocus(),
          ),
          const SizedBox(height: 12),

          // SKU
          TextFormField(
            controller: _skuController,
            focusNode: _skuFocus,
            decoration: _buildInputDecoration(
              'SKU',
              'Nhập mã SKU',
              Icons.qr_code,
            ),
            validator: _validateSku,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _priceFocus.requestFocus(),
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
              const SizedBox(width: 16),
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
                            'Tỷ lệ',
                            '55',
                            Icons.aspect_ratio,
                          ).copyWith(
                            suffixText: '%',
                            helperText: '20-95 %',
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
          // Row 2: Rim (full width)
          Column(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.textPrimary),
              SizedBox(width: 12),
              Text(
                'Kích hoạt sản phẩm',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ],
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
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                  color: Colors.white,
                ),
              )
            : const Text(
                'Tạo sản phẩm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      filled: true,
      fillColor: AppColors.backgroundLight,
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      // ADD: Explicit styles for text visibility
      hintStyle: TextStyle(color: Colors.grey[500]),
      labelStyle: TextStyle(color: Colors.grey[700]),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }
}
