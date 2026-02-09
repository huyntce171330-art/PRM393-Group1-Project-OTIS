// This file defines the color palette for the app.
//
// Thai Phung Design System Colors:
// - Primary: #e42127 (Red brand color)
// - Background Light: #f8f6f6
// - Background Dark: #211112
// - Surface Light: #ffffff
// - Surface Dark: #2d1b1c
//
// Steps to implement:
// 1. Define a class `AppColors`.
// 2. Add static const generic colors.
//    - `static const Color primary = Color(0xFF...);`
//    - `static const Color secondary = Color(0xFF...);`

import 'package:flutter/material.dart';

/// Thai Phung Color Palette
///
/// Defines all brand colors following the Thai Phung design system.
/// All colors should be accessed through this class for consistency.
class AppColors {
  // ===========================================================================
  // PRIMARY BRAND COLORS
  // ===========================================================================

  /// Primary brand color - Thai Phung Red
  static const Color primary = Color(0xFFE42127);

  /// Darker shade of primary for hover/pressed states
  static const Color primaryDark = Color(0xFFC4191F);

  /// Lighter shade for emphasis or backgrounds
  static const Color primaryLight = Color(0xFFFFE5E6);

  /// Primary container color for backgrounds
  static const Color primaryContainer = Color(0xFFFFDADF);

  /// On primary color (text/icons on primary background)
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// On primary container color
  static const Color onPrimaryContainer = Color(0xFF3F0005);

  // ===========================================================================
  // BACKGROUND COLORS
  // ===========================================================================

  /// Light mode background color
  static const Color backgroundLight = Color(0xFFF8F6F6);

  /// Dark mode background color
  static const Color backgroundDark = Color(0xFF211112);

  // ===========================================================================
  // SURFACE COLORS
  // ===========================================================================

  /// Light mode surface color (cards, containers)
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Dark mode surface color
  static const Color surfaceDark = Color(0xFF2D1B1C);

  /// Alternative dark mode surface (for elevation)
  static const Color surfaceDarkAlt = Color(0xFF1A0F0F);

  /// iOS-style dark surface
  static const Color surfaceDarkAlt2 = Color(0xFF1C1C1E);

  /// Surface container highest (inputs, cards)
  static const Color surfaceContainerHighest = Color(0xFFE8E6E6);

  /// Surface container high
  static const Color surfaceContainerHigh = Color(0xFFF0EEEE);

  /// Surface container
  static const Color surfaceContainer = Color(0xFFF5F3F3);

  /// Surface container low
  static const Color surfaceContainerLow = Color(0xFFFAF9F9);

  /// Surface brightness variant
  static const Color surfaceVariant = Color(0xFFE0DEDE);

  // ===========================================================================
  // TEXT COLORS
  // ===========================================================================

  /// Primary text color (light mode)
  static const Color textPrimary = Color(0xFF181111);

  /// Secondary text color (gray for subtitles)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Tertiary text color (lighter gray)
  static const Color textTertiary = Color(0xFF9CA3AF);

  /// On background text (dark mode)
  static const Color textOnBackground = Color(0xFFF5F3F3);

  /// Text color for disabled states
  static const Color textDisabled = Color(0xFFBDBDBD);

  // ===========================================================================
  // STATUS COLORS
  // ===========================================================================

  /// Success green - for in-stock items
  static const Color success = Color(0xFF22C55E);

  /// Success container
  static const Color successContainer = Color(0xFFDCFCE7);

  /// On success color
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// Warning yellow - for low stock items
  static const Color warning = Color(0xFFF59E0B);

  /// Warning container
  static const Color warningContainer = Color(0xFFFEF3C7);

  /// On warning color
  static const Color onWarning = Color(0xFF92400E);

  /// Error red - for out of stock items
  static const Color error = Color(0xFFDC2626);

  /// Error container
  static const Color errorContainer = Color(0xFFFEE2E2);

  /// On error color
  static const Color onError = Color(0xFFFFFFFF);

  /// Info blue
  static const Color info = Color(0xFF3B82F6);

  /// Info container
  static const Color infoContainer = Color(0xFFDBEAFE);

  // ===========================================================================
  // OUTLINE & BORDER COLORS
  // ===========================================================================

  /// Outline color for borders and dividers
  static const Color outline = Color(0xFFD1D5DB);

  /// Outline variant for subtle borders
  static const Color outlineVariant = Color(0xFFE5E7EB);

  // ===========================================================================
  // SHADOW COLORS
  // ===========================================================================

  /// Shadow color for card elevation
  static const Color shadow = Color(0xFF000000);

  /// Transparent shadow color
  static const Color shadowColor = Color(0x1A000000);

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================

  /// Get surface color based on brightness
  static Color surface(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? surfaceDark : surfaceLight;
  }

  /// Get background color based on brightness
  static Color background(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? backgroundDark : backgroundLight;
  }

  /// Get text color based on brightness
  static Color text(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? textOnBackground : textPrimary;
  }

  /// Get stock status color
  static Color getStockStatusColor(int stockQuantity) {
    if (stockQuantity == 0) {
      return error;
    } else if (stockQuantity < 10) {
      return warning;
    } else {
      return success;
    }
  }
}
