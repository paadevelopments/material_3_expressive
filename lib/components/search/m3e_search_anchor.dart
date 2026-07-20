import 'package:flutter/material.dart'
    show
        EditableTextContextMenuBuilder,
        WidgetStateProperty,
        WidgetStatePropertyAll;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_search_view.dart';
import 'controllers/m3e_search_controller.dart';
import 'm3e_search_bar.dart';
import 'res/m3e_search_constants.dart';

/// Manages a search view route opened from a search bar or custom anchor.
class M3ESearchAnchor extends StatefulWidget {
  const M3ESearchAnchor({
    required this.builder,
    required this.suggestionsBuilder,
    super.key,
    this.isFullScreen,
    this.searchController,
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
    this.headerHeight,
    this.headerTextStyle,
    this.headerHintStyle,
    this.dividerColor,
    this.viewConstraints,
    this.viewPadding,
    this.shrinkWrap,
    this.textCapitalization,
    this.viewOnChanged,
    this.viewOnSubmitted,
    this.viewOnClose,
    this.viewOnOpen,
    this.textInputAction,
    this.keyboardType,
    this.enabled = true,
    this.smartDashesType,
    this.smartQuotesType,
  });

  /// Creates an anchor with a default [M3ESearchBar] child.
  factory M3ESearchAnchor.bar({
    Key? key,
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    String? barHintText,
    GestureTapCallback? onTap,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    VoidCallback? onClose,
    VoidCallback? onOpen,
    WidgetStateProperty<double?>? barElevation,
    WidgetStateProperty<Color?>? barBackgroundColor,
    WidgetStateProperty<Color?>? barOverlayColor,
    WidgetStateProperty<BorderSide?>? barSide,
    WidgetStateProperty<OutlinedBorder?>? barShape,
    WidgetStateProperty<EdgeInsetsGeometry?>? barPadding,
    EdgeInsetsGeometry? viewBarPadding,
    WidgetStateProperty<TextStyle?>? barTextStyle,
    WidgetStateProperty<TextStyle?>? barHintStyle,
    M3ESearchViewBuilder? viewBuilder,
    Widget? viewLeading,
    Iterable<Widget>? viewTrailing,
    String? viewHintText,
    Color? viewBackgroundColor,
    double? viewElevation,
    BorderSide? viewSide,
    OutlinedBorder? viewShape,
    double? viewHeaderHeight,
    TextStyle? viewHeaderTextStyle,
    TextStyle? viewHeaderHintStyle,
    Color? dividerColor,
    BoxConstraints? constraints,
    BoxConstraints? viewConstraints,
    EdgeInsetsGeometry? viewPadding,
    bool? shrinkWrap,
    bool? isFullScreen,
    required M3ESearchController searchController,
    TextCapitalization textCapitalization = TextCapitalization.none,
    required M3ESearchSuggestionsBuilder suggestionsBuilder,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    EdgeInsets scrollPadding = const EdgeInsets.all(20),
    EditableTextContextMenuBuilder contextMenuBuilder =
        m3eDefaultSearchContextMenuBuilder,
    bool enabled = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
  }) {
    return M3ESearchAnchor(
      key: key,
      isFullScreen: isFullScreen,
      searchController: searchController,
      viewBuilder: viewBuilder,
      viewLeading: viewLeading,
      viewTrailing: viewTrailing,
      viewHintText: viewHintText ?? barHintText,
      viewBackgroundColor: viewBackgroundColor,
      viewElevation: viewElevation,
      viewSide: viewSide,
      viewShape: viewShape,
      viewBarPadding: viewBarPadding,
      headerHeight: viewHeaderHeight,
      headerTextStyle: viewHeaderTextStyle,
      headerHintStyle: viewHeaderHintStyle,
      dividerColor: dividerColor,
      viewConstraints: viewConstraints,
      viewPadding: viewPadding,
      shrinkWrap: shrinkWrap,
      textCapitalization: textCapitalization,
      viewOnSubmitted: onSubmitted,
      viewOnChanged: onChanged,
      viewOnClose: onClose,
      viewOnOpen: onOpen,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      enabled: enabled,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      suggestionsBuilder: suggestionsBuilder,
      builder: (BuildContext context, M3ESearchController controller) {
        return M3ESearchBar(
          constraints: constraints,
          controller: controller,
          onTap: () {
            controller.openView();
            onTap?.call();
          },
          onChanged: (String value) {
            controller.openView();
            onChanged?.call(value);
          },
          onSubmitted: onSubmitted,
          hintText: barHintText,
          hintStyle: barHintStyle,
          textStyle: barTextStyle,
          elevation: barElevation,
          backgroundColor: barBackgroundColor,
          overlayColor: barOverlayColor,
          side: barSide,
          shape: barShape,
          padding: barPadding ??
              const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16),
              ),
          leading: barLeading ?? const Icon(M3EIcons.search),
          trailing: barTrailing,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          scrollPadding: scrollPadding,
          contextMenuBuilder: contextMenuBuilder,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
        );
      },
    );
  }

  final bool? isFullScreen;
  final M3ESearchController? searchController;
  final M3ESearchAnchorChildBuilder builder;
  final M3ESearchSuggestionsBuilder suggestionsBuilder;
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
  final double? headerHeight;
  final TextStyle? headerTextStyle;
  final TextStyle? headerHintStyle;
  final Color? dividerColor;
  final BoxConstraints? viewConstraints;
  final EdgeInsetsGeometry? viewPadding;
  final bool? shrinkWrap;
  final TextCapitalization? textCapitalization;
  final ValueChanged<String>? viewOnChanged;
  final ValueChanged<String>? viewOnSubmitted;
  final VoidCallback? viewOnClose;
  final VoidCallback? viewOnOpen;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool enabled;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

  @override
  State<M3ESearchAnchor> createState() => _M3ESearchAnchorState();
}

