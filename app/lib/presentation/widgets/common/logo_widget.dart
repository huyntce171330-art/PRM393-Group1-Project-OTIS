import 'package:flutter/material.dart';
import 'package:frontend_otis/core/constants/assets_constants.dart';
import 'package:frontend_otis/core/constants/app_colors.dart';

/// Logo widget for the OTIS application.
///
/// Provides consistent logo display across the app with support for
/// different sizes and use cases (full logo, icon-only, etc.).
///
/// Usage examples:
/// ```dart
/// // Full logo with default size
/// const Logo()
///
/// // Smaller logo
/// const Logo(size: 32)
///
/// // Logo with custom fit
/// const Logo(height: 48, fit: BoxFit.contain)
///
/// // Square icon version
/// const Logo.square(size: 64)
/// ```
class Logo extends StatelessWidget {
  /// The width of the logo (used when [useDimensions] is true)
  final double? width;

  /// The height of the logo (used when [useDimensions] is true)
  final double? height;

  /// The overall size for square/aspect-ratio preserved logos
  final double? size;

  /// How to inscribe the image into the space
  final BoxFit fit;

  /// Whether to use the logo as a square icon
  final bool asIcon;

  /// Whether to apply Thai Phung brand colors
  final bool applyBrandColors;

  /// Padding around the logo
  final EdgeInsetsGeometry? padding;

  /// Optional hero tag for hero animations
  final Object? heroTag;

  const Logo({
    super.key,
    this.width,
    this.height,
    this.size,
    this.fit = BoxFit.contain,
    this.asIcon = false,
    this.applyBrandColors = false,
    this.padding,
    this.heroTag,
  });

  /// Creates a square icon version of the logo
  const Logo.square({
    super.key,
    this.size = 48,
    this.fit = BoxFit.contain,
    this.applyBrandColors = false,
    this.padding,
    this.heroTag,
  })  : width = null,
        height = null,
        asIcon = true;

  /// Creates a small logo variant
  const Logo.small({
    super.key,
    this.size = 24,
    this.fit = BoxFit.contain,
    this.applyBrandColors = false,
    this.padding,
    this.heroTag,
  })  : width = null,
        height = null,
        asIcon = false;

  /// Creates a medium logo variant
  const Logo.medium({
    super.key,
    this.size = 48,
    this.fit = BoxFit.contain,
    this.applyBrandColors = false,
    this.padding,
    this.heroTag,
  })  : width = null,
        height = null,
        asIcon = false;

  /// Creates a large logo variant
  const Logo.large({
    super.key,
    this.size = 72,
    this.fit = BoxFit.contain,
    this.applyBrandColors = false,
    this.padding,
    this.heroTag,
  })  : width = null,
        height = null,
        asIcon = false;

  double get _effectiveWidth => width ?? size ?? 120;
  double get _effectiveHeight => height ?? (asIcon ? _effectiveWidth : _effectiveWidth / 2.5);

  Widget _buildImage(BuildContext context) {
    return Image.asset(
      AssetsConstants.logo,
      key: key,
      width: _effectiveWidth,
      height: _effectiveHeight,
      fit: fit,
      excludeFromSemantics: true,
    );
  }

  Widget _buildWithHero(BuildContext context) {
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: _buildImage(context),
      );
    }
    return _buildImage(context);
  }

  Widget _buildWithPadding(BuildContext context) {
    final child = _buildWithHero(context);
    if (padding != null) {
      return Padding(padding: padding!, child: child);
    }
    return child;
  }

  Widget _buildWithBrandColors(BuildContext context) {
    final child = _buildWithPadding(context);
    if (applyBrandColors) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          AppColors.primary,
          BlendMode.srcIn,
        ),
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _buildWithBrandColors(context);
  }
}

/// Animated logo widget with fade-in effect.
///
/// Useful for splash screens or initial page loads.
class AnimatedLogo extends StatefulWidget {
  /// Duration of the fade-in animation
  final Duration duration;

  /// The size of the logo
  final double? size;

  /// Callback when animation completes
  final VoidCallback? onAnimationComplete;

  const AnimatedLogo({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.size,
    this.onAnimationComplete,
  });

  const AnimatedLogo.small({
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.size = 24,
    this.onAnimationComplete,
  });

  const AnimatedLogo.medium({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.size = 48,
    this.onAnimationComplete,
  });

  const AnimatedLogo.large({
    super.key,
    this.duration = const Duration(milliseconds: 700),
    this.size = 72,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().then((_) {
        widget.onAnimationComplete?.call();
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Logo(size: widget.size),
    );
  }
}
