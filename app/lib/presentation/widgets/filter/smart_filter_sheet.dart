// Smart Filter Sheet - Bottom Sheet Wizard for tire filtering.
//
// Features:
// - Step 1: Select Vehicle Brand (from vehicle_makes)
// - Step 2: Select Tire Specs (width, aspect_ratio, rim_diameter)
// - Cascading dropdowns for tire specs
// - Result card showing selected configuration
// - Returns ProductFilter with selected values

import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';
import 'package:frontend_otis/core/injections/injection_container.dart';
import 'package:frontend_otis/data/models/tire_spec_model.dart';
import 'package:frontend_otis/data/models/vehicle_make_model.dart';
import 'package:frontend_otis/domain/entities/product_filter.dart';
import 'package:frontend_otis/domain/repositories/product_repository.dart';

class SmartFilterSheet extends StatefulWidget {
  const SmartFilterSheet({super.key});

  static Future<ProductFilter?> show(BuildContext context) {
    return showModalBottomSheet<ProductFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SmartFilterSheet(),
    );
  }

  @override
  State<SmartFilterSheet> createState() => _SmartFilterSheetState();
}

class _SmartFilterSheetState extends State<SmartFilterSheet> {
  // Data from repositories
  List<VehicleMakeModel> _vehicleMakes = [];
  List<TireSpecModel> _tireSpecs = [];

  // Loading states
  bool _isLoading = true;
  String? _error;

  // Step state
  int _currentStep = 1;

  // Selected values
  String? _selectedMakeId;
  String? _selectedMakeName;
  int? _selectedWidth;
  int? _selectedRatio;
  int? _selectedRim;

  // Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Extracted unique values for dropdowns
  List<int> _widths = [];
  List<int> _ratios = [];
  List<int> _rims = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = sl<ProductRepository>();

      // Load vehicle makes
      final makesResult = await repository.getVehicleMakes();

      // Load tire specs
      final specsResult = await repository.getTireSpecs();

