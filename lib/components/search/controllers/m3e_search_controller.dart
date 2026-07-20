import 'dart:async';

import 'package:flutter/widgets.dart';

/// Handle implemented by [M3ESearchAnchor] for [M3ESearchController].
abstract class M3ESearchAnchorHandle {
  bool get viewIsOpen;

  /// Whether focus on the anchor bar should avoid reopening the view.
  bool get suppressFocusOpen;

  void openView();

  void closeView(String? selectedText);
}

/// Controls a search view opened by [M3ESearchAnchor].
class M3ESearchController extends TextEditingController {
  M3ESearchAnchorHandle? _anchor;

  /// Whether this controller is attached to a search anchor.
  bool get isAttached => _anchor != null;

  /// Whether the associated search view is currently open.
  bool get isOpen {
    assert(isAttached);
    return _anchor!.viewIsOpen;
  }

  /// Whether the anchor should ignore focus-driven [openView] calls.
  bool get suppressFocusOpen {
    assert(isAttached);
    return _anchor!.suppressFocusOpen;
  }

  /// Opens the search view associated with this controller.
  void openView() {
    assert(isAttached);
    _anchor!.openView();
  }

  /// Closes the search view, optionally setting [selectedText].
  void closeView(String? selectedText) {
    assert(isAttached);
    _anchor!.closeView(selectedText);
  }

  // ignore: use_setters_to_change_properties
  void attach(M3ESearchAnchorHandle anchor) {
    _anchor = anchor;
  }

  void detach(M3ESearchAnchorHandle anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

/// Signature for building the search anchor child.
typedef M3ESearchAnchorChildBuilder = Widget Function(
  BuildContext context,
  M3ESearchController controller,
);

/// Signature for building search suggestions from the current query.
typedef M3ESearchSuggestionsBuilder = FutureOr<Iterable<Widget>> Function(
  BuildContext context,
  M3ESearchController controller,
);

/// Signature for laying out suggestion widgets in the search view.
typedef M3ESearchViewBuilder = Widget Function(Iterable<Widget> suggestions);
