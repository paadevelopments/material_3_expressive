import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/search/m3e_search.dart'
    show M3ESearchAnchor;
import 'package:material_3_expressive/components/search/m3e_search_anchor.dart'
    show M3ESearchAnchor;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ESearchAnchor;
import 'package:material_ui/material_ui.dart'
    show Color, Colors, Material, WidgetStatePropertyAll;

import '../../../foundations/foundations.dart';
import '../../divider/m3e_divider.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../controllers/m3e_search_controller.dart';
import '../m3e_search_bar.dart';
import '../res/m3e_search_constants.dart';
import '../styles/m3e_search_view_theme.dart';

/// Animated search view surface shown by [M3ESearchAnchor].

part 'm3e_search_view_route.dart';
part 'm3e_search_view_build.dart';

/// M3ESearchViewContent.

class M3ESearchViewContent extends StatefulWidget {
  /// M3ESearchViewContent.
  const M3ESearchViewContent({
    required this.searchController,
    required this.suggestionsBuilder,
    required this.animation,
    required this.viewRect,
    required this.viewMaxWidth,
    required this.topPadding,
    required this.showFullScreenView,
    this.viewBuilder,
    this.viewLeading,
    this.viewTrailing,
    this.viewHintText,
    this.viewBackgroundColor,
    this.viewElevation,
    this.viewSurfaceTintColor,
    this.viewSide,
    this.viewShape,
    this.viewBarPadding,
    this.viewHeaderHeight,
    this.viewHeaderTextStyle,
    this.viewHeaderHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.textInputAction,
    this.keyboardType,
    this.smartDashesType,
    this.smartQuotesType,
    super.key,
  });

  /// searchController.

  final M3ESearchController searchController;

  /// suggestionsBuilder.
  final M3ESearchSuggestionsBuilder suggestionsBuilder;

  /// animation.
  final Animation<double> animation;

  /// viewRect.
  final Rect viewRect;

  /// viewMaxWidth.
  final double viewMaxWidth;

  /// topPadding.
  final double topPadding;

  /// showFullScreenView.
  final bool showFullScreenView;

  /// viewBuilder.
  final M3ESearchViewBuilder? viewBuilder;

  /// viewLeading.
  final Widget? viewLeading;

  /// viewTrailing.
  final Iterable<Widget>? viewTrailing;

  /// viewHintText.
  final String? viewHintText;

  /// viewBackgroundColor.
  final Color? viewBackgroundColor;

  /// viewElevation.
  final double? viewElevation;

  /// viewSurfaceTintColor.
  final Color? viewSurfaceTintColor;

  /// viewSide.
  final BorderSide? viewSide;

  /// viewShape.
  final OutlinedBorder? viewShape;

  /// viewBarPadding.
  final EdgeInsetsGeometry? viewBarPadding;

  /// viewHeaderHeight.
  final double? viewHeaderHeight;

  /// viewHeaderTextStyle.
  final TextStyle? viewHeaderTextStyle;

  /// viewHeaderHintStyle.
  final TextStyle? viewHeaderHintStyle;

  /// dividerColor.
  final Color? dividerColor;

  /// viewConstraints.
  final BoxConstraints? viewConstraints;

  /// viewPadding.
  final EdgeInsetsGeometry? viewPadding;

  /// shrinkWrap.
  final bool? shrinkWrap;

  /// textCapitalization.
  final TextCapitalization? textCapitalization;

  /// viewOnChanged.
  final ValueChanged<String>? viewOnChanged;

  /// viewOnSubmitted.
  final ValueChanged<String>? viewOnSubmitted;

  /// textInputAction.
  final TextInputAction? textInputAction;

  /// keyboardType.
  final TextInputType? keyboardType;

  /// smartDashesType.
  final SmartDashesType? smartDashesType;

  /// smartQuotesType.
  final SmartQuotesType? smartQuotesType;

  @override
  State<M3ESearchViewContent> createState() => _M3ESearchViewContentState();
}

class _M3ESearchViewContentState extends State<M3ESearchViewContent> {
  Size? _screenSize;
  late Rect _viewRect;
  late CurvedAnimation _viewIconsFadeCurve;
  late CurvedAnimation _viewDividerFadeCurve;
  late CurvedAnimation _viewListFadeCurve;
  Iterable<Widget> _suggestions = const <Widget>[];
  String? _searchValue;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewRect = widget.viewRect;
    widget.searchController.addListener(_scheduleSuggestions);
    widget.searchController.addListener(_handleControllerChanged);
    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_updateSuggestions());
    });
  }

  @override
  void didUpdateWidget(covariant M3ESearchViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewRect != oldWidget.viewRect) {
      setState(() => _viewRect = widget.viewRect);
    }
    if (widget.animation != oldWidget.animation) {
      _disposeAnimations();
      _setupAnimations();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.sizeOf(context);
    if (_screenSize != updatedScreenSize) {
      _screenSize = updatedScreenSize;
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_scheduleSuggestions);
    widget.searchController.removeListener(_handleControllerChanged);
    _disposeAnimations();
    _timer?.cancel();
    super.dispose();
  }

  void _setupAnimations() {
    _viewIconsFadeCurve = CurvedAnimation(
      parent: widget.animation,
      curve: M3ESearchConstants.viewIconsFadeOnInterval,
      reverseCurve: M3ESearchConstants.viewIconsFadeOnInterval.flipped,
    );
    _viewDividerFadeCurve = CurvedAnimation(
      parent: widget.animation,
      curve: M3ESearchConstants.viewDividerFadeOnInterval,
      reverseCurve: M3ESearchConstants.viewFadeOnInterval.flipped,
    );
    _viewListFadeCurve = CurvedAnimation(
      parent: widget.animation,
      curve: M3ESearchConstants.viewListFadeOnInterval,
      reverseCurve: M3ESearchConstants.viewListFadeOnInterval.flipped,
    );
  }

  void _disposeAnimations() {
    _viewIconsFadeCurve.dispose();
    _viewDividerFadeCurve.dispose();
    _viewListFadeCurve.dispose();
  }

  void _handleControllerChanged() => setState(() {});

  void _scheduleSuggestions() {
    if (_searchValue == widget.searchController.text) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(Duration.zero, () async {
      _searchValue = widget.searchController.text;
      final Iterable<Widget> suggestions = await widget.suggestionsBuilder(
        context,
        widget.searchController,
      );
      if (mounted) {
        setState(() => _suggestions = suggestions);
      }
    });
  }

  Future<void> _updateSuggestions() async {
    _searchValue = widget.searchController.text;
    final Iterable<Widget> suggestions = await widget.suggestionsBuilder(
      context,
      widget.searchController,
    );
    if (mounted) {
      setState(() => _suggestions = suggestions);
    }
  }

  @override
  Widget build(BuildContext context) => _buildSearchView(context);
}
