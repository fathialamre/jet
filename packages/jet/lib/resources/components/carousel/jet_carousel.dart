import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Controller for [JetCarousel] to programmatically control carousel state.
///
/// Allows controlling the current page, auto-play state, and navigation.
class JetCarouselController {
  JetCarouselController({int initialPage = 0}) : _currentPage = initialPage;

  int _currentPage;
  bool _isAutoPlaying = false;
  VoidCallback? _pauseCallback;
  VoidCallback? _resumeCallback;
  ValueChanged<int>? _jumpToPageCallback;
  VoidCallback? _nextPageCallback;
  VoidCallback? _previousPageCallback;

  /// Current page index (0-based).
  int get currentPage => _currentPage;

  /// Whether auto-play is currently active.
  bool get isAutoPlaying => _isAutoPlaying;

  /// Pause auto-play if it's running.
  void pause() {
    if (_isAutoPlaying) {
      _pauseCallback?.call();
    }
  }

  /// Resume auto-play if it was paused.
  void resume() {
    if (!_isAutoPlaying) {
      _resumeCallback?.call();
    }
  }

  /// Jump to a specific page.
  void jumpToPage(int page) {
    _jumpToPageCallback?.call(page);
  }

  /// Navigate to the next page.
  void nextPage() {
    _nextPageCallback?.call();
  }

  /// Navigate to the previous page.
  void previousPage() {
    _previousPageCallback?.call();
  }

  // Internal methods used by JetCarousel
  void _setCurrentPage(int page) {
    _currentPage = page;
  }

  void _setAutoPlaying(bool value) {
    _isAutoPlaying = value;
  }

  void _attachCallbacks({
    required VoidCallback onPause,
    required VoidCallback onResume,
    required ValueChanged<int> onJumpToPage,
    required VoidCallback onNextPage,
    required VoidCallback onPreviousPage,
  }) {
    _pauseCallback = onPause;
    _resumeCallback = onResume;
    _jumpToPageCallback = onJumpToPage;
    _nextPageCallback = onNextPage;
    _previousPageCallback = onPreviousPage;
  }

  void _detachCallbacks() {
    _pauseCallback = null;
    _resumeCallback = null;
    _jumpToPageCallback = null;
    _nextPageCallback = null;
    _previousPageCallback = null;
  }
}

/// Configuration options for the carousel page indicator.
///
/// Provides extensive customization for the smooth page indicator,
/// including size, colors, effects, and positioning.
class JetCarouselIndicatorOptions {
  const JetCarouselIndicatorOptions({
    this.position = IndicatorPosition.bottom,
    this.alignment = Alignment.bottomCenter,
    this.padding = const EdgeInsets.all(16.0),
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.activeColor,
    this.inactiveColor,
    this.effect = JetIndicatorEffect.worm,
    this.dotHeight,
    this.dotWidth,
  });

  /// Position of the indicator relative to the carousel.
  final IndicatorPosition position;

  /// Alignment of the indicator within its position.
  final Alignment alignment;

  /// Padding around the indicator.
  final EdgeInsets padding;

  /// Size of each dot indicator.
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  /// Color for the active page dot.
  final Color? activeColor;

  /// Color for inactive page dots.
  final Color? inactiveColor;

  /// Visual effect for the indicator.
  final JetIndicatorEffect effect;

  /// Custom height for dots (overrides dotSize).
  final double? dotHeight;

  /// Custom width for dots (overrides dotSize).
  final double? dotWidth;
}

/// Position of the page indicator.
enum IndicatorPosition {
  /// Indicator positioned at the top.
  top,

  /// Indicator positioned at the bottom.
  bottom,

  /// Indicator overlaid on top of carousel content.
  overlay,
}

/// Visual effect types for the page indicator.
///
/// These effects determine how the indicator animates and displays
/// the active page transition.
enum JetIndicatorEffect {
  /// Worm-like transition effect (default, smooth and subtle).
  worm,

  /// Dots expand when active (bold and noticeable).
  expanding,

  /// Active dot jumps up and down (playful animation).
  jumping,

  /// Dots scroll horizontally when many pages (space-efficient).
  scrolling,

  /// Sliding transition between dots (smooth movement).
  slide,

  /// Dots scale up when active (simple and clean).
  scale,

