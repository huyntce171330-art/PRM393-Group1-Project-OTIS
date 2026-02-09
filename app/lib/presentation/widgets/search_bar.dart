import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Search bar widget with debounce support.
///
/// Features:
/// - TextField with search icon prefix
/// - Optional clear button when text is not empty
/// - Debounce to prevent excessive API calls
/// - Customizable debounce duration
/// - onChanged and onSubmitted callbacks
class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final String? initialValue;
  final bool enabled;
  final bool autofocus;
  final int debounceDurationMs;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const SearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search...',
    this.initialValue,
    this.enabled = true,
    this.autofocus = false,
    this.debounceDurationMs = 300,
    this.inputFormatters,
    this.textInputAction = TextInputAction.search,
    this.focusNode,
    this.controller,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;
  late final bool _shouldDisposeController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _shouldDisposeController = false;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _shouldDisposeController = true;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (_shouldDisposeController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(
      Duration(milliseconds: widget.debounceDurationMs),
      () {
        widget.onChanged?.call(value);
      },
    );
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onSubmitted?.call('');
  }

  /// Get the controller for external access
  TextEditingController get controller => _controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _clear,
              )
            : null,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}

/// Search bar with filter button.
///
/// Combines SearchBar with a filter icon button
/// that triggers a callback when pressed.
class SearchBarWithFilter extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;
  final String hintText;
  final bool hasActiveFilter;
  final bool enabled;
  final bool autofocus;
  final int debounceDurationMs;
  final TextEditingController? controller;

  const SearchBarWithFilter({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.hintText = 'Search products...',
    this.hasActiveFilter = false,
    this.enabled = true,
    this.autofocus = false,
    this.debounceDurationMs = 300,
    this.controller,
  });

  @override
  State<SearchBarWithFilter> createState() => _SearchBarWithFilterState();
}

class _SearchBarWithFilterState extends State<SearchBarWithFilter> {
  late final SearchBar _searchBar;

  @override
  void initState() {
    super.initState();
    _searchBar = SearchBar(
      controller: widget.controller,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      hintText: widget.hintText,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      debounceDurationMs: widget.debounceDurationMs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: _searchBar),
        const SizedBox(width: 8),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: widget.hasActiveFilter
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: widget.hasActiveFilter
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            onPressed: widget.enabled ? widget.onFilterPressed : null,
            tooltip: 'Filter',
          ),
        ),
      ],
    );
  }
}

/// Controller for SearchBar to enable external control.
class SearchBarController extends TextEditingController {
  /// Clear the search text programmatically.
  void clearSearch() {
    clear();
  }
}
