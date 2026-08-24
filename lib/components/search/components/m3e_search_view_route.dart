part of 'm3e_search_view.dart';

/// M3ESearchViewRoute.

class M3ESearchViewRoute extends PopupRoute<void> {
  /// M3ESearchViewRoute.
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

  /// anchorKey.

  final GlobalKey anchorKey;

  /// searchController.
  final M3ESearchController searchController;

  /// suggestionsBuilder.
  final M3ESearchSuggestionsBuilder suggestionsBuilder;

  /// showFullScreenView.
  final bool showFullScreenView;

  /// toggleVisibility.
  final ValueGetter<bool>? toggleVisibility;

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

  /// viewOnOpen.
  final VoidCallback? viewOnOpen;

  /// viewOnClose.
  final VoidCallback? viewOnClose;

  /// textInputAction.
  final TextInputAction? textInputAction;

  /// keyboardType.
  final TextInputType? keyboardType;

  /// smartDashesType.
  final SmartDashesType? smartDashesType;

  /// smartQuotesType.
  final SmartQuotesType? smartQuotesType;

  final RectTween _rectTween = RectTween();
  CurvedAnimation? _curvedAnimation;
  CurvedAnimation? _viewFadeCurve;

  Rect? _anchorRect(BuildContext context) {
    final BuildContext? anchorContext = anchorKey.currentContext;
    if (anchorContext == null) {
      return null;
    }
    final searchBarBox = anchorContext.findRenderObject()! as RenderBox;
    final NavigatorState navigator = Navigator.of(context);
    final Offset boxLocation = searchBarBox.localToGlobal(
      Offset.zero,
      ancestor: navigator.context.findRenderObject(),
    );
    return boxLocation & searchBarBox.size;
  }

  void _updateTweens(BuildContext context, M3ESearchViewTheme viewTheme) {
    final navigatorBox =
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
    assert(
      anchorKey.currentContext != null,
      'Search view route requires an attached anchor.',
    );
    final BuildContext anchorContext = anchorKey.currentContext!;
    _updateTweens(anchorContext, M3ETheme.of(anchorContext).searchViewTheme);
    toggleVisibility?.call();
    viewOnOpen?.call();
    return super.didPush();
  }

  @override
  bool didPop(void result) {
    assert(
      anchorKey.currentContext != null,
      'Search view route requires an attached anchor.',
    );
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
                M3ESafeArea.topOf(context),
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
