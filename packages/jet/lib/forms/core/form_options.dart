/// Options and enums for Jet Form fields.
library;

/// Orientation options for groups of fields (checkboxes, radio buttons, etc.)
enum OptionsOrientation {
  /// Display options horizontally in a row
  horizontal,

  /// Display options vertically in a column
  vertical,

  /// Wrap options when they exceed available space
  wrap,

  /// Automatically choose the best layout
  auto,
}

/// Position of control (checkbox/radio) relative to label
enum ControlAffinity {
  /// Control appears before the label (left/top)
  leading,

  /// Control appears after the label (right/bottom)
  trailing,
}
