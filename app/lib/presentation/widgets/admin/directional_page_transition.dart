import 'package:flutter/material.dart';

/// Tracks tab navigation direction across the admin shell.
/// Use [TabNavigationDirection.updateAndGet] before calling context.go().
class TabNavigationDirection {
  static int _lastTabIndex = 0;
  static bool _isForward = true;

  /// Call before context.go() to record direction.
  /// Returns true if navigating forward (left to right).
  static bool updateAndGet(int newIndex) {
    _isForward = newIndex > _lastTabIndex;
    _lastTabIndex = newIndex;
    return _isForward;
  }

  /// Reset to a specific index (e.g., when entering the shell).
  static void resetTo(int index) {
    _lastTabIndex = index;
  }

  static bool get isForward => _isForward;
}

/// Wraps a child with a slide transition based on tab navigation direction.
/// Attach to [AdminLayout.child] to apply directional animation on tab switches.
class DirectionalPageTransition extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const DirectionalPageTransition({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<DirectionalPageTransition> createState() =>
      _DirectionalPageTransitionState();
}

class _DirectionalPageTransitionState extends State<DirectionalPageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  int _displayedIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayedIndex = widget.currentIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(DirectionalPageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _displayedIndex) {
      _animateToNewPage(widget.currentIndex);
    }
  }

  void _animateToNewPage(int newIndex) {
    final forward = newIndex > _displayedIndex;
    final offsetX = forward ? 1.0 : -1.0;

    _controller.reset();

    _slideAnimation = Tween<Offset>(
      begin: Offset(offsetX, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward().then((_) {
      if (mounted) {
        setState(() => _displayedIndex = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}
