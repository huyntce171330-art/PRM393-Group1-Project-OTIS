/// Asset paths constants for the application.
///
/// This file centralizes all asset references to ensure consistency
/// and make asset management easier throughout the project.
///
/// Usage:
/// ```dart
/// Image.asset(AssetsConstants.logo)
/// ```
class AssetsConstants {
  // ===========================================================================
  // IMAGES
  // ===========================================================================

  /// Main application logo
  static const String logo = 'assets/images/logo.png';

  // ===========================================================================
  // DATABASE
  // ===========================================================================

  /// Main SQLite database file
  static const String database = 'assets/database/otis.db';

  // ===========================================================================
  // PRIVATE CONSTRUCTOR
  // ===========================================================================

  /// Private constructor to prevent instantiation
  AssetsConstants._();
}
