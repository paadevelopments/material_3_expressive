import 'package:flutter/widgets.dart';

import '../components/bottom_sheets/bottom_sheets.dart';
import '../components/buttons/enums/m3e_button_enums.dart';
import '../components/cards/cards.dart';
import '../components/carousel/carousel.dart';
import '../components/dialogs/dialogs.dart';
import '../components/divider/divider.dart';
import '../components/lists/lists.dart';
import '../components/side_sheets/side_sheets.dart';
import '../foundations/m3e_motion.dart';

/// Static factories for the Material 3 *Containment* components, such as
/// `M3EContainment.card(...)` and `M3EContainment.showBottomSheet(...)`.
class M3EContainment {
  const M3EContainment._();

  /// Creates a card. See [M3ECard].
  static Widget card({
    required Widget child,
    M3ECardVariant variant = M3ECardVariant.elevated,
    VoidCallback? onPressed,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Key? key,
  }) {
    return M3ECard(
      key: key,
      variant: variant,
      onPressed: onPressed,
      padding: padding,
      child: child,
    );
  }

  /// Creates a carousel. See [M3ECarousel].
  static Widget carousel({
    required List<Widget> children,
    double? width,
    double? height,
    M3ECarouselType type = M3ECarouselType.hero,
    bool isExtended = false,
    bool freeScroll = false,
    M3ECarouselHeroAlignment heroAlignment = M3ECarouselHeroAlignment.center,
    double uncontainedItemExtent = 270,
    double uncontainedShrinkExtent = 150,
    double childElementBorderRadius = 28,
    int scrollAnimationDuration = 500,
    int singleSwipeGestureSensitivityRange = 300,
    void Function(int selectedIndex)? onTap,
    Key? key,
  }) {
    return M3ECarousel(
      key: key,
      width: width,
      height: height,
      type: type,
      isExtended: isExtended,
      freeScroll: freeScroll,
      heroAlignment: heroAlignment,
      uncontainedItemExtent: uncontainedItemExtent,
      uncontainedShrinkExtent: uncontainedShrinkExtent,
      childElementBorderRadius: childElementBorderRadius,
      scrollAnimationDuration: scrollAnimationDuration,
      singleSwipeGestureSensitivityRange: singleSwipeGestureSensitivityRange,
      onTap: onTap,
      children: children,
    );
  }

  /// Creates a divider. See [M3EDivider].
  static Widget divider({
    M3EDividerAxis axis = M3EDividerAxis.horizontal,
    double thickness = 1,
    double indent = 0,
    double endIndent = 0,
    Color? color,
    Key? key,
  }) {
    return M3EDivider(
      key: key,
      axis: axis,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  /// Creates a list item. See [M3EListItem].
  static Widget listItem({
    required String headline,
    String? supportingText,
    String? overline,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool selected = false,
    Key? key,
  }) {
    return M3EListItem(
      key: key,
      headline: headline,
      supportingText: supportingText,
      overline: overline,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      selected: selected,
    );
  }

  /// Creates a card-based list. See [M3ECardList].
  static Widget cardList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    double outerRadius = M3ECardListTokens.outerRadius,
    double innerRadius = M3ECardListTokens.innerRadius,
    double gap = M3ECardListTokens.gap,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    void Function(int index)? onTap,
    void Function(int index)? onLongPress,
    String Function(int index)? semanticLabelBuilder,
    MouseCursor? mouseCursor,
    M3EHapticFeedback haptic = M3EHapticFeedback.none,
    Widget? emptyBuilder,
    Key? key,
  }) {
    return M3ECardList(
      key: key,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabelBuilder: semanticLabelBuilder,
      mouseCursor: mouseCursor,
      haptic: haptic,
      emptyBuilder: emptyBuilder,
    );
  }

  /// Creates a card-based list using a scrollable builder. See [M3ECardList.builder].
  static Widget cardListBuilder({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    double outerRadius = M3ECardListTokens.outerRadius,
    double innerRadius = M3ECardListTokens.innerRadius,
    double gap = M3ECardListTokens.gap,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    void Function(int index)? onTap,
    void Function(int index)? onLongPress,
    String Function(int index)? semanticLabelBuilder,
    MouseCursor? mouseCursor,
    M3EHapticFeedback haptic = M3EHapticFeedback.none,
    Widget? emptyBuilder,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? listPadding,
    Key? key,
  }) {
    return M3ECardList.builder(
      key: key,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      padding: padding,
      margin: margin,
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabelBuilder: semanticLabelBuilder,
      mouseCursor: mouseCursor,
      haptic: haptic,
      emptyBuilder: emptyBuilder,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      listPadding: listPadding,
    );
  }

