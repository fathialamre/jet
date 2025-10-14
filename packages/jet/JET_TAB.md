# JetTab

A customizable tab widget for the Jet framework with extensive styling options, state preservation, and lazy loading capabilities.

## Features

- 📑 **Dual Modes**: Simple widget-based tabs and AutoRoute integration
- 💾 **Keep-Alive**: Preserve tab state when switching (scroll position, form input, etc.)
- ⚡ **Lazy Loading**: Build tab content only when first visited (improve initial load time)
- 🎨 **Highly Customizable**: Extensive styling and behavior options
- 🎯 **External Controller**: Programmatic control via TabController
- 📱 **Scrollable Tabs**: Support for horizontal scrolling when many tabs
- 🔄 **Custom Tab Widgets**: Full control over tab appearance
- 🎪 **Bottom Navigation**: Built-in support for bottom navigation style

## Installation

JetTab is included in the Jet framework. Make sure you have the latest version:

```yaml
dependencies:
  jet:
    path: ../packages/jet
```

## Basic Usage

### Simple Widget Tabs

```dart
import 'package:jet/jet.dart';

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

### AutoRoute Integration

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

## Keep-Alive Feature

### What is Keep-Alive?

Keep-alive preserves the state of tabs when you switch between them. Without keep-alive, Flutter disposes widgets that are off-screen to save memory, which means:
- Scroll positions reset to top
- Form inputs are cleared
- Video playback positions are lost
- Any widget state is reset

With keep-alive enabled, all of this state is preserved.

### When to Use Keep-Alive

✅ **Use keep-alive when:**
- Tabs contain forms with user input
- Scroll position matters (long lists)
- Media players (video/audio)
- Complex state that's expensive to rebuild
- Apps with 2-4 tabs

❌ **Avoid keep-alive when:**
- Apps with 10+ tabs (too much memory)
- Tabs with heavy images/videos (memory concerns)
- Simple tabs with no state
- Tabs that should refresh when revisited

### Keep-Alive Examples

#### Preserve Scroll Position

```dart
JetTab.simple(
  keepAlive: true,
  tabs: ['Feed', 'Notifications', 'Messages'],
  children: [
    ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(
        title: Text('Post $index'),
      ),
    ),
    NotificationsView(),
    MessagesView(),
  ],
)
```

**Result:** When you scroll to item #50 in Feed, switch to Notifications, and come back - you're still at item #50! 🎉

#### Preserve Form Input

```dart
JetTab.simple(
  keepAlive: true,
  tabs: ['Personal Info', 'Address', 'Payment'],
  children: [
    PersonalInfoForm(),  // User fills name, email, phone
    AddressForm(),        // Check shipping address
    PaymentForm(),        // Return to personal info - data still there!
  ],
)
```

**Result:** Switch between form tabs freely without losing user input.

#### Preserve Video Playback

```dart
JetTab.simple(
  keepAlive: true,
  tabs: ['Video', 'Comments', 'Related'],
  children: [
    VideoPlayerView(),  // Playing video at 2:30
    CommentsView(),      // Read comments
    RelatedVideosView(), // Return to video - still at 2:30!
  ],
)
```

**Result:** Video position is preserved when switching tabs.

## Lazy Loading Feature

### What is Lazy Loading?

Lazy loading defers building tab content until the user first visits that tab. Without lazy loading, all tabs are built immediately when `JetTab` initializes, even if the user never visits them.

### When to Use Lazy Loading

✅ **Use lazy loading when:**
- Many tabs (5+ tabs)
- Tabs contain heavy widgets (images, videos, complex layouts)
- Want faster initial load time
- Reduce memory usage on startup
- Tabs make API calls on mount

❌ **Skip lazy loading when:**
- Only 2-3 simple tabs
- All tabs are lightweight
- Need instant switching (no delay on first visit)
- Tabs don't do expensive initialization

### Lazy Loading Examples

#### Optimize Performance with Many Tabs

```dart
JetTab.simple(
  lazyLoad: true,
  tabs: ['Feed', 'Videos', 'Photos', 'Stories', 'Live'],
  children: [
    FeedView(),     // ✅ Built immediately (visible)
    VideosView(),   // ⏳ Built when user taps tab
    PhotosView(),   // ⏳ Built when user taps tab
    StoriesView(),  // ⏳ Built when user taps tab
    LiveView(),     // ⏳ Built when user taps tab
  ],
)
```

**Result:** Initial load is much faster because only `FeedView` is built!

#### Optimize Heavy API Calls

```dart
class ProductsTab extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This expensive API call only happens when tab is first visited
    final products = ref.watch(productsProvider);
    
    return products.when(
      data: (data) => ProductsList(products: data),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => ErrorView(error: err),
    );
  }
}

