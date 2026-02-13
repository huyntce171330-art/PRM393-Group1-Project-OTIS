import 'package:flutter/material.dart';

/// Custom button widget with consistent styling.
///
/// Features:
/// - Supports multiple variants (primary, secondary, outline, danger)
/// - Configurable size (small, medium, large)
/// - Loading state with disabled interaction
/// - Optional icon support
enum ButtonVariant { primary, secondary, outline, danger }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool expandIcon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.expandIcon = false,
    this.width,
    this.height,
  });

  double get _height {
    switch (size) {
      case ButtonSize.small: return 36;
      case ButtonSize.medium: return 48;
      case ButtonSize.large: return 56;
    }
  }

  double get _fontSize {
    switch (size) {
      case ButtonSize.small: return 13;
      case ButtonSize.medium: return 14;
      case ButtonSize.large: return 16;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case ButtonSize.small: return const EdgeInsets.symmetric(horizontal: 12);
      case ButtonSize.medium: return const EdgeInsets.symmetric(horizontal: 16);
      case ButtonSize.large: return const EdgeInsets.symmetric(horizontal: 24);
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (variant) {
      case ButtonVariant.primary:
        return theme.colorScheme.primary;
      case ButtonVariant.secondary:
        return theme.colorScheme.secondary;
      case ButtonVariant.danger:
        return Colors.red.shade600;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return theme.colorScheme.onPrimary;
      case ButtonVariant.outline:
        return theme.colorScheme.primary;
    }
  }

  BorderSide _getBorderSide(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return BorderSide.none;
      case ButtonVariant.outline:
        return BorderSide(color: Theme.of(context).colorScheme.outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;
    final effectiveHeight = height ?? _height;
    
    final child = Row(
      mainAxisSize: expandIcon ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _getForegroundColor(context),
            ),
          )
        else if (icon != null) ...[
          icon!,
          if (text.isNotEmpty) const SizedBox(width: 8),
        ],
        if (text.isNotEmpty)
          Text(
            text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(context),
          foregroundColor: _getForegroundColor(context),
          padding: _padding,
          elevation: variant == ButtonVariant.primary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: _getBorderSide(context),
          ),
          textStyle: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: child,
      ),
    );
  }
}

/// Secondary button widget.
class SecondaryButton extends CustomButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
    super.width,
  }) : super(
    variant: ButtonVariant.secondary,
  );
}

/// Outline button widget.
class OutlineButton extends CustomButton {
  const OutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
    super.width,
  }) : super(
    variant: ButtonVariant.outline,
  );
}

/// Danger button widget.
class DangerButton extends CustomButton {
  const DangerButton({
    super.key,
    required super.text,
    super.onPressed,
    super.isLoading,
    super.icon,
    super.width,
  }) : super(
    variant: ButtonVariant.danger,
  );
}
