import 'package:skeletonizer/skeletonizer.dart';

/// Skeleton effect types available for skeleton loading
///
/// These effects determine the animation style of the skeleton loader.
enum SkeletonEffect {
  /// Shimmer effect - a light sweeps across the skeleton
  ///
  /// Creates a shimmering animation that moves horizontally across
  /// the skeleton elements, giving a polished loading effect.
  shimmer,

  /// Pulse effect - elements fade in and out
  ///
  /// Creates a pulsing animation where skeleton elements fade
  /// in and out smoothly.
  pulse,

  /// Fade effect - simple fade animation
  ///
  /// Creates a subtle fade effect on skeleton elements.
  fade,
}

/// Configuration for skeleton loading states
///
/// This class provides comprehensive customization options for skeleton loaders,
/// allowing you to control effects, colors, timing, and behavior.
///
/// Example usage:
/// ```dart
/// // Use default shimmer effect
/// final config = SkeletonConfig();
///
/// // Custom shimmer with specific colors
/// final customConfig = SkeletonConfig.shimmer(
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.grey[100],
///   duration: Duration(seconds: 2),
/// );
///
/// // Pulse effect
/// final pulseConfig = SkeletonConfig.pulse();
///
/// // Fade effect
/// final fadeConfig = SkeletonConfig.fade();
/// ```
class SkeletonConfig {
  /// Whether skeleton loading is enabled
  final bool enabled;

  /// The effect type to use for skeleton animation
  final SkeletonEffect effect;

  /// Base color for skeleton elements
  ///
  /// If null, uses theme-appropriate defaults from skeletonizer package
  final Color? baseColor;

  /// Highlight color for skeleton animation
  ///
  /// Used in shimmer effects as the sweeping highlight color.
  /// If null, uses theme-appropriate defaults from skeletonizer package
  final Color? highlightColor;

  /// Duration of the skeleton animation cycle
  final Duration duration;

  /// Whether to ignore containers during skeletonization
  ///
  /// When true, container widgets won't be skeletonized but their
  /// children will be. This can create a cleaner skeleton effect.
  final bool ignoreContainers;

  /// Color to paint containers when not ignoring them
  ///
  /// If null, containers use their original colors.
  final Color? containersColor;

  /// Whether to justify multi-line text in skeleton mode
  ///
  /// When true, multi-line text skeletons will be justified to fill
  /// the available width, creating a more realistic skeleton effect.
  final bool justifyMultiLineText;

  /// Creates a skeleton configuration with custom settings
  const SkeletonConfig({
    this.enabled = true,
    this.effect = SkeletonEffect.shimmer,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.ignoreContainers = false,
    this.containersColor,
    this.justifyMultiLineText = true,
  });

  /// Creates a shimmer effect skeleton configuration
  ///
  /// This is the default and most common skeleton effect, featuring
  /// a horizontal sweep of light across skeleton elements.
  factory SkeletonConfig.shimmer({
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool ignoreContainers = false,
    Color? containersColor,
    bool justifyMultiLineText = true,
  }) {
    return SkeletonConfig(
      enabled: true,
      effect: SkeletonEffect.shimmer,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      ignoreContainers: ignoreContainers,
      containersColor: containersColor,
      justifyMultiLineText: justifyMultiLineText,
    );
  }

  /// Creates a pulse effect skeleton configuration
  ///
  /// Elements fade in and out with a pulsing animation.
  factory SkeletonConfig.pulse({
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool ignoreContainers = false,
    Color? containersColor,
    bool justifyMultiLineText = true,
  }) {
    return SkeletonConfig(
      enabled: true,
      effect: SkeletonEffect.pulse,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      ignoreContainers: ignoreContainers,
      containersColor: containersColor,
      justifyMultiLineText: justifyMultiLineText,
    );
  }

  /// Creates a fade effect skeleton configuration
  ///
  /// Simple fade animation on skeleton elements.
  factory SkeletonConfig.fade({
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
    bool ignoreContainers = false,
    Color? containersColor,
    bool justifyMultiLineText = true,
  }) {
    return SkeletonConfig(
      enabled: true,
      effect: SkeletonEffect.fade,
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: duration,
      ignoreContainers: ignoreContainers,
      containersColor: containersColor,
      justifyMultiLineText: justifyMultiLineText,
    );
  }

  /// Converts this config to a skeletonizer effect
  ///
  /// Internal method used by JetBuilder to convert the config
  /// into the actual skeletonizer effect widget.
  PaintingEffect toSkeletonizerEffect() {
    switch (effect) {
      case SkeletonEffect.shimmer:
        return ShimmerEffect(
          baseColor: baseColor ?? const Color(0xFFE0E0E0),
          highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
          duration: duration,
        );
      case SkeletonEffect.pulse:
        return PulseEffect(
          from: baseColor ?? const Color(0xFFE0E0E0),
          to: highlightColor ?? const Color(0xFFF5F5F5),
          duration: duration,
        );
      case SkeletonEffect.fade:
        return ShimmerEffect(
          baseColor: baseColor ?? const Color(0xFFE0E0E0),
          highlightColor: highlightColor ?? const Color(0xFFF5F5F5),
          duration: duration,
        );
    }
  }

  /// Creates a copy of this config with updated values
  SkeletonConfig copyWith({
    bool? enabled,
    SkeletonEffect? effect,
    Color? baseColor,
    Color? highlightColor,
    Duration? duration,
    bool? ignoreContainers,
    Color? containersColor,
    bool? justifyMultiLineText,
  }) {
    return SkeletonConfig(
      enabled: enabled ?? this.enabled,
      effect: effect ?? this.effect,
      baseColor: baseColor ?? this.baseColor,
      highlightColor: highlightColor ?? this.highlightColor,
      duration: duration ?? this.duration,
      ignoreContainers: ignoreContainers ?? this.ignoreContainers,
      containersColor: containersColor ?? this.containersColor,
      justifyMultiLineText: justifyMultiLineText ?? this.justifyMultiLineText,
    );
  }
}