// Use with lazy loading
JetTab.simple(
  lazyLoad: true,
  tabs: ['All', 'Electronics', 'Fashion', 'Home'],
  children: [
    AllProductsTab(),
    ElectronicsTab(),  // API call deferred until user visits
    FashionTab(),       // API call deferred until user visits
    HomeTab(),          // API call deferred until user visits
  ],
)
```

**Result:** Only one API call on initial load instead of four!

## Combined Keep-Alive + Lazy Loading

The real power comes from using both features together:

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

**How it works:**
1. **Initial Load**: Only `FeedView` is built (lazy loading)
2. **User taps Explore**: `ExploreView` is built for the first time
3. **User scrolls in Explore**: Scrolls to item #30
4. **User taps Feed**: Returns to feed (explore kept alive)
5. **User taps Explore again**: Still at item #30 (kept alive)

**Benefits:**
- ⚡ Fast initial load (lazy loading)
- 💾 Preserved state when switching (keep-alive)
- 🎯 Only builds tabs when needed
- 🔄 No rebuilds after first visit

### Real-World Example: Social Media App

```dart
class SocialMediaHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Social Media')),
      body: JetTab.simple(
        keepAlive: true,
        lazyLoad: true,
        tabs: ['Feed', 'Search', 'Notifications', 'Profile'],
        children: [
          // Feed: Heavy infinite scroll list
          FeedTab(),
          
          // Search: Complex search UI with filters
          SearchTab(),
          
          // Notifications: Real-time updates
          NotificationsTab(),
          
          // Profile: User profile with posts
          ProfileTab(),
        ],
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}
```

**Performance Impact:**
- Without features: All 4 tabs build (slow), state lost on switch
- With lazy loading only: Only 1 tab builds (fast), but state lost on switch
- With keep-alive only: All 4 tabs build (slow), state preserved
- With both: Only 1 tab builds initially (fast), state preserved ✨

## API Reference

### JetTab.simple

Creates a simple tab widget with widget children.

**Required Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `tabs` | `List<String>` | List of tab titles |
| `children` | `List<Widget>` | List of widgets to display in each tab |

**Optional Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `keepAlive` | `bool` | `false` | Preserve tab state when switching |
| `lazyLoad` | `bool` | `false` | Build tab content only when first visited |
| `initialLength` | `int?` | `children.length` | Total number of tabs |
| `initialIndex` | `int` | `0` | Initially selected tab index |
| `controller` | `TabController?` | `null` | External tab controller |
| `isScrollable` | `bool` | `false` | Enable horizontal scrolling for tabs |
| `tabAlignment` | `TabAlignment?` | `null` | Tab alignment when scrollable |
| `indicatorColor` | `Color?` | `null` | Color of the tab indicator line |
| `labelColor` | `Color?` | `null` | Color of selected tab label |
| `unselectedLabelColor` | `Color?` | `null` | Color of unselected tab labels |
| `labelStyle` | `TextStyle?` | `null` | Text style for selected tab labels |
| `unselectedLabelStyle` | `TextStyle?` | `null` | Text style for unselected tab labels |
| `indicatorSize` | `TabBarIndicatorSize?` | `null` | Size of tab indicator (tab or label width) |
| `indicatorPadding` | `EdgeInsetsGeometry?` | `EdgeInsets.zero` | Padding around tab indicator |
| `indicator` | `Decoration?` | `null` | Custom indicator decoration |
| `dividerColor` | `Color?` | `null` | Color of divider line below tabs |
| `dividerHeight` | `double?` | `null` | Height of divider line below tabs |
| `tabBarHeight` | `double?` | `null` | Fixed height for tab bar area |
| `tabsPadding` | `EdgeInsetsGeometry?` | `EdgeInsets.zero` | Padding around the tab bar |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics for tab view content |
| `animationDuration` | `Duration?` | `null` | Animation duration for tab transitions |
| `customTabs` | `List<Widget>?` | `null` | Custom tab widgets (overrides tabs) |
| `onTap` | `ValueChanged<int>?` | `null` | Callback when a tab is tapped |

### JetTab.router

Creates a tab widget integrated with AutoRoute.

**Required Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `routes` | `List<PageRouteInfo>` | List of routes for navigation |
| `tabs` | `List<String>` | List of tab titles |

**Optional Parameters:**

Same as `JetTab.simple`, plus:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `builder` | `Widget Function(BuildContext, Widget)?` | `null` | Custom builder for layout |

**Note:** For router mode, lazy loading is handled by AutoRoute's native behavior (routes are already lazy-loaded by default). The `lazyLoad` parameter is primarily for simple mode.

## Advanced Examples

### Custom Tab Styles

```dart
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],
  children: [HomeView(), ProfileView(), SettingsView()],
  indicatorColor: Colors.blue,
  indicatorSize: TabBarIndicatorSize.label,
  labelColor: Colors.blue,
  labelStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  unselectedLabelColor: Colors.grey,
  unselectedLabelStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  dividerColor: Colors.transparent,
  tabBarHeight: 60,
  tabsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
)
```

### Custom Tab Widgets with Icons

```dart
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],  // Used for accessibility
  customTabs: [
    Tab(
      icon: Icon(Icons.home),
      text: 'Home',
    ),
    Tab(
      icon: Icon(Icons.person),
      text: 'Profile',
    ),
    Tab(
      icon: Icon(Icons.settings),
      text: 'Settings',
    ),
  ],
  children: [HomeView(), ProfileView(), SettingsView()],
  indicatorColor: Colors.blue,
)
```

### Scrollable Tabs

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
    'Health',
    'Business',
  ],
  children: [
    AllNewsView(),
    TechnologyNewsView(),
    SportsNewsView(),
    EntertainmentNewsView(),
    PoliticsNewsView(),
    ScienceNewsView(),
    HealthNewsView(),
    BusinessNewsView(),
  ],
  lazyLoad: true,  // Recommended for many tabs
  keepAlive: true, // Preserve scroll positions
)
```