  /// Active and inactive dots swap positions (unique effect).
  swap,
}

/// A Material Design carousel widget with hooks support.
///
/// Provides a feature-rich carousel implementation that wraps Flutter's
/// native [CarouselView] with additional functionality including:
/// - Auto-play with configurable intervals
/// - Infinite scrolling
/// - Smooth page indicators with customization
/// - Typed builder pattern for items
/// - Programmatic control via [JetCarouselController]
///
/// Example usage:
/// ```dart
/// JetCarousel<String>(
///   items: ['Item 1', 'Item 2', 'Item 3'],
///   builder: (context, index, item) {
///     return Center(child: Text(item));
///   },
///   autoPlay: true,
///   height: 200,
///   onChange: (index) => print('Current page: $index'),
/// )
/// ```
class JetCarousel<T> extends HookWidget {
  const JetCarousel({
    super.key,
    required this.items,
    required this.builder,
    this.controller,
    this.onChange,
    this.onTap,
    this.height,
    this.itemExtent,
    this.aspectRatio,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnInteraction = true,
    this.autoPlayResumeDelay = const Duration(seconds: 2),
    this.enableInfiniteScroll = true,
    this.showIndicator = true,
    this.indicatorOptions = const JetCarouselIndicatorOptions(),
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.overlayColor,
    this.enableSplash = true,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.initialPage = 0,
    this.shrinkExtent = 0.0,
    this.viewportFraction = 1.0,
  });

  /// List of items to display in the carousel.
  final List<T> items;

  /// Builder function that creates a widget for each item.
  ///
  /// Receives the build context, item index, and the item itself.
  final Widget Function(BuildContext context, int index, T item) builder;

  /// Controller for programmatic carousel control.
  final JetCarouselController? controller;

  /// Callback when the current page changes.
  final ValueChanged<int>? onChange;

  /// Callback when an item is tapped.
  final void Function(int index, T item)? onTap;

  /// Fixed height for the carousel (if not using aspectRatio).
  final double? height;

  /// Fixed extent for each carousel item.
  final double? itemExtent;

  /// Aspect ratio for carousel items (width / height).
  final double? aspectRatio;

  /// Whether auto-play is enabled.
  final bool autoPlay;

  /// Interval between auto-play transitions.
  final Duration autoPlayInterval;

  /// Duration of auto-play transition animation.
  final Duration autoPlayAnimationDuration;

  /// Animation curve for auto-play transitions.
  final Curve autoPlayCurve;

  /// Whether to pause auto-play when user interacts with carousel.
  final bool pauseAutoPlayOnInteraction;

  /// Delay before resuming auto-play after user interaction.
  final Duration autoPlayResumeDelay;

  /// Whether to enable infinite scrolling (circular navigation).
  final bool enableInfiniteScroll;

  /// Whether to show the page indicator.
  final bool showIndicator;

  /// Configuration options for the page indicator.
  final JetCarouselIndicatorOptions indicatorOptions;

  /// Padding around the carousel.
  final EdgeInsets? padding;

  /// Background color for carousel items.
  final Color? backgroundColor;

  /// Elevation for carousel items.
  final double? elevation;

  /// Shape for carousel items.
  final ShapeBorder? shape;

  /// Overlay color for carousel items in different states.
  final WidgetStateProperty<Color?>? overlayColor;

  /// Whether to enable splash effect on items.
  final bool enableSplash;

  /// Scroll direction of the carousel.
  final Axis scrollDirection;

  /// Whether to reverse the carousel direction.
  final bool reverse;

  /// Initial page to display.
  final int initialPage;

  /// Minimum allowable extent for compressed items during scrolling.
  final double shrinkExtent;

