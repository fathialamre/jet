# Components Documentation

Complete guide to UI components in the Jet framework.

## Table of Contents

- [Overview](#overview)
- [JetButton](#jetbutton)
- [JetTab](#jettab)
- [JetCarousel](#jetcarousel)
- [Best Practices](#best-practices)

## Overview

Jet provides pre-built UI components with consistent styling, automatic loading states, and extensive customization options. These components are built on top of Flutter's Material and Cupertino widgets with enhanced functionality and developer experience.

**Packages Used:**
- **smooth_page_indicator** - [pub.dev](https://pub.dev/packages/smooth_page_indicator) - Beautiful page indicators for JetCarousel
- **flutter_hooks** - [pub.dev](https://pub.dev/packages/flutter_hooks) - React-style hooks for component state
- **auto_route** - [pub.dev](https://pub.dev/packages/auto_route) - Router integration for JetTab

**Key Benefits:**
- ✅ Material and Cupertino design support
- ✅ Automatic loading states for async operations
- ✅ Consistent styling across the app
- ✅ Extensive customization options
- ✅ Type-safe builder patterns
- ✅ Built-in animations and transitions
- ✅ Performance optimized
- ✅ Accessibility support

**Available Components:**
- **JetButton** - Modern button with loading states
- **JetTab** - Tab widget with keep-alive and lazy loading
- **JetCarousel** - Feature-rich carousel with auto-play

## JetButton

Modern button component with automatic loading states for async operations.

###

 Features

- ✅ Material and Cupertino button styles
- ✅ Automatic loading states for async operations
- ✅ Multiple style variants (filled, outlined, text)
- ✅ Customizable styling and animations

### Basic Usage

```dart
import 'package:jet/jet.dart';

JetButton(
  text: 'Submit',
  onTap: () async {
    await submitData();
  },
)
```

### Button Variants

```dart
// Filled button (default)
JetButton.filled(
  text: 'Submit',
  onTap: () async {
    await submitData();
  },
)

// Outlined button
JetButton.outlined(
  text: 'Cancel',
  onTap: () {
    Navigator.pop(context);
  },
)

// Text button
JetButton.textButton(
  text: 'Learn More',
  onTap: () {
    showInfo();
  },
)
```

### With Custom Styling

```dart
JetButton.filled(
  text: 'Sign Up',
  onTap: () async {
    await register();
  },
  backgroundColor: Colors.green,
  foregroundColor: Colors.white,
  borderRadius: BorderRadius.circular(12),
  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
)
```

### API Reference

**Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `String` | required | Button text |
| `onTap` | `VoidCallback?` | `null` | Callback when button is tapped |
| `backgroundColor` | `Color?` | `null` | Button background color |
| `foregroundColor` | `Color?` | `null` | Button text/icon color |
| `borderRadius` | `BorderRadius?` | `null` | Button border radius |
| `padding` | `EdgeInsets?` | `null` | Button padding |
| `isLoading` | `bool` | `false` | Manual loading state |
| `disabled` | `bool` | `false` | Disable button |
| `icon` | `Widget?` | `null` | Leading icon |

---

## JetTab

Customizable tab widget with keep-alive, lazy loading, and AutoRoute integration.

### Features

- 📑 **Dual Modes**: Simple widget-based tabs and AutoRoute integration
- 💾 **Keep-Alive**: Preserve tab state when switching
- ⚡ **Lazy Loading**: Build tab content only when first visited
- 🎨 **Highly Customizable**: Extensive styling options
- 📱 **Scrollable Tabs**: Support for horizontal scrolling

### Basic Usage

#### Simple Widget Tabs

```dart
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],
  children: [
    HomeView(),
    ProfileView(),
    SettingsView(),
  ],
  indicatorColor: Colors.blue,
  labelColor: Colors.blue,
)
```

#### AutoRoute Integration

```dart
JetTab.router(
  routes: [
    HomeRoute(),
    ProfileRoute(),
    SettingsRoute(),
  ],
  tabs: ['Home', 'Profile', 'Settings'],
  indicatorColor: Colors.blue,
  labelColor: Colors.blue,
)
```

### Keep-Alive Feature

Preserve state when switching between tabs:

```dart
JetTab.simple(
  keepAlive: true,   // Preserve scroll positions, form inputs, etc.
  tabs: ['Feed', 'Notifications', 'Messages'],
  children: [
    FeedView(),
    NotificationsView(),
    MessagesView(),
  ],
)
```

**When to use keep-alive:**
- ✅ Tabs contain forms with user input
- ✅ Scroll position matters (long lists)
- ✅ Media players (video/audio)
- ✅ Apps with 2-4 tabs
- ❌ Apps with 10+ tabs (too much memory)

### Lazy Loading Feature

Build tab content only when first visited:

```dart
JetTab.simple(
  lazyLoad: true,    // Build tabs on demand
  tabs: ['Feed', 'Videos', 'Photos', 'Stories', 'Live'],
  children: [
    FeedView(),     // Built immediately (visible)
    VideosView(),   // Built when user taps tab
    PhotosView(),   // Built when user taps tab
    StoriesView(),  // Built when user taps tab
    LiveView(),     // Built when user taps tab
  ],
)
```

**When to use lazy loading:**
- ✅ Many tabs (5+ tabs)
- ✅ Tabs contain heavy widgets
- ✅ Want faster initial load time
- ❌ Only 2-3 simple tabs

### Combined Keep-Alive + Lazy Loading

Best of both worlds:

```dart
JetTab.simple(
  keepAlive: true,   // Preserve state
  lazyLoad: true,    // Build on demand
  tabs: ['Feed', 'Explore', 'Notifications', 'Profile'],
  children: [
    FeedView(),
    ExploreView(),
    NotificationsView(),
    ProfileView(),
  ],
)
```

**Benefits:**
- ⚡ Fast initial load (lazy loading)
- 💾 Preserved state when switching (keep-alive)
- 🎯 Only builds tabs when needed
- 🔄 No rebuilds after first visit

### Scrollable Tabs

For many tabs:

```dart
JetTab.simple(
  isScrollable: true,
  tabAlignment: TabAlignment.start,
  tabs: [
    'All',
    'Technology',
    'Sports',
    'Entertainment',
    'Politics',
    'Science',
  ],
  children: [...],
  lazyLoad: true,  // Recommended for many tabs
  keepAlive: true,
)
```

### Custom Tab Widgets

```dart
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],
  customTabs: [
    Tab(icon: Icon(Icons.home), text: 'Home'),
    Tab(icon: Icon(Icons.person), text: 'Profile'),
    Tab(icon: Icon(Icons.settings), text: 'Settings'),
  ],
  children: [HomeView(), ProfileView(), SettingsView()],
)
```

### API Reference

**JetTab.simple Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tabs` | `List<String>` | required | Tab titles |
| `children` | `List<Widget>` | required | Tab content widgets |
| `keepAlive` | `bool` | `false` | Preserve tab state |
| `lazyLoad` | `bool` | `false` | Build tabs on demand |
| `isScrollable` | `bool` | `false` | Enable horizontal scrolling |
| `initialIndex` | `int` | `0` | Initially selected tab |
| `indicatorColor` | `Color?` | `null` | Tab indicator color |
| `labelColor` | `Color?` | `null` | Selected tab label color |
| `unselectedLabelColor` | `Color?` | `null` | Unselected tab label color |
| `customTabs` | `List<Widget>?` | `null` | Custom tab widgets |
| `onTap` | `ValueChanged<int>?` | `null` | Tab tap callback |

---

## JetCarousel

Feature-rich carousel component with auto-play, infinite scroll, and smooth indicators.

### Features

- ✨ **Type-Safe Builder**: Generic type support
- 🎯 **Auto-Play**: Configurable auto-play with pause/resume
- ♾️ **Infinite Scrolling**: Seamless circular navigation
- 📍 **Smooth Indicators**: 7 indicator effect types
- 🎮 **Programmatic Control**: Control via JetCarouselController
- 📱 **Responsive**: Horizontal and vertical scrolling

### Basic Usage

```dart
import 'package:jet/jet.dart';

JetCarousel<String>(
  items: ['Item 1', 'Item 2', 'Item 3'],
  height: 200,
  builder: (context, index, item) {
    return Center(child: Text(item));
  },
)
```

### Auto-Play Example

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

### With Custom Indicator

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

### Programmatic Control

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
          ],
        ),
      ],
    );
  }
}
```

### Indicator Effects

Available indicator effects:

- `JetIndicatorEffect.worm` - Worm-like transition (default, smooth and subtle)
- `JetIndicatorEffect.expanding` - Dots expand when active
- `JetIndicatorEffect.jumping` - Active dot jumps
- `JetIndicatorEffect.scrolling` - Dots scroll horizontally
- `JetIndicatorEffect.slide` - Sliding transition
- `JetIndicatorEffect.scale` - Dots scale up when active
- `JetIndicatorEffect.swap` - Active and inactive dots swap

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
    ),
  ),
)
```

### API Reference

**JetCarousel Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<T>` | required | List of items |
| `builder` | `Function` | required | Widget builder for each item |
| `controller` | `JetCarouselController?` | `null` | Programmatic control |
| `onChange` | `ValueChanged<int>?` | `null` | Page change callback |
| `onTap` | `Function(int, T)?` | `null` | Item tap callback |
| `height` | `double?` | `null` | Fixed carousel height |
| `aspectRatio` | `double?` | `null` | Item aspect ratio |
| `autoPlay` | `bool` | `false` | Enable auto-play |
| `autoPlayInterval` | `Duration` | `3 seconds` | Auto-play interval |
| `enableInfiniteScroll` | `bool` | `true` | Enable infinite scrolling |
| `showIndicator` | `bool` | `true` | Show page indicator |
| `indicatorOptions` | `JetCarouselIndicatorOptions` | default | Indicator customization |
| `scrollDirection` | `Axis` | `horizontal` | Scroll direction |
| `initialPage` | `int` | `0` | Initial page |

**JetCarouselController Methods:**

- `pause()` - Pause auto-play
- `resume()` - Resume auto-play
- `jumpToPage(int page)` - Jump to page
- `nextPage()` - Animate to next page
- `previousPage()` - Animate to previous page

---

## Best Practices

### JetButton

1. **Use appropriate variants:**
   ```dart
   // Primary action
   JetButton.filled(text: 'Submit', onTap: submit)
   
   // Secondary action
   JetButton.outlined(text: 'Cancel', onTap: cancel)
   
   // Tertiary action
   JetButton.textButton(text: 'Learn More', onTap: info)
   ```

2. **Leverage automatic loading states:**
   ```dart
   // Automatic loading state for async
   JetButton(
     text: 'Submit',
     onTap: () async {
       await submitData(); // Button shows loading automatically
     },
   )
   ```

### JetTab

1. **Use keep-alive + lazy loading for 3+ tabs:**
   ```dart
   JetTab.simple(
     keepAlive: true,
     lazyLoad: true,
     tabs: tabs,
     children: children,
   )
   ```

2. **Use scrollable tabs for 5+ tabs:**
   ```dart
   JetTab.simple(
     isScrollable: true,
     tabAlignment: TabAlignment.start,
     tabs: manyTabs,
     children: children,
   )
   ```

3. **Use custom tabs for better UX:**
   ```dart
   JetTab.simple(
     customTabs: [
       Tab(icon: Icon(Icons.home), text: 'Home'),
       Tab(icon: Icon(Icons.person), text: 'Profile'),
     ],
     tabs: ['Home', 'Profile'],
     children: children,
   )
   ```

### JetCarousel

1. **Use const constructors in builder:**
   ```dart
   JetCarousel<String>(
     items: items,
     builder: (context, index, item) {
       // Extract to separate widget for better performance
       return ProductCard(product: item);
     },
   )
   ```

2. **Set pauseAutoPlayOnInteraction for better UX:**
   ```dart
   JetCarousel<Banner>(
     items: banners,
     autoPlay: true,
     pauseAutoPlayOnInteraction: true, // Pause when user scrolls
     builder: (context, index, banner) => BannerCard(banner),
   )
   ```

3. **Specify either height or aspectRatio, not both:**
   ```dart
   // Good - height
   JetCarousel(height: 200, ...)
   
   // Good - aspect ratio
   JetCarousel(aspectRatio: 16/9, ...)
   
   // Bad - both
   JetCarousel(height: 200, aspectRatio: 16/9, ...)
   ```

## See Also

- [Forms Documentation](FORMS.md) - Form management
- [State Management Documentation](STATE_MANAGEMENT.md) - JetBuilder and JetPaginator
- [Extensions Documentation](EXTENSIONS.md) - UI helpers and extensions