### Programmatic Control

```dart
class MyWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(
      initialLength: 3,
      initialIndex: 0,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => tabController.animateTo(0),
              child: Text('Tab 1'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => tabController.animateTo(1),
              child: Text('Tab 2'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => tabController.animateTo(2),
              child: Text('Tab 3'),
            ),
          ],
        ),
        Expanded(
          child: JetTab.simple(
            controller: tabController,
            tabs: ['Home', 'Profile', 'Settings'],
            children: [HomeView(), ProfileView(), SettingsView()],
          ),
        ),
      ],
    );
  }
}
```

### Bottom Navigation Style (Router Mode)

```dart
[
  HomeRoute(),
  SearchRoute(),
  NotificationsRoute(),
  ProfileRoute(),
].toJetBottomTabs(
  tabs: ['Home', 'Search', 'Notifications', 'Profile'],
  bottomNavItems: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_outlined),
      activeIcon: Icon(Icons.notifications),
      label: 'Notifications',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  builder: (context, child, bottomNav) {
    return Scaffold(
      body: child,
      bottomNavigationBar: bottomNav,
    );
  },
)
```

### Scrollable Tabs (Router Mode)

```dart
[
  AllProductsRoute(),
  ElectronicsRoute(),
  FashionRoute(),
  HomeRoute(),
  SportsRoute(),
  BooksRoute(),
].toJetScrollableTabs(
  tabs: ['All', 'Electronics', 'Fashion', 'Home', 'Sports', 'Books'],
  tabAlignment: TabAlignment.start,
  indicatorColor: Colors.blue,
  labelColor: Colors.blue,
  unselectedLabelColor: Colors.grey,
)
```

### Custom Indicator

```dart
JetTab.simple(
  tabs: ['Home', 'Profile', 'Settings'],
  children: [HomeView(), ProfileView(), SettingsView()],
  indicator: BoxDecoration(
    color: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
  ),
  indicatorPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  labelColor: Colors.blue,
  unselectedLabelColor: Colors.grey,
)
```

## Performance Comparison

Here's a comparison of different configurations:

| Configuration | Initial Build Time | Memory Usage | Tab Switch Speed | Use Case |
|--------------|-------------------|--------------|------------------|----------|
| **Default** (no features) | Fast | Low | Fast (rebuilds) | Simple 2-3 tabs |
| **Keep-Alive only** | Slow (all tabs) | High | Instant | Few tabs, preserve state |
| **Lazy Load only** | Fast (1 tab) | Low | Fast (first visit slower) | Many tabs, no state needs |
| **Both** | Fast (1 tab) | Medium | Instant after first visit | Many tabs, preserve state ✨ |

## Best Practices

1. **Use keep-alive + lazy loading for 3+ tabs:**
   ```dart
   JetTab.simple(
     keepAlive: true,
     lazyLoad: true,
     tabs: tabs,
     children: children,
   )
   ```

2. **Use only lazy loading for 7+ tabs:**
   ```dart
   // Too many tabs to keep all alive
   JetTab.simple(
     lazyLoad: true,  // Keep memory usage low
     tabs: manyTabs,
     children: manyChildren,
   )
   ```

3. **Use scrollable tabs for 5+ tabs:**
   ```dart
   JetTab.simple(
     isScrollable: true,
     tabAlignment: TabAlignment.start,
     tabs: tabs,
     children: children,
   )
   ```

4. **Specify initial index when needed:**
   ```dart
   JetTab.simple(
     initialIndex: 2,  // Start on third tab
     tabs: tabs,
     children: children,
   )
   ```