      setState(() {
        // Handle vehicle makes
        makesResult.fold(
          (failure) {
            _error = 'Failed to load vehicle makes';
          },
          (makes) {
            _vehicleMakes = makes;
          },
        );

        // Handle tire specs
        specsResult.fold(
          (failure) {
            _error = 'Failed to load tire specs';
          },
          (specs) {
            _tireSpecs = specs;
            _extractUniqueValues();
          },
        );

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  void _extractUniqueValues() {
    // Extract unique widths
    final widthSet = <int>{};
    final ratioSet = <int>{};
    final rimSet = <int>{};

    for (final spec in _tireSpecs) {
      if (spec.width > 0) widthSet.add(spec.width);
      if (spec.aspectRatio > 0) ratioSet.add(spec.aspectRatio);
      if (spec.rimDiameter > 0) rimSet.add(spec.rimDiameter);
    }

    _widths = widthSet.toList()..sort();
    _ratios = ratioSet.toList()..sort();
    _rims = rimSet.toList()..sort();
  }

  List<VehicleMakeModel> get _filteredMakes {
    if (_searchQuery.isEmpty) return _vehicleMakes;
    return _vehicleMakes
        .where(
          (make) =>
              make.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<int> get _availableRatios {
    if (_selectedWidth == null) return _ratios;
    return _tireSpecs
        .where((spec) => spec.width == _selectedWidth)
        .map((spec) => spec.aspectRatio)
        .toSet()
        .toList()
      ..sort();
  }

  List<int> get _availableRims {
    if (_selectedWidth == null) return _rims;
    if (_selectedRatio == null) {
      return _tireSpecs
          .where((spec) => spec.width == _selectedWidth)
          .map((spec) => spec.rimDiameter)
          .toSet()
          .toList()
        ..sort();
    }
    return _tireSpecs
        .where(
          (spec) =>
              spec.width == _selectedWidth &&
              spec.aspectRatio == _selectedRatio,
        )
        .map((spec) => spec.rimDiameter)
        .toSet()
        .toList()
      ..sort();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _selectMake(VehicleMakeModel make) {
    setState(() {
      _selectedMakeId = make.id;
      _selectedMakeName = make.name;
      _currentStep = 2;
    });
  }

  void _goBack() {
    setState(() {
      _currentStep = 1;
    });
  }

  bool get _isSpecSelected =>
      _selectedWidth != null && _selectedRatio != null && _selectedRim != null;

  ProductFilter _buildFilter() {
    return ProductFilter(
      vehicleMakeId: _selectedMakeId,
      width: _selectedWidth,
      aspectRatio: _selectedRatio,
      rimDiameter: _selectedRim,
    );
  }

  void _applyFilter() {
    Navigator.pop(context, _buildFilter());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppColors.primary;
    const backgroundColor = Color(0xFFF8F6F6);

    return Container(
      height: screenHeight * 0.9,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundDark : backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(isDarkMode),

          // Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _error != null
                ? _buildErrorState()
                : _currentStep == 1
                ? _buildStep1(isDarkMode, primaryColor)
                : _buildStep2(isDarkMode, primaryColor),
          ),

          // Footer
          _buildFooter(isDarkMode, primaryColor),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep == 2)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: _goBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            const SizedBox(width: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Car Selector',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'Find your perfect tire fit',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$_currentStep/2',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadData, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildStep1(bool isDarkMode, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE42127),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Select Brand',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search field
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search brand (e.g. Toyota)...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: isDarkMode ? AppColors.surfaceDark : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),

          // Brand grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _filteredMakes.length + 1, // +1 for "More" button
            itemBuilder: (context, index) {
              if (index == _filteredMakes.length) {
                return _buildMoreButton(isDarkMode);
              }
              final make = _filteredMakes[index];
              final isSelected = _selectedMakeId == make.id;

              return GestureDetector(
                onTap: () => _selectMake(make),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.red.shade50
                              : (isDarkMode
                                    ? AppColors.surfaceDark
                                    : Colors.white),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? primaryColor
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            make.name.isNotEmpty
                                ? make.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? primaryColor : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      make.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMoreButton(bool isDarkMode) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(Icons.grid_view, color: Colors.grey, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'More',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(bool isDarkMode, Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected make indicator
          if (_selectedMakeName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.directions_car,
                    size: 16,
                    color: Color(0xFFE42127),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _selectedMakeName!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE42127),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Section title
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE42127),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Tire Configuration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dropdowns
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Width',
                  items: _widths,
                  value: _selectedWidth,
                  onChanged: (val) => setState(() {
                    _selectedWidth = val;
                    _selectedRatio = null;
                    _selectedRim = null;
                  }),
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Ratio',
                  items: _availableRatios,
                  value: _selectedRatio,
                  onChanged: _selectedWidth != null
                      ? (val) => setState(() {
                          _selectedRatio = val;
                          _selectedRim = null;
                        })
                      : null,
                  isDarkMode: isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Rim',
                  items: _availableRims,
                  value: _selectedRim,
                  onChanged: _selectedRatio != null
                      ? (val) => setState(() => _selectedRim = val)
                      : null,
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Result card
          if (_isSpecSelected) _buildResultCard(primaryColor, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<int> items,
    required int? value,
    void Function(int?)? onChanged,
    required bool isDarkMode,
  }) {
    final isEnabled = items.isNotEmpty && onChanged != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value != null
                  ? const Color(0xFFE42127).withOpacity(0.5)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              hint: Text(
                'Select',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.expand_more,
                color: isEnabled ? Colors.grey : Colors.grey.shade300,
              ),
              items: items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        '$e',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: isEnabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Color primaryColor, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.red.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: primaryColor),
                const SizedBox(width: 6),
                Text(
                  'Configuration Ready',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Selected Configuration:',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            '$_selectedWidth / $_selectedRatio R$_selectedRim',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _isSpecSelected ? _applyFilter : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.4),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Show Compatible Tires',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
