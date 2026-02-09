/// App string constants.
///
/// Centralized place for all UI strings to:
/// - Avoid hardcoding strings in widgets
/// - Support future localization
/// - Maintain consistency across the app
class AppStrings {
  // ==================== General ====================

  static const String appName = 'OTIS';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String retry = 'Retry';

  // ==================== Product ====================

  static const String productDetails = 'Product Details';
  static const String loadingProductDetails = 'Loading product details...';
  static const String inStock = 'In Stock';
  static const String outOfStock = 'Out of Stock';
  static const String priceIncludesVat = 'Price includes VAT. Installation fees apply.';

  // ==================== Cart ====================

  static const String cart = 'Cart';
  static const String addToCart = 'Add to Cart';
  static const String buyNow = 'Buy Now';

  // ==================== Search ====================

  static const String searchPlaceholder = 'Search for tires, batteries...';

  // ==================== Navigation ====================

  static const String home = 'Home';
  static const String services = 'Service';
  static const String account = 'Account';

  // ==================== Products ====================

  static const String allProducts = 'All Products';
  static const String noProductsFound = 'No products found';
  static const String tryAdjustingSearch = 'Try adjusting your search or filters';

  // ==================== Errors ====================

  static const String errorLoadingProducts = 'Error loading products';
  static const String pageNotFound = 'Page not found';

  // ==================== Reviews ====================

  static const String reviews = 'Reviews';
  static const String writeReview = 'Write a Review';
  static const String seeAllReviews = 'See All Reviews';
}
