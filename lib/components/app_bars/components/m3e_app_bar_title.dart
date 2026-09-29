part of '../m3e_app_bars.dart';

/// Reports whether the app bar's content has scrolled under it.
class _M3EScrolledUnder extends InheritedWidget {
  const _M3EScrolledUnder({required this.scrolledUnder, required super.child});

  final bool scrolledUnder;

  static bool of(BuildContext context) {
    final _M3EScrolledUnder? scope = context
        .dependOnInheritedWidgetOfExactType<_M3EScrolledUnder>();
    return scope?.scrolledUnder ?? false;
  }

  @override
  bool updateShouldNotify(_M3EScrolledUnder oldWidget) {
    return scrolledUnder != oldWidget.scrolledUnder;
  }
}

/// Headline and subtitle, announced as a header.
class _M3ETitleBlock extends StatelessWidget {
  const _M3ETitleBlock({
    required this.title,
    required this.subtitle,
    required this.centerTitle,
  });

  final Widget? title;
  final Widget? subtitle;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    if (title == null && subtitle == null) {
      return const SizedBox.shrink();
    }
    return Semantics(
      header: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: <Widget>[?title, ?subtitle],
      ),
    );
  }
}

Widget? _headline({
  required Widget? title,
  required String? titleText,
  required TextStyle style,
  required bool centerTitle,
  required bool wrap,
}) {
  if (title != null) {
    return DefaultTextStyle(style: style, child: title);
  }
  if (titleText == null) {
    return null;
  }
  return Text(
    titleText,
    style: style,
    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
    maxLines: wrap ? null : 1,
    overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
  );
}

Widget? _supporting({
  required Widget? subtitle,
  required String? subtitleText,
  required TextStyle style,
  required bool centerTitle,
  required bool wrap,
}) {
  if (subtitle != null) {
    return DefaultTextStyle(style: style, child: subtitle);
  }
  if (subtitleText == null) {
    return null;
  }
  return Text(
    subtitleText,
    style: style,
    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
    maxLines: wrap ? null : 1,
    overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
  );
}

Widget? _maybeBackButton(BuildContext context, Color color) {
  final bool canPop = Navigator.maybeOf(context)?.canPop() ?? false;
  if (!canPop) {
    return null;
  }
  final String message = MaterialLocalizations.of(context).backButtonTooltip;
  return M3ETooltip(
    message: message,
    dismissDelay: Duration.zero,
    child: IconButton(
      icon: const BackButtonIcon(),
      color: color,
      onPressed: () => Navigator.maybeOf(context)?.maybePop(),
    ),
  );
}

/// Anchored search title sized to the search-bar spec.
class _M3EAppBarSearchTitle extends StatelessWidget {
  const _M3EAppBarSearchTitle({
    required this.searchController,
    required this.suggestionsBuilder,
    this.barHintText,
    this.barLeading,
    this.barTrailing,
    this.barBackgroundColor,
    this.barAlignment = Alignment.center,
    this.wrapActions = false,
    this.isFullScreen = true,
    this.onSubmitted,
    this.onChanged,
    this.onClose,
    this.onOpen,
    this.searchConstraints,
  });

  final M3ESearchController searchController;
  final M3ESearchSuggestionsBuilder suggestionsBuilder;
  final String? barHintText;
  final Widget? barLeading;
  final Iterable<Widget>? barTrailing;
  final WidgetStateProperty<Color?>? barBackgroundColor;
  final AlignmentGeometry barAlignment;
  final bool wrapActions;
  final bool isFullScreen;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;
  final BoxConstraints? searchConstraints;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final bool under = _M3EScrolledUnder.of(context);
    final Color field = appBarTheme.searchFieldColor(
      scheme,
      scrolledUnder: under,
    );
    final TextStyle input = appBarTheme.searchTextStyle(
      theme.typeScale,
      scheme,
    );
    final TextStyle hint = appBarTheme.searchHintStyle(theme.typeScale, scheme);
    return M3ESearchAnchor.bar(
      searchController: searchController,
      suggestionsBuilder: suggestionsBuilder,
      barHintText: barHintText,
      barLeading: barLeading,
      barTrailing: barTrailing,
      barAlignment: barAlignment,
      wrapActions: wrapActions,
      barBackgroundColor:
          barBackgroundColor ?? WidgetStatePropertyAll<Color>(field),
      barElevation: WidgetStatePropertyAll<double>(appBarTheme.searchElevation),
      barShape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appBarTheme.searchBarRadius),
        ),
      ),
      barPadding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: appBarTheme.titleGap),
      ),
      barOverlayColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return scheme.onSurface.withValues(alpha: appBarTheme.pressedOpacity);
        }
        if (states.contains(WidgetState.hovered)) {
          return scheme.onSurface.withValues(alpha: appBarTheme.hoverOpacity);
        }
        return null;
      }),
      barTextStyle: WidgetStatePropertyAll<TextStyle>(input),
      barHintStyle: WidgetStatePropertyAll<TextStyle>(hint),
      viewBackgroundColor: appBarTheme.searchViewColor(scheme),
      viewElevation: appBarTheme.searchViewElevation,
      viewHeaderHeight: isFullScreen
          ? appBarTheme.searchFullScreenHeader
          : appBarTheme.searchDockedHeader,
      dividerColor: scheme.outline,
      isFullScreen: isFullScreen,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onClose: onClose,
      onOpen: onOpen,
      constraints:
          searchConstraints ??
          BoxConstraints.tightFor(height: appBarTheme.searchBarHeight),
      expandOnFocus: false,
      expandRestPadding: 0,
    );
  }
}
