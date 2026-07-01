/// Size variants for a linear progress indicator.
///
/// Mirrors `LinearProgressM3ESize` from the reference implementation.
enum M3ELinearProgressSize {
  /// Small track.
  s,

  /// Medium track.
  m,
}

/// The stroke shape of a progress indicator.
///
/// Mirrors `ProgressM3EShape` from the reference implementation.
enum M3EProgressShape {
  /// A straight track.
  flat,

  /// A sinusoidal, expressive wavy track.
  wavy,
}
