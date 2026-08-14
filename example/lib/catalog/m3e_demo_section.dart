/// Gallery sections matching the bottom navigation destinations.
enum M3EDemoSection {
  /// Actions — Do.
  doSection,

  /// Selection — Pick.
  pickSection,

  /// Containment — View.
  viewSection,

  /// Navigation — Nav.
  navSection,

  /// Feedback / input — Find.
  findSection,
}

/// Display label for [M3EDemoSection] (matches bottom nav).
extension M3EDemoSectionLabel on M3EDemoSection {
  /// Short nav label.
  String get navLabel {
    return switch (this) {
      M3EDemoSection.doSection => 'Do',
      M3EDemoSection.pickSection => 'Pick',
      M3EDemoSection.viewSection => 'View',
      M3EDemoSection.navSection => 'Nav',
      M3EDemoSection.findSection => 'Find',
    };
  }

  /// Planned batch number for stub copy.
  int get batchNumber {
    return switch (this) {
      M3EDemoSection.doSection => 1,
      M3EDemoSection.pickSection => 2,
      M3EDemoSection.viewSection => 3,
      M3EDemoSection.navSection => 4,
      M3EDemoSection.findSection => 5,
    };
  }
}
