# JetCarousel

A feature-rich carousel widget for the Jet framework with auto-play, infinite scrolling, and smooth page indicators.

## Features

- ✨ **Type-Safe Builder**: Generic type support with builder pattern `(context, index, item) => Widget`
- 🎯 **Auto-Play**: Configurable auto-play with pause/resume on user interaction
- ♾️ **Infinite Scrolling**: Seamless circular navigation
- 📍 **Smooth Indicators**: Customizable page indicators with multiple effect types
- 🎮 **Programmatic Control**: Control via `JetCarouselController`
- 🎨 **Highly Customizable**: Extensive styling and behavior options
- 📱 **Responsive**: Support for both horizontal and vertical scrolling

## Installation

The JetCarousel is included in the Jet framework. Make sure you have the latest version:

```yaml
dependencies:
  jet:
    path: ../packages/jet
```

## Basic Usage

```dart
import 'package:jet/jet.dart';

JetCarousel<String>(
  items: ['Item 1', 'Item 2', 'Item 3'],
  height: 200,
  builder: (context, index, item) {
    return Center(
      child: Text(item),
    );
  },
)
```

## Auto-Play Example

```dart
JetCarousel<Product>(
  items: products,
  height: 250,
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 3),
  builder: (context, index, product) {
    return ProductCard(product: product);
  },
  onChange: (index) {
    print('Current page: $index');
  },
)
```

## With Custom Indicator

```dart
JetCarousel<ImageData>(
  items: images,
  height: 300,
  builder: (context, index, image) {
    return Image.network(image.url);
  },
  indicatorOptions: JetCarouselIndicatorOptions(
    position: IndicatorPosition.overlay,
    alignment: Alignment.bottomCenter,
    dotSize: 12,
    spacing: 10,
    activeColor: Colors.white,
    inactiveColor: Colors.white.withOpacity(0.5),
    effect: JetIndicatorEffect.worm,
  ),
)
```

## Programmatic Control

```dart
class MyWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useState(JetCarouselController());

    return Column(
      children: [
        JetCarousel<String>(
          items: items,
          height: 200,
          controller: controller.value,
          builder: (context, index, item) {
            return Center(child: Text(item));
          },
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => controller.value.previousPage(),
              child: Text('Previous'),
            ),
            ElevatedButton(
              onPressed: () => controller.value.nextPage(),
              child: Text('Next'),
            ),
            ElevatedButton(
              onPressed: () => controller.value.jumpToPage(0),
              child: Text('First'),
            ),
          ],
        ),
      ],
    );
  }
}
```

## API Reference

### JetCarousel

#### Required Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `items` | `List<T>` | List of items to display in the carousel |
| `builder` | `Widget Function(BuildContext, int, T)` | Builder function to create widgets for each item |

#### Optional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `JetCarouselController?` | `null` | Controller for programmatic control |
| `onChange` | `ValueChanged<int>?` | `null` | Callback when page changes |
| `onTap` | `void Function(int, T)?` | `null` | Callback when item is tapped |
| `height` | `double?` | `null` | Fixed height for carousel |
| `aspectRatio` | `double?` | `null` | Aspect ratio for items (width / height) |
| `autoPlay` | `bool` | `false` | Enable auto-play |
| `autoPlayInterval` | `Duration` | `3 seconds` | Interval between auto-play transitions |
| `autoPlayAnimationDuration` | `Duration` | `800ms` | Duration of transition animation |
| `autoPlayCurve` | `Curve` | `Curves.fastOutSlowIn` | Animation curve for transitions |
| `pauseAutoPlayOnInteraction` | `bool` | `true` | Pause auto-play when user scrolls |
| `autoPlayResumeDelay` | `Duration` | `2 seconds` | Delay before resuming auto-play |
| `enableInfiniteScroll` | `bool` | `true` | Enable infinite scrolling |
| `showIndicator` | `bool` | `true` | Show page indicator |
| `indicatorOptions` | `JetCarouselIndicatorOptions` | `default` | Indicator customization options |
| `padding` | `EdgeInsets?` | `null` | Padding around carousel |
| `scrollDirection` | `Axis` | `Axis.horizontal` | Scroll direction |
| `reverse` | `bool` | `false` | Reverse scroll direction |
| `initialPage` | `int` | `0` | Initial page to display |
| `viewportFraction` | `double` | `1.0` | Fraction of viewport each item occupies |

