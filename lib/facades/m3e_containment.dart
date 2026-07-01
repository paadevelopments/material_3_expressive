import 'package:flutter/widgets.dart';

import '../components/bottom_sheets/bottom_sheets.dart';
import '../components/cards/cards.dart';
import '../components/carousel/carousel.dart';
import '../components/dialogs/dialogs.dart';
import '../components/divider/divider.dart';
import '../components/lists/lists.dart';
import '../components/side_sheets/side_sheets.dart';

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
    required List<Widget> items,
    double height = 200,
    double viewportFraction = 0.8,
    ValueChanged<int>? onItemSelected,
    Key? key,
  }) {
    return M3ECarousel(
      key: key,
      items: items,
      height: height,
      viewportFraction: viewportFraction,
      onItemSelected: onItemSelected,
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
