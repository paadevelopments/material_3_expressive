import 'package:flutter/widgets.dart';

/// A curated set of glyphs from the bundled `MaterialIcons` font.
///
/// Components use these so the library stays independent of the framework's
/// `material` icon catalogue while still rendering familiar symbols.
abstract final class M3EIcons {
  const M3EIcons._();

  static const IconData check = IconData(0xe5ca, fontFamily: 'MaterialIcons');
  static const IconData close = IconData(0xe5cd, fontFamily: 'MaterialIcons');
  static const IconData add = IconData(0xe145, fontFamily: 'MaterialIcons');
  static const IconData remove = IconData(0xe15b, fontFamily: 'MaterialIcons');
  static const IconData arrowDropDown =
      IconData(0xe5c5, fontFamily: 'MaterialIcons');
  static const IconData arrowDropUp =
      IconData(0xe5c7, fontFamily: 'MaterialIcons');
  static const IconData keyboardArrowDown =
      IconData(0xe313, fontFamily: 'MaterialIcons');
  static const IconData keyboardArrowUp =
      IconData(0xe316, fontFamily: 'MaterialIcons');
  static const IconData chevronLeft =
      IconData(0xe5cb, fontFamily: 'MaterialIcons');
  static const IconData chevronRight =
      IconData(0xe5cc, fontFamily: 'MaterialIcons');
  static const IconData arrowBack =
      IconData(0xe5c4, fontFamily: 'MaterialIcons');
  static const IconData arrowForward =
      IconData(0xe5c8, fontFamily: 'MaterialIcons');
  static const IconData moreVert =
      IconData(0xe5d4, fontFamily: 'MaterialIcons');
  static const IconData menu = IconData(0xe5d2, fontFamily: 'MaterialIcons');
  static const IconData search = IconData(0xe8b6, fontFamily: 'MaterialIcons');
  static const IconData calendarToday =
      IconData(0xe935, fontFamily: 'MaterialIcons');
  static const IconData schedule =
      IconData(0xe8b5, fontFamily: 'MaterialIcons');
  static const IconData error = IconData(0xe000, fontFamily: 'MaterialIcons');
  static const IconData edit = IconData(0xe3c9, fontFamily: 'MaterialIcons');
}
