/// The position of a card within a list, used to determine its corner radii.
enum M3ECardPosition {
  /// The first item in a list with more than one item.
  first,

  /// An item between the first and last items.
  middle,

  /// The last item in a list with more than one item.
  last,

  /// The only item in a list.
  single,
}