5. **Use custom tabs for better UX:**
   ```dart
   JetTab.simple(
     customTabs: [
       Tab(icon: Icon(Icons.home), text: 'Home'),
       Tab(icon: Icon(Icons.person), text: 'Profile'),
     ],
     tabs: ['Home', 'Profile'],  // Accessibility
     children: children,
   )
   ```

## Trade-offs

### Keep-Alive

**Pros:**
- ✅ Preserves scroll positions
- ✅ Keeps form input
- ✅ Maintains media playback
- ✅ Instant tab switching
- ✅ Better user experience

**Cons:**
- ❌ Higher memory usage
- ❌ All tabs stay in memory
- ❌ Not suitable for 10+ tabs
- ❌ Can cause memory leaks if not careful

### Lazy Loading

**Pros:**
- ✅ Faster initial load
- ✅ Lower memory usage
- ✅ Scales well with many tabs
- ✅ Defers expensive operations

**Cons:**
- ❌ Small delay on first visit
- ❌ User might notice loading
- ❌ No benefit with 2-3 tabs

## Troubleshooting

### Tabs Not Switching

**Issue:** Tabs don't respond to taps

**Solution:**
```dart
// Make sure tabs and children have same length
JetTab.simple(
  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
  children: [
    View1(),
    View2(),
    View3(),  // Must match tabs length
  ],
)
```

### Keep-Alive Not Working

**Issue:** State is still lost when switching tabs

**Solution:**
```dart
// Make sure keepAlive is set to true
JetTab.simple(
  keepAlive: true,  // ← Must be explicit
  tabs: tabs,
  children: children,
)
```

**Note:** For custom widgets, they don't need `AutomaticKeepAliveClientMixin` - JetTab handles this automatically.

### Lazy Loading Not Working

**Issue:** All tabs are still building immediately

**Solution:**
```dart
// Make sure lazyLoad is set to true
JetTab.simple(
  lazyLoad: true,  // ← Must be explicit
  tabs: tabs,
  children: children,
)

// Also check that children don't have expensive constructors
// Bad:
children: [
  ExpensiveWidget(data: expensiveFunction()),  // Called immediately!
]

// Good:
children: [
  ExpensiveWidget(),  // Built lazily
]
```

### High Memory Usage

**Issue:** App uses too much memory with many tabs

**Solution:**
```dart
// 1. Use lazy loading without keep-alive for many tabs
JetTab.simple(
  lazyLoad: true,
  keepAlive: false,  // Don't keep all tabs alive
  tabs: manyTabs,
  children: manyChildren,
)

// 2. Or reduce number of tabs kept alive
// Keep only important tabs alive by splitting into multiple JetTabs

// 3. Ensure images are properly disposed
// Use CachedNetworkImage with proper cache limits
```

### Tab Bar Overflow

**Issue:** Too many tabs don't fit

**Solution:**
```dart
// Enable scrollable tabs
JetTab.simple(
  isScrollable: true,
  tabAlignment: TabAlignment.start,
  tabs: manyTabs,
  children: children,
)
```

### Custom Controller Not Working

**Issue:** External controller doesn't update tabs

**Solution:**
```dart
// Use useTabController hook in HookWidget
class MyWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTabController(
      initialLength: 3,  // Must match number of tabs
      initialIndex: 0,
    );

    return JetTab.simple(
      controller: controller,
      tabs: ['1', '2', '3'],
      children: [View1(), View2(), View3()],
    );
  }
}

// Don't create controller in build method directly
// Bad:
final controller = TabController(length: 3, vsync: this);
```

## Tips

1. **Memory Management**: For apps with 7+ tabs, use only lazy loading (not keep-alive) to prevent excessive memory usage

2. **Performance**: Combine keep-alive + lazy loading for optimal balance between speed and memory

3. **Accessibility**: Always provide text labels for tabs, even when using custom tab widgets

4. **Initial Load**: Use `initialIndex` to start on a specific tab based on deep links or user preferences

5. **Responsive Design**: Use `isScrollable: true` when tab count is unknown or varies by user

6. **Testing**: Test tab switching with real data to verify performance characteristics

7. **Images**: Use `CachedNetworkImage` with keep-alive to avoid reloading images when switching tabs

8. **Forms**: Always use keep-alive for tabs containing forms to prevent data loss

## See Also

- [JetCarousel](JET_CAROUSEL.md) - Carousel widget component
- [JetPaginator](JET_PAGINATOR.md) - Infinite scroll pagination
- [JetBuilder](packages/jet/lib/resources/state/jet_builder.dart) - State management builders
- [AutoRoute Documentation](https://pub.dev/packages/auto_route) - Routing integration