### JetCarouselController

Methods:

- `pause()` - Pause auto-play
- `resume()` - Resume auto-play
- `jumpToPage(int page)` - Jump to specific page instantly
- `nextPage()` - Animate to next page
- `previousPage()` - Animate to previous page

Properties:

- `currentPage` - Current page index (read-only)
- `isAutoPlaying` - Whether auto-play is active (read-only)

### JetCarouselIndicatorOptions

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `position` | `IndicatorPosition` | `bottom` | Position: `top`, `bottom`, or `overlay` |
| `alignment` | `Alignment` | `bottomCenter` | Alignment within position |
| `padding` | `EdgeInsets` | `all(16)` | Padding around indicator |
| `dotSize` | `double` | `8.0` | Size of each dot |
| `spacing` | `double` | `8.0` | Spacing between dots |
| `activeColor` | `Color?` | Theme primary | Color for active dot |
| `inactiveColor` | `Color?` | Theme onSurface | Color for inactive dots |
| `effect` | `JetIndicatorEffect` | `worm` | Visual effect type |

#### Available Effects

- `JetIndicatorEffect.worm` - Worm-like transition (default, smooth and subtle)
- `JetIndicatorEffect.expanding` - Dots expand when active (bold and noticeable)
- `JetIndicatorEffect.jumping` - Active dot jumps up and down (playful animation)
- `JetIndicatorEffect.scrolling` - Dots scroll horizontally when many pages (space-efficient)
- `JetIndicatorEffect.slide` - Sliding transition between dots (smooth movement)
- `JetIndicatorEffect.scale` - Dots scale up when active (simple and clean)
- `JetIndicatorEffect.swap` - Active and inactive dots swap positions (unique effect)

## Advanced Examples

### Image Carousel with Aspect Ratio

```dart
JetCarousel<String>(
  items: imageUrls,
  aspectRatio: 16 / 9,
  builder: (context, index, url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  },
  indicatorOptions: JetCarouselIndicatorOptions(
    position: IndicatorPosition.overlay,
    alignment: Alignment.bottomCenter,
    padding: EdgeInsets.only(bottom: 20),
    effect: JetIndicatorEffect.worm,
    activeColor: Colors.white,
    inactiveColor: Colors.white.withOpacity(0.4),
  ),
)
```

### Vertical Carousel

```dart
SizedBox(
  height: 400,
  child: JetCarousel<String>(
    items: items,
    scrollDirection: Axis.vertical,
    builder: (context, index, item) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: Text(item)),
      );
    },
    indicatorOptions: JetCarouselIndicatorOptions(
      position: IndicatorPosition.overlay,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 16),
    ),
  ),
)
```

### Carousel Without Infinite Scroll

```dart
JetCarousel<Product>(
  items: products,
  height: 200,
  enableInfiniteScroll: false,
  builder: (context, index, product) {
    return ProductCard(product: product);
  },
)
```

### Custom Styled Carousel

```dart
JetCarousel<Banner>(
  items: banners,
  height: 180,
  padding: EdgeInsets.symmetric(horizontal: 16),
  builder: (context, index, banner) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [banner.startColor, banner.endColor],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: BannerContent(banner: banner),
    );
  },
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 5),
  indicatorOptions: JetCarouselIndicatorOptions(
    dotSize: 10,
    spacing: 12,
    activeColor: banner.accentColor,
    effect: JetIndicatorEffect.expanding,
  ),
  onTap: (index, banner) {
    // Handle banner tap
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BannerDetailPage(banner: banner),
      ),
    );
  },
)
```

## Tips

1. **Performance**: Use `const` constructors in your builder when possible for better performance
2. **Images**: Consider using `CachedNetworkImage` for remote images
3. **Auto-Play**: Set `pauseAutoPlayOnInteraction: true` for better UX
4. **Infinite Scroll**: Works best with 3+ items; automatically disabled with 1 item
5. **Height**: Specify either `height` or `aspectRatio`, not both
6. **Controller**: Create controller with `useState` in HookWidget for proper lifecycle management

## See Also

- [JetTab](packages/jet/lib/resources/components/tabs/jet_tab.dart) - Tab widget component
- [JetPaginator](JET_PAGINATOR.md) - Infinite scroll pagination
- [JetBuilder](packages/jet/lib/resources/state/jet_builder.dart) - State management builders