  /// Fraction of the viewport each item should occupy.
  final double viewportFraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Early return if no items
    if (items.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(
          child: Text('No items to display'),
        ),
      );
    }

    // Calculate effective items list for infinite scroll
    final effectiveItems = useMemoized(
      () => enableInfiniteScroll && items.length > 1
          ? [...items, ...items, ...items]
          : items,
      [items, enableInfiniteScroll],
    );

    // Calculate initial page for infinite scroll
    final effectiveInitialPage = useMemoized(
      () => enableInfiniteScroll && items.length > 1
          ? initialPage + items.length
          : initialPage,
      [initialPage, items.length, enableInfiniteScroll],
    );

    // Page controller for tracking current page
    final pageController = usePageController(initialPage: effectiveInitialPage);

    // Current page index
    final currentPage = useState<int>(initialPage);

    // Auto-play state
    final isAutoPlaying = useState<bool>(autoPlay);
    final autoPlayTimer = useRef<Timer?>(null);
    final lastInteractionTime = useRef<DateTime?>(null);

    // Get actual index from virtual index (for infinite scroll)
    int getActualIndex(int virtualIndex) {
      if (!enableInfiniteScroll || items.length <= 1) return virtualIndex;
      return virtualIndex % items.length;
    }

    // Jump to page (handles infinite scroll)
    void jumpToPage(int targetPage) {
      final targetVirtualPage = enableInfiniteScroll && items.length > 1
          ? targetPage + items.length
          : targetPage;

      if (pageController.hasClients) {
        pageController.jumpToPage(targetVirtualPage);
      }
    }

    // Animate to next page
    void nextPage() {
      if (!pageController.hasClients) return;

      final nextIndex = pageController.page!.round() + 1;
      pageController.animateToPage(
        nextIndex,
        duration: autoPlayAnimationDuration,
        curve: autoPlayCurve,
      );
    }

    // Animate to previous page
    void previousPage() {
      if (!pageController.hasClients) return;

      final prevIndex = pageController.page!.round() - 1;
      pageController.animateToPage(
        prevIndex,
        duration: autoPlayAnimationDuration,
        curve: autoPlayCurve,
      );
    }

    // Pause auto-play
    void pauseAutoPlay() {
      autoPlayTimer.value?.cancel();
      autoPlayTimer.value = null;
      isAutoPlaying.value = false;
      controller?._setAutoPlaying(false);
    }

    // Resume auto-play
    void resumeAutoPlay() {
      if (!autoPlay) return;

      pauseAutoPlay(); // Cancel existing timer

      autoPlayTimer.value = Timer.periodic(autoPlayInterval, (timer) {
        if (pageController.hasClients) {
          final currentIndex = pageController.page!.round();
          final nextIndex = currentIndex + 1;

          pageController.animateToPage(
            nextIndex,
            duration: autoPlayAnimationDuration,
            curve: autoPlayCurve,
          );
        }
      });

      isAutoPlaying.value = true;
      controller?._setAutoPlaying(true);
    }

    // Attach controller callbacks
    useEffect(() {
      controller?._attachCallbacks(
        onPause: pauseAutoPlay,
        onResume: resumeAutoPlay,
        onJumpToPage: jumpToPage,
        onNextPage: nextPage,
        onPreviousPage: previousPage,
      );

      return () {
        controller?._detachCallbacks();
      };
    }, [controller]);

    // Set up auto-play
    useEffect(() {
      if (autoPlay) {
        // Delay initial auto-play start
        final initialTimer = Timer(autoPlayInterval, resumeAutoPlay);

        return () {
          initialTimer.cancel();
          pauseAutoPlay();
        };
      }
      return null;
    }, [autoPlay, autoPlayInterval]);

    // Listen to page changes
    useEffect(() {
      void onPageChanged() {
        if (!pageController.hasClients) return;

        final page = pageController.page!;
        final roundedPage = page.round();
        final actualIndex = getActualIndex(roundedPage);

        // Update current page
        if (currentPage.value != actualIndex) {
          currentPage.value = actualIndex;
          controller?._setCurrentPage(actualIndex);
          onChange?.call(actualIndex);
        }

        // Handle infinite scroll boundary jumping
        if (enableInfiniteScroll && items.length > 1) {
          // Jump to equivalent position if we're at boundaries
          if (roundedPage >= effectiveItems.length - items.length ~/ 2) {
            Future.delayed(const Duration(milliseconds: 50), () {
              if (pageController.hasClients) {
                pageController.jumpToPage(roundedPage - items.length);
              }
            });
          } else if (roundedPage < items.length ~/ 2) {
            Future.delayed(const Duration(milliseconds: 50), () {
              if (pageController.hasClients) {
                pageController.jumpToPage(roundedPage + items.length);
              }
            });
          }
        }

        // Handle auto-play pause on interaction
        if (pauseAutoPlayOnInteraction && isAutoPlaying.value) {
          final now = DateTime.now();
          if (lastInteractionTime.value != null) {
            final diff = now.difference(lastInteractionTime.value!);
            if (diff < const Duration(milliseconds: 100)) {
              // User is actively scrolling
              pauseAutoPlay();

              // Schedule resume after delay
              Timer(autoPlayResumeDelay, () {
                if (autoPlay) resumeAutoPlay();
              });
            }
          }
          lastInteractionTime.value = now;
        }
      }

      pageController.addListener(onPageChanged);

      return () {
        pageController.removeListener(onPageChanged);
      };
    }, [pageController, enableInfiniteScroll, items.length]);

    // Build carousel item
    Widget buildCarouselItem(int index) {
      final actualIndex = getActualIndex(index);
      final item = items[actualIndex];

      Widget child = builder(context, actualIndex, item);

      // Wrap with aspect ratio if provided
      if (aspectRatio != null) {
        child = AspectRatio(
          aspectRatio: aspectRatio!,
          child: child,
        );
      }

      // Add tap handler if provided
      if (onTap != null) {
        child = GestureDetector(
          onTap: () => onTap!(actualIndex, item),
          child: child,
        );
      }

      return child;
    }

    // Build page view
    Widget carousel = PageView.builder(
      controller: pageController,
      scrollDirection: scrollDirection,
      reverse: reverse,
      itemCount: effectiveItems.length,
      onPageChanged: (index) {
        // Track user interaction
        lastInteractionTime.value = DateTime.now();
      },
      itemBuilder: (context, index) => buildCarouselItem(index),
    );

    // Wrap with height if provided
    if (height != null) {
      carousel = SizedBox(
        height: height,
        child: carousel,
      );
    }

    // Add padding if provided
    if (padding != null) {
      carousel = Padding(
        padding: padding!,
        child: carousel,
      );
    }

    // Add indicator if enabled
    if (showIndicator && items.length > 1) {
      // Build effect with custom colors and sizes
      final activeColor =
          indicatorOptions.activeColor ?? theme.colorScheme.primary;
      final inactiveColor =
          indicatorOptions.inactiveColor ??
          theme.colorScheme.onSurface.withValues(alpha: 0.3);
      final dotHeight = indicatorOptions.dotHeight ?? indicatorOptions.dotSize;
      final dotWidth = indicatorOptions.dotWidth ?? indicatorOptions.dotSize;

      // Build effect based on the enum value
      IndicatorEffect effect;
      switch (indicatorOptions.effect) {
        case JetIndicatorEffect.worm:
          effect = WormEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.expanding:
          effect = ExpandingDotsEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.jumping:
          effect = JumpingDotEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.scrolling:
          effect = ScrollingDotsEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.slide:
          effect = SlideEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.scale:
          effect = ScaleEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
        case JetIndicatorEffect.swap:
          effect = SwapEffect(
            dotHeight: dotHeight,
            dotWidth: dotWidth,
            spacing: indicatorOptions.spacing,
            activeDotColor: activeColor,
            dotColor: inactiveColor,
          );
          break;
      }

      final indicator = Padding(
        padding: indicatorOptions.padding,
        child: SmoothPageIndicator(
          controller: pageController,
          count: items.length,
          effect: effect,
          onDotClicked: (index) {
            jumpToPage(index);
          },
        ),
      );

      // Position indicator based on options
      if (indicatorOptions.position == IndicatorPosition.overlay) {
        carousel = Stack(
          children: [
            carousel,
            Positioned(
              left: 0,
              right: 0,
              top: indicatorOptions.alignment == Alignment.topCenter ? 0 : null,
              bottom: indicatorOptions.alignment == Alignment.bottomCenter
                  ? 0
                  : null,
              child: Align(
                alignment: indicatorOptions.alignment,
                child: indicator,
              ),
            ),
          ],
        );
      } else {
        carousel = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (indicatorOptions.position == IndicatorPosition.top) indicator,
            if (height != null) carousel else Expanded(child: carousel),
            if (indicatorOptions.position == IndicatorPosition.bottom)
              indicator,
          ],
        );
      }
    }

    return carousel;
  }
}
