import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Material, WidgetStatePropertyAll;
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../controllers/m3e_search_controller.dart';
import '../m3e_search_bar.dart';
import '../res/m3e_search_constants.dart';
import '../styles/m3e_search_view_theme.dart';
import '../../divider/m3e_divider.dart';
import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';

/// Animated search view surface shown by [M3ESearchAnchor].
class M3ESearchViewContent extends StatefulWidget {
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

  final M3ESearchController searchController;
  final M3ESearchSuggestionsBuilder suggestionsBuilder;
  final Animation<double> animation;
  final Rect viewRect;
  final double viewMaxWidth;
  final double topPadding;
  final bool showFullScreenView;
  final M3ESearchViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final EdgeInsetsGeometry? viewBarPadding;
  final double? viewHeaderHeight;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final EdgeInsetsGeometry? viewPadding;
  final bool? shrinkWrap;
  final TextCapitalization? textCapitalization;
  final ValueChanged<String>? viewOnChanged;
  final ValueChanged<String>? viewOnSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final SmartDashesType? smartDashesType;
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
      final Iterable<Widget> suggestions =
          await widget.suggestionsBuilder(context, widget.searchController);
      if (mounted) {
        setState(() => _suggestions = suggestions);
      }
    });
  }

  Future<void> _updateSuggestions() async {
    _searchValue = widget.searchController.text;
    final Iterable<Widget> suggestions =
        await widget.suggestionsBuilder(context, widget.searchController);
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
      variant: M3EIconButtonVariant.standard,
      tooltip: M3ESearchConstants.backButtonTooltip,
      onPressed: () => Navigator.of(context).pop(),
    );

    final List<Widget> defaultTrailing = <Widget>[
      if (widget.searchController.text.isNotEmpty)
        M3EIconButton(
          icon: const Icon(M3EIcons.close),
          variant: M3EIconButtonVariant.standard,
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
    OutlinedBorder effectiveShape = widget.viewShape ??
        (widget.showFullScreenView
            ? viewTheme.fullScreenShape() as OutlinedBorder
            : viewTheme.dockedShape(viewTheme.cornerRadius) as OutlinedBorder);
    if (effectiveSide != null) {
      effectiveShape = effectiveShape.copyWith(side: effectiveSide);
    }
    final Color effectiveDividerColor =
        widget.dividerColor ?? viewTheme.dividerColor(scheme);
    final double? effectiveHeaderHeight = widget.viewHeaderHeight ??
        (widget.showFullScreenView ? viewTheme.headerHeight : null);
    final BoxConstraints? headerConstraints = effectiveHeaderHeight == null
        ? null
        : BoxConstraints.tightFor(height: effectiveHeaderHeight);
    final TextStyle effectiveTextStyle = widget.viewHeaderTextStyle ??
        viewTheme.headerTextStyle(theme.typeScale, scheme);
    final TextStyle effectiveHintStyle = widget.viewHeaderHintStyle ??
        widget.viewHeaderTextStyle ??
        viewTheme.headerHintStyle(theme.typeScale, scheme);
    final EdgeInsetsGeometry effectivePadding = widget.viewPadding ?? EdgeInsets.zero;
    final EdgeInsetsGeometry effectiveBarPadding =
        widget.viewBarPadding ?? viewTheme.barPadding();
    final EdgeInsetsGeometry fullScreenHeaderPadding =
        viewTheme.fullScreenHeaderPadding();
    final BoxConstraints effectiveConstraints =
        widget.viewConstraints ?? viewTheme.constraints();
    final double minWidth =
        math.min(effectiveConstraints.minWidth, _viewRect.width);
    final double minHeight =
        math.min(effectiveConstraints.minHeight, _viewRect.height);
    final bool effectiveShrinkWrap =
        widget.shrinkWrap ?? viewTheme.shrinkWrap;
    final double headerBlockHeight = effectiveHeaderHeight ??
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
            textStyle: WidgetStatePropertyAll<TextStyle>(
              effectiveTextStyle,
            ),
            hintStyle: WidgetStatePropertyAll<TextStyle>(
              effectiveHintStyle,
            ),
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
                                        bottom: MediaQuery.viewInsetsOf(context)
                                            .bottom,
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
class M3ESearchViewRoute extends PopupRoute<void> {
  M3ESearchViewRoute({
    required this.anchorKey,
    required this.searchController,
    required this.suggestionsBuilder,
    required this.showFullScreenView,
    this.toggleVisibility,
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
    this.viewOnOpen,
    this.viewOnClose,
    this.textInputAction,
    this.keyboardType,
    this.smartDashesType,
    this.smartQuotesType,
  });

  final GlobalKey anchorKey;
  final M3ESearchController searchController;
  final M3ESearchSuggestionsBuilder suggestionsBuilder;
  final bool showFullScreenView;
  final ValueGetter<bool>? toggleVisibility;
  final M3ESearchViewBuilder? viewBuilder;
  final Widget? viewLeading;
  final Iterable<Widget>? viewTrailing;
  final String? viewHintText;
  final Color? viewBackgroundColor;
  final double? viewElevation;
  final Color? viewSurfaceTintColor;
  final BorderSide? viewSide;
  final OutlinedBorder? viewShape;
  final EdgeInsetsGeometry? viewBarPadding;
  final double? viewHeaderHeight;
  final TextStyle? viewHeaderTextStyle;
  final TextStyle? viewHeaderHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final EdgeInsetsGeometry? viewPadding;
  final bool? shrinkWrap;
  final TextCapitalization? textCapitalization;
  final ValueChanged<String>? viewOnChanged;
  final ValueChanged<String>? viewOnSubmitted;
  final VoidCallback? viewOnOpen;
  final VoidCallback? viewOnClose;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

  final RectTween _rectTween = RectTween();
  CurvedAnimation? _curvedAnimation;
  CurvedAnimation? _viewFadeCurve;

  Rect? _anchorRect(BuildContext context) {
    final BuildContext? anchorContext = anchorKey.currentContext;
    if (anchorContext == null) {
      return null;
    }
    final RenderBox searchBarBox = anchorContext.findRenderObject()! as RenderBox;
    final NavigatorState navigator = Navigator.of(context);
    final Offset boxLocation = searchBarBox.localToGlobal(
      Offset.zero,
      ancestor: navigator.context.findRenderObject(),
    );
    return boxLocation & searchBarBox.size;
  }

  void _updateTweens(BuildContext context, M3ESearchViewTheme viewTheme) {
    final RenderBox navigatorBox =
        Navigator.of(context).context.findRenderObject()! as RenderBox;
    final Size screenSize = navigatorBox.size;
    final Rect anchorRect = _anchorRect(context) ?? Rect.zero;
    final BoxConstraints effectiveConstraints =
        viewConstraints ?? viewTheme.constraints();
    _rectTween.begin = anchorRect;

    final double viewWidth = clampDouble(
      anchorRect.width,
      effectiveConstraints.minWidth,
      effectiveConstraints.maxWidth,
    );
    final double viewHeight = clampDouble(
      screenSize.height * 2 / 3,
      effectiveConstraints.minHeight,
      effectiveConstraints.maxHeight,
    );

    final TextDirection textDirection = Directionality.of(context);
    switch (textDirection) {
      case TextDirection.ltr:
        final double viewLeftToScreenRight = screenSize.width - anchorRect.left;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;
        Offset topLeft = anchorRect.topLeft;
        if (viewLeftToScreenRight < viewWidth) {
          topLeft = Offset(
            screenSize.width - math.min(viewWidth, screenSize.width),
            topLeft.dy,
          );
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(
            topLeft.dx,
            screenSize.height - math.min(viewHeight, screenSize.height),
          );
        }
        _rectTween.end = showFullScreenView
            ? Offset.zero & screenSize
            : (topLeft & Size(viewWidth, viewHeight));
      case TextDirection.rtl:
        final double viewRightToScreenLeft = anchorRect.right;
        final double viewTopToScreenBottom = screenSize.height - anchorRect.top;
        var topLeft = Offset(
          math.max(anchorRect.right - viewWidth, 0),
          anchorRect.top,
        );
        if (viewRightToScreenLeft < viewWidth) {
          topLeft = Offset(0, topLeft.dy);
        }
        if (viewTopToScreenBottom < viewHeight) {
          topLeft = Offset(
            topLeft.dx,
            screenSize.height - math.min(viewHeight, screenSize.height),
          );
        }
        _rectTween.end = showFullScreenView
            ? Offset.zero & screenSize
            : (topLeft & Size(viewWidth, viewHeight));
    }
  }

  @override
  Color? get barrierColor => const Color(0x00000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => M3ESearchConstants.dismissBarrierLabel;

  @override
  Duration get transitionDuration => M3ESearchConstants.openViewDuration;

  @override
  TickerFuture didPush() {
    assert(anchorKey.currentContext != null);
    final BuildContext anchorContext = anchorKey.currentContext!;
    _updateTweens(anchorContext, M3ETheme.of(anchorContext).searchViewTheme);
    toggleVisibility?.call();
    viewOnOpen?.call();
    return super.didPush();
  }

  @override
  bool didPop(void result) {
    assert(anchorKey.currentContext != null);
    final BuildContext anchorContext = anchorKey.currentContext!;
    _updateTweens(anchorContext, M3ETheme.of(anchorContext).searchViewTheme);
    toggleVisibility?.call();
    viewOnClose?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (anchorKey.currentContext != null) {
        FocusScope.of(anchorKey.currentContext!).unfocus();
      }
    });
    return super.didPop(result);
  }

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    _viewFadeCurve?.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        _curvedAnimation ??= CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
        );
        _viewFadeCurve ??= CurvedAnimation(
          parent: animation,
          curve: M3ESearchConstants.viewFadeOnInterval,
          reverseCurve: M3ESearchConstants.viewFadeOnInterval.flipped,
        );

        final Rect viewRect = _rectTween.evaluate(_curvedAnimation!)!;
        final double topPadding = showFullScreenView
            ? lerpDouble(
                0,
                MediaQuery.paddingOf(context).top,
                _curvedAnimation!.value,
              )!
            : 0;

        return M3EComponentTheme(
          builder: (BuildContext context) {
            return FadeTransition(
              opacity: _viewFadeCurve!,
              child: M3ESearchViewContent(
                searchController: searchController,
                suggestionsBuilder: suggestionsBuilder,
                animation: _curvedAnimation!,
                viewRect: viewRect,
                viewMaxWidth: _rectTween.end!.width,
                topPadding: topPadding,
                showFullScreenView: showFullScreenView,
                viewBuilder: viewBuilder,
                viewLeading: viewLeading,
                viewTrailing: viewTrailing,
                viewHintText: viewHintText,
                viewBackgroundColor: viewBackgroundColor,
                viewElevation: viewElevation,
                viewSurfaceTintColor: viewSurfaceTintColor,
                viewSide: viewSide,
                viewShape: viewShape,
                viewBarPadding: viewBarPadding,
                viewHeaderHeight: viewHeaderHeight,
                viewHeaderTextStyle: viewHeaderTextStyle,
                viewHeaderHintStyle: viewHeaderHintStyle,
                dividerColor: dividerColor,
                viewConstraints: viewConstraints,
                viewPadding: viewPadding,
                shrinkWrap: shrinkWrap,
                textCapitalization: textCapitalization,
                viewOnChanged: viewOnChanged,
                viewOnSubmitted: viewOnSubmitted,
                textInputAction: textInputAction,
                keyboardType: keyboardType,
                smartDashesType: smartDashesType,
                smartQuotesType: smartQuotesType,
              ),
            );
          },
        );
      },
    );
  }
}