  /// Creates a dismissible list. See [M3EDismissibleList].
  static Widget dismissibleList({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    M3EDismissibleListStyle style = const M3EDismissibleListStyle(),
    ScrollPhysics? physics,
    ScrollController? scrollController,
    EdgeInsetsGeometry? listPadding,
    bool shrinkWrap = false,
    Clip clipBehavior = Clip.hardEdge,
    Key? key,
  }) {
    return M3EDismissibleList(
      key: key,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onDismiss: onDismiss,
      onTap: onTap,
      style: style,
      physics: physics,
      scrollController: scrollController,
      listPadding: listPadding,
      shrinkWrap: shrinkWrap,
      clipBehavior: clipBehavior,
    );
  }

  /// Creates a dismissible column. See [M3EDismissibleColumn].
  static Widget dismissibleColumn({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    M3EDismissibleListStyle style = const M3EDismissibleListStyle(),
    Key? key,
  }) {
    return M3EDismissibleColumn(
      key: key,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onDismiss: onDismiss,
      onTap: onTap,
      style: style,
    );
  }

  /// Creates an expandable card list. See [M3EExpandableCardList].
  static Widget expandableCardList({
    required List<M3EExpandableData> data,
    bool? allowMultipleExpanded,
    Set<int> initiallyExpanded = const {},
    M3EExpandableStyle? style,
    M3ESpring? expandMotion,
    M3ESpring? collapseMotion,
    void Function(int index, bool isExpanded)? onExpansionChanged,
    ScrollController? controller,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    Key? key,
  }) {
    return M3EExpandableCardList(
      key: key,
      data: data,
      allowMultipleExpanded: allowMultipleExpanded,
      initiallyExpanded: initiallyExpanded,
      style: style,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
      onExpansionChanged: onExpansionChanged,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
    );
  }

  /// Creates an expandable card column. See [M3EExpandableCardColumn].
  static Widget expandableCardColumn({
    required List<M3EExpandableData> data,
    bool? allowMultipleExpanded,
    Set<int> initiallyExpanded = const {},
    M3EExpandableStyle? style,
    M3ESpring? expandMotion,
    M3ESpring? collapseMotion,
    void Function(int index, bool isExpanded)? onExpansionChanged,
    Key? key,
  }) {
    return M3EExpandableCardColumn(
      key: key,
      data: data,
      allowMultipleExpanded: allowMultipleExpanded,
      initiallyExpanded: initiallyExpanded,
      style: style,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
      onExpansionChanged: onExpansionChanged,
    );
  }

  /// Builds a standard dialog surface. See [M3EDialog].
  static Widget dialog({
    required String title,
    Widget? icon,
    Widget? content,
    List<Widget> actions = const <Widget>[],
    Key? key,
  }) {
    return M3EDialog(
      key: key,
      title: title,
      icon: icon,
      content: content,
      actions: actions,
    );
  }

  /// Presents a standard dialog. See [M3EDialog.show].
  static Future<T?> showDialog<T>(
    BuildContext context, {
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return M3EDialog.show<T>(
      context,
      dialog: dialog,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Presents a full-screen dialog. See [M3EDialog.showFullScreen].
  static Future<T?> showFullScreenDialog<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    Widget? action,
  }) {
    return M3EDialog.showFullScreen<T>(
      context,
      title: title,
      body: body,
      action: action,
    );
  }

  /// Presents a modal bottom sheet. See [M3EBottomSheet.show].
  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool showDragHandle = true,
  }) {
    return M3EBottomSheet.show<T>(
      context,
      builder: builder,
      showDragHandle: showDragHandle,
    );
  }

  /// Presents a modal side sheet. See [M3ESideSheet.show].
  static Future<T?> showSideSheet<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget> actions = const <Widget>[],
  }) {
    return M3ESideSheet.show<T>(
      context,
      title: title,
      body: body,
      actions: actions,
    );
  }
}