class _M3ESearchAnchorState extends State<M3ESearchAnchor>
    implements M3ESearchAnchorHandle {
  Size? _screenSize;
  bool _anchorIsVisible = true;
  final GlobalKey _anchorKey = GlobalKey();
  M3ESearchController? _internalSearchController;
  M3ESearchViewRoute? _route;

  M3ESearchController get _searchController => widget.searchController ??
      (_internalSearchController ??= M3ESearchController());

  @override
  bool get viewIsOpen => !_anchorIsVisible;

  @override
  void initState() {
    super.initState();
    _searchController.attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Size updatedScreenSize = MediaQuery.sizeOf(context);
    if (_screenSize != null &&
        _screenSize != updatedScreenSize &&
        _searchController.isAttached &&
        viewIsOpen &&
        !_showFullScreenView()) {
      closeView(null);
    }
    _screenSize = updatedScreenSize;
  }

  @override
  void didUpdateWidget(M3ESearchAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != widget.searchController) {
      oldWidget.searchController?.detach(this);
      _searchController.attach(this);
    }
  }

  @override
  void dispose() {
    widget.searchController?.detach(this);
    _internalSearchController?.detach(this);
    final bool usingExternalController = widget.searchController != null;
    if (_route?.navigator != null) {
      if (_route!.isActive) {
        _route!.navigator?.removeRoute(_route!);
      }
      if (!usingExternalController) {
        _internalSearchController?.dispose();
      }
    } else {
      _internalSearchController?.dispose();
    }
    super.dispose();
  }

  bool _showFullScreenView() {
    if (widget.isFullScreen != null) {
      return widget.isFullScreen!;
    }
    final TargetPlatform platform = M3ETheme.platformOf(context);
    return switch (platform) {
      TargetPlatform.iOS ||
      TargetPlatform.android ||
      TargetPlatform.fuchsia =>
        true,
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows =>
        false,
    };
  }

  @override
  void openView() {
    if (viewIsOpen) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    _route = M3ESearchViewRoute(
      anchorKey: _anchorKey,
      searchController: _searchController,
      suggestionsBuilder: widget.suggestionsBuilder,
      showFullScreenView: _showFullScreenView(),
      toggleVisibility: _toggleVisibility,
      viewBuilder: widget.viewBuilder,
      viewLeading: widget.viewLeading,
      viewTrailing: widget.viewTrailing,
      viewHintText: widget.viewHintText,
      viewBackgroundColor: widget.viewBackgroundColor,
      viewElevation: widget.viewElevation,
      viewSurfaceTintColor: widget.viewSurfaceTintColor,
      viewSide: widget.viewSide,
      viewShape: widget.viewShape,
      viewBarPadding: widget.viewBarPadding,
      viewHeaderHeight: widget.headerHeight,
      viewHeaderTextStyle: widget.headerTextStyle,
      viewHeaderHintStyle: widget.headerHintStyle,
      dividerColor: widget.dividerColor,
      viewConstraints: widget.viewConstraints,
      viewPadding: widget.viewPadding,
      shrinkWrap: widget.shrinkWrap,
      textCapitalization: widget.textCapitalization,
      viewOnChanged: widget.viewOnChanged,
      viewOnSubmitted: widget.viewOnSubmitted,
      viewOnOpen: widget.viewOnOpen,
      viewOnClose: widget.viewOnClose,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
    );
    navigator.push(_route!);
  }

  @override
  void closeView(String? selectedText) {
    if (selectedText != null) {
      _searchController.value = TextEditingValue(text: selectedText);
    }
    Navigator.of(context).pop();
  }

  bool _toggleVisibility() {
    setState(() => _anchorIsVisible = !_anchorIsVisible);
    return _anchorIsVisible;
  }

  double _opacity() {
    if (!widget.enabled) {
      return M3ESearchConstants.disabledOpacity;
    }
    return _anchorIsVisible ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      key: _anchorKey,
      opacity: _opacity(),
      duration: M3ESearchConstants.anchorFadeDuration,
      child: IgnorePointer(
        ignoring: !widget.enabled,
        child: widget.builder(context, _searchController),
      ),
    );
  }
}
