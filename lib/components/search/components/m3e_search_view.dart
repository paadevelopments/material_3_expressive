import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show Colors, Material, WidgetStatePropertyAll;
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/search/m3e_search.dart'
    show M3ESearchAnchor;
import 'package:material_3_expressive/components/search/m3e_search_anchor.dart'
    show M3ESearchAnchor;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ESearchAnchor;

import '../../../foundations/foundations.dart';
import '../../divider/m3e_divider.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../controllers/m3e_search_controller.dart';
import '../m3e_search_bar.dart';
import '../res/m3e_search_constants.dart';
import '../styles/m3e_search_view_theme.dart';

/// Animated search view surface shown by [M3ESearchAnchor].

part 'm3e_search_view_route.dart';

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
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final viewTheme = theme.searchViewTheme;
    final scheme = theme.colorScheme;

    final Widget defaultLeading = M3EIconButton(
      icon: const Icon(M3EIcons.arrow_back),
      tooltip: M3ESearchConstants.backButtonTooltip,
      onPressed: () => Navigator.of(context).pop(),
    );

    final defaultTrailing = <Widget>[
      if (widget.searchController.text.isNotEmpty)
        M3EIconButton(
          icon: const Icon(M3EIcons.close),
          tooltip: M3ESearchConstants.clearButtonTooltip,
          onPressed: widget.searchController.clear,
        ),
    ];

    final Color effectiveBackground = widget.showFullScreenView
        ? (widget.viewBackgroundColor ??
              viewTheme.fullScreenBackgroundColor(scheme))
        : (widget.viewBackgroundColor ?? viewTheme.backgroundColor(scheme));
    final Color effectiveSurfaceTint = widget.showFullScreenView
        ? (widget.viewSurfaceTintColor ?? viewTheme.surfaceTintColor(scheme))
        : (widget.viewSurfaceTintColor ?? viewTheme.surfaceTintColor(scheme));
    final double effectiveElevation = widget.showFullScreenView
        ? (widget.viewElevation ?? 0)
        : (widget.viewElevation ?? viewTheme.elevation);
    final BorderSide? effectiveSide = widget.viewSide;
    OutlinedBorder effectiveShape =
        widget.viewShape ??
        (widget.showFullScreenView
            ? viewTheme.fullScreenShape() as OutlinedBorder
            : viewTheme.dockedShape(viewTheme.cornerRadius) as OutlinedBorder);
    if (effectiveSide != null) {
      effectiveShape = effectiveShape.copyWith(side: effectiveSide);
    }
    final Color effectiveDividerColor =
        widget.dividerColor ?? Colors.transparent;
    final double? effectiveHeaderHeight =
        widget.viewHeaderHeight ??
        (widget.showFullScreenView ? viewTheme.headerHeight : null);
    final BoxConstraints? headerConstraints = effectiveHeaderHeight == null
        ? null
        : BoxConstraints.tightFor(height: effectiveHeaderHeight);
    final TextStyle effectiveTextStyle =
        widget.viewHeaderTextStyle ??
        viewTheme.headerTextStyle(theme.typeScale, scheme);
    final TextStyle effectiveHintStyle =
        widget.viewHeaderHintStyle ??
        widget.viewHeaderTextStyle ??
        viewTheme.headerHintStyle(theme.typeScale, scheme);
    final EdgeInsetsGeometry effectivePadding =
        widget.viewPadding ?? EdgeInsets.zero;
    final EdgeInsetsGeometry effectiveBarPadding =
        widget.viewBarPadding ?? viewTheme.barPadding();
    final EdgeInsetsGeometry fullScreenHeaderPadding = viewTheme
        .fullScreenHeaderPadding();
    final BoxConstraints effectiveConstraints =
        widget.viewConstraints ?? viewTheme.constraints();
    final double minWidth = math.min(
      effectiveConstraints.minWidth,
      _viewRect.width,
    );
    final double minHeight = math.min(
      effectiveConstraints.minHeight,
      _viewRect.height,
    );
    final bool effectiveShrinkWrap = widget.shrinkWrap ?? viewTheme.shrinkWrap;
    final double headerBlockHeight =
        effectiveHeaderHeight ??
        (widget.showFullScreenView
            ? M3ESearchConstants.fullScreenBarHeight
            : theme.searchBarTheme.minHeight);
    final bool showBody = _viewRect.height > headerBlockHeight + 1;

    final Widget headerBar = widget.showFullScreenView
        ? M3ESearchBar(
            autoFocus: true,
            expandOnFocus: false,
            leading: widget.viewLeading ?? defaultLeading,
            trailing: widget.viewTrailing ?? defaultTrailing,
            hintText: widget.viewHintText,
            controller: widget.searchController,
            onChanged: (String value) {
              widget.viewOnChanged?.call(value);
              _updateSuggestions();
            },
            onSubmitted: widget.viewOnSubmitted,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
          )
        : M3ESearchBar(
            autoFocus: true,
            expandOnFocus: false,
            constraints: headerConstraints,
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              effectiveBarPadding,
            ),
            leading: widget.viewLeading ?? defaultLeading,
            trailing: widget.viewTrailing ?? defaultTrailing,
            hintText: widget.viewHintText,
            backgroundColor: const WidgetStatePropertyAll<Color>(
              Color(0x00000000),
            ),
            overlayColor: const WidgetStatePropertyAll<Color>(
              Color(0x00000000),
            ),
            elevation: const WidgetStatePropertyAll<double>(0),
            textStyle: WidgetStatePropertyAll<TextStyle>(effectiveTextStyle),
            hintStyle: WidgetStatePropertyAll<TextStyle>(effectiveHintStyle),
            controller: widget.searchController,
            onChanged: (String value) {
              widget.viewOnChanged?.call(value);
              _updateSuggestions();
            },
            onSubmitted: widget.viewOnSubmitted,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
          );

    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: _viewRect.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            maxWidth: _viewRect.width,
            minHeight: minHeight,
            maxHeight: _viewRect.height,
          ),
          child: Padding(
            padding: widget.showFullScreenView
                ? EdgeInsets.zero
                : effectivePadding,
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: effectiveShape,
              color: effectiveBackground,
              surfaceTintColor: effectiveSurfaceTint,
              elevation: effectiveElevation,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: math.min(widget.viewMaxWidth, _screenSize!.width),
                minWidth: 0,
                fit: OverflowBoxFit.deferToChild,
                child: FadeTransition(
                  opacity: _viewIconsFadeCurve,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: widget.topPadding),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          child: widget.showFullScreenView
                              ? Padding(
                                  padding: fullScreenHeaderPadding,
                                  child: headerBar,
                                )
                              : headerBar,
                        ),
                      ),
                      if (showBody &&
                          (!effectiveShrinkWrap ||
                              minHeight > 0 ||
                              widget.showFullScreenView ||
                              _suggestions.isNotEmpty)) ...<Widget>[
                        FadeTransition(
                          opacity: _viewDividerFadeCurve,
                          child: M3EDivider(color: effectiveDividerColor),
                        ),
                        Flexible(
                          fit: effectiveShrinkWrap && !widget.showFullScreenView
                              ? FlexFit.loose
                              : FlexFit.tight,
                          child: FadeTransition(
                            opacity: _viewListFadeCurve,
                            child: widget.viewBuilder == null
                                ? MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: ListView(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.viewInsetsOf(
                                          context,
                                        ).bottom,
                                      ),
                                      shrinkWrap: effectiveShrinkWrap,
                                      children: _suggestions.toList(),
                                    ),
                                  )
                                : widget.viewBuilder!(_suggestions),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Route that morphs from the anchor search bar into a search view.
