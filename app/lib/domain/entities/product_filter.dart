// Filter parameters for product list pagination and search.
// Đóng gói các tham số phân trang, tìm kiếm và lọc khi lấy danh sách sản phẩm.
//
// Tác dụng:
// - Quản lý số trang (page) và số sản phẩm mỗi trang (limit)
// - Tìm kiếm theo tên/SKU (searchQuery)
// - Lọc theo category, brand, khoảng giá (categoryId, brandId, minPrice, maxPrice)
// - Sắp xếp (sortBy, sortOrder)
//
// Ví dụ:
// - page=1, limit=10 → Lấy 10 sản phẩm đầu tiên
// - page=2, limit=10 → Lấy 10 sản phẩm tiếp theo
// - searchQuery='Michelin' → Tìm sản phẩm có tên chứa 'Michelin'
// - categoryId='1', brandId='2' → Lọc theo category và brand

class ProductFilter {
  // Pagination parameters
  final int page;
  final int limit;

  // Search parameters
  final String? searchQuery;

  // Filter parameters
  final String? categoryId;
  final String? brandId;
  final String? vehicleMakeId;
  final double? minPrice;
  final double? maxPrice;

  // Sorting parameters
  final String? sortBy; // 'price', 'name', 'createdAt', 'stockQuantity'
  final bool sortAscending; // true = ASC, false = DESC

  const ProductFilter({
    this.page = 1,
    this.limit = 10, // Changed from 4 to 10 for better pagination
    this.searchQuery,
    this.categoryId,
    this.brandId,
    this.vehicleMakeId,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.sortAscending = true,
  });

  // Check if any filter is active
  bool get hasFilters {
    return searchQuery != null ||
        categoryId != null ||
        brandId != null ||
        vehicleMakeId != null ||
        minPrice != null ||
        maxPrice != null ||
        sortBy != null;
  }

  // Check if this is a search query (not just pagination)
  bool get isSearch => searchQuery != null && searchQuery!.isNotEmpty;

  // Chuyển đổi sang query parameters cho API/SQL request.
  // VD: ProductFilter(page: 2, limit: 20, searchQuery: 'test') →
  // {'page': 2, 'limit': 20, 'search_query': 'test'}
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{'page': page, 'limit': limit};

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['search_query'] = searchQuery;
    }
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    if (brandId != null) {
      params['brand_id'] = brandId;
    }
    if (vehicleMakeId != null) {
      params['vehicle_make_id'] = vehicleMakeId;
    }
    if (minPrice != null) {
      params['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      params['max_price'] = maxPrice;
    }
    if (sortBy != null) {
      params['sort_by'] = sortBy;
      params['sort_order'] = sortAscending ? 'ASC' : 'DESC';
    }

    return params;
  }

  // Tạo filter mới với giá trị cập nhật.
  // Dùng để chuyển trang: copyWith(page: current.page + 1)
  //hoặc cập nhật search: copyWith(searchQuery: 'new query')
  ProductFilter copyWith({
    int? page,
    int? limit,
    String? searchQuery,
    String? categoryId,
    String? brandId,
    String? vehicleMakeId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool? sortAscending,
  }) {
    return ProductFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      vehicleMakeId: vehicleMakeId ?? this.vehicleMakeId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  // Tạo filter mới cho search - reset về trang 1
  ProductFilter withSearch(String query) {
    return copyWith(
      searchQuery: query,
      page: 1, // Reset về trang 1 khi tìm kiếm mới
    );
  }

  // Tạo filter mới cho pagination - giữ nguyên search/filter
  ProductFilter withPage(int newPage) {
    return copyWith(page: newPage);
  }

  // Xóa tất cả filters, giữ nguyên pagination
  ProductFilter clearFilters() {
    return ProductFilter(page: page, limit: limit);
  }

  // Xóa search query, giữ nguyên các filter khác
  ProductFilter clearSearch() {
    return copyWith(searchQuery: null);
  }
}
