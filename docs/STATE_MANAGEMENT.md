# State Management Documentation

Complete guide to state management in the Jet framework.

## Overview

Jet's state management is built on **[Riverpod 3](https://pub.dev/packages/riverpod)**, the latest version of Flutter's most powerful state management solution. Riverpod provides compile-time safety, easy testing, and no dependency on BuildContext. Jet enhances Riverpod with purpose-built widgets for common patterns like lists, grids, and infinite scroll pagination.

**Packages Used:**
- **riverpod** - [pub.dev](https://pub.dev/packages/riverpod) | [Documentation](https://riverpod.dev/) - Core state management
- **flutter_riverpod** - [pub.dev](https://pub.dev/packages/flutter_riverpod) - Flutter integration for Riverpod
- **riverpod_annotation** - [pub.dev](https://pub.dev/packages/riverpod_annotation) - Code generation annotations
- **infinite_scroll_pagination** - [pub.dev](https://pub.dev/packages/infinite_scroll_pagination) - Official pagination package for JetPaginator
- **skeletonizer** - [pub.dev](https://pub.dev/packages/skeletonizer) | [Documentation](https://pub.dev/packages/skeletonizer) - Skeleton loading animations

**Key Benefits:**
- ✅ Compile-time safe state management
- ✅ No BuildContext dependency for providers
- ✅ Easy to test with provider overrides
- ✅ Code generation for cleaner syntax
- ✅ Family providers for parameterized data
- ✅ AutoDispose for automatic memory management
- ✅ Unified widgets (JetBuilder) for common patterns
- ✅ Infinite scroll with any API format (JetPaginator)
- ✅ Built-in pull-to-refresh functionality
- ✅ Automatic loading and error states
- ✅ Skeleton loading with shimmer effects

## Table of Contents

- [Overview](#overview)
- [JetConsumerWidget](#jetconsumerwidget)
- [JetConsumerStatefulWidget](#jetconsumerstatefulwidget)
- [JetBuilder](#jetbuilder)
  - [Skeleton Loading](#skeleton-loading)
- [JetPaginator](#jetpaginator)
- [Family Providers](#family-providers)
- [Riverpod 3 Generators](#riverpod-3-generators)
- [Best Practices](#best-practices)

## Overview

Jet provides powerful state management built on **Riverpod 3** with enhanced widgets for common patterns and code generation support.

**Key Features:**
- ✅ Built on Riverpod 3 for robust state management
- ✅ Unified JetBuilder for lists, grids, single items
- ✅ JetPaginator for infinite scroll with any API format
- ✅ JetConsumerWidget for enhanced consumer access
- ✅ Family provider support for parameterized data
- ✅ Riverpod 3 code generation support
- ✅ Automatic pull-to-refresh functionality
- ✅ Automatic error handling and loading states
- ✅ Skeleton loading with customizable effects

## JetConsumerWidget

Enhanced consumer widget that provides access to both Riverpod and the Jet framework.

### Features

- Access to `WidgetRef` for Riverpod state
- Direct access to `Jet` instance as a parameter in build method
- Clean, concise API - no need to call `jet(ref)`
- Type-safe with all parameters explicit in method signature

### Basic Usage

```dart
import 'package:jet/jet.dart';

class DashboardPage extends JetConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref, Jet jet) {
    final user = ref.watch(userProvider);
    final router = jet.router;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => router.push(SettingsRoute()),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: user.when(
        data: (userData) => UserProfile(user: userData),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(error: error.toString()),
      ),
    );
  }
}
```

### Migration from jet(ref) Pattern

The new JetConsumerWidget passes `jet` directly as a parameter, eliminating the need to call `jet(ref)`:

```dart
// Old pattern - required calling jet(ref)
class MyWidget extends JetConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myJet = jet(ref);
    final router = myJet.router;
    // ...
  }
}

// New pattern - jet is passed directly
class MyWidget extends JetConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref, Jet jet) {
    final router = jet.router;
    // ...
  }
}
```

**Benefits of the new pattern:**
- ✅ Cleaner API with jet passed directly
- ✅ No need to call `jet(ref)` anymore
- ✅ Consistent with functional JetConsumer widget
- ✅ Better discoverability with explicit parameter

### Functional JetConsumer Widget

For cases where you don't need to extend a class, use the functional `JetConsumer` widget:

```dart
import 'package:jet/jet.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetConsumer(
      builder: (context, ref, jet) {
        final user = ref.watch(userProvider);
        final router = jet.router;
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome ${user.name}'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () => router.push(ProfileRoute()),
              child: Text('Go to Profile'),
            ),
          ),
        );
      },
    );
  }
}
```

**When to use JetConsumer:**
- Simple widgets that don't need their own class
- Quick prototyping
- Inline widget creation
- Reducing boilerplate for simple use cases

## JetConsumerStatefulWidget

Enhanced stateful consumer widget that provides access to both Riverpod and the Jet framework with full state management capabilities.

### Features

- All lifecycle methods of StatefulWidget (initState, dispose, etc.)
- Access to `ref` property throughout the state lifecycle
- Access to `jet` getter for framework features
- Type-safe and IDE-friendly

### Basic Usage

```dart
import 'package:jet/jet.dart';

class CounterPage extends JetConsumerStatefulWidget {
  const CounterPage({super.key});
  
  @override
  JetConsumerState<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends JetConsumerState<CounterPage> {
  int _localCounter = 0;
  
  @override
  void initState() {
    super.initState();
    // Access jet in initState
    final config = jet.config;
    print('App initialized with theme: ${config.themeMode}');
  }
  
  @override
  Widget build(BuildContext context) {
    // Access both jet and ref in build
    final globalCount = ref.watch(globalCounterProvider);
    final router = jet.router;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter: $_localCounter'),
        actions: [
          IconButton(
            onPressed: () => router.push(SettingsRoute()),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Local: $_localCounter'),
            Text('Global: $globalCount'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _localCounter++;
                });
                ref.read(globalCounterProvider.notifier).increment();
              },
              child: Text('Increment Both'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### When to Use Stateful vs Stateless

#### Use JetConsumerWidget (Stateless) when:
- You only need to display data from providers
- No local state management is required
- Simple UI without animations or controllers

#### Use JetConsumerStatefulWidget (Stateful) when:
- You need local state (e.g., form data, animations)
- You need lifecycle methods (initState, dispose)
- Managing controllers (TextEditingController, AnimationController)
- Complex UI interactions requiring setState

## JetBuilder

Unified state widget for handling lists, grids, and single items with automatic loading/error states.

### Features

- ✅ Unified API for lists, grids, and single items
- ✅ Automatic pull-to-refresh
- ✅ Built-in loading and error handling
- ✅ Skeleton loading with shimmer effects
- ✅ Family provider support
- ✅ Type-safe with generics
- ✅ Optimized performance with minimal rebuilds
- ✅ Optional key support for advanced widget identity

### Performance Optimizations

JetBuilder includes several performance optimizations to ensure smooth rendering even with large datasets:

- **Reduced Widget Rebuilds**: Memoized refresh handlers and optimized builder functions minimize unnecessary widget recreation
- **Improved Type Safety**: Better generic constraints eliminate unsafe type casts and prevent runtime errors
- **Widget Identity Support**: Optional `key` parameter enables Flutter to better track and optimize widget rebuilds when items have stable identifiers
- **Code Efficiency**: Extracted common logic reduces code duplication and improves maintainability
- **Memory Optimization**: Better widget caching potential through const optimization where possible

These optimizations are transparent to developers—existing code continues to work without modification while automatically benefiting from improved performance.

### List View

```dart
// Provider definition
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});

// Simple list with pull-to-refresh
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JetBuilder.list<Post>(
        provider: postsProvider,
        itemBuilder: (post, index) => ListTile(
          title: Text(post.title),
          subtitle: Text(post.excerpt),
          onTap: () => context.router.push(PostDetailsRoute(post: post)),
        ),
      ),
    );
  }
}
```

### Grid Layout

```dart
class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.grid<Product>(
      provider: productsProvider,
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      itemBuilder: (product, index) => Card(
        child: Column(
          children: [
            Image.network(product.imageUrl),
            Text(product.name),
            Text('\$${product.price}'),
            ElevatedButton(
              onPressed: () => _addToCart(product),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    );
  }
}
```

### Single Item

```dart
class UserDetailsPage extends StatelessWidget {
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JetBuilder.item<User>(
        provider: userProvider(userId),
        builder: (user) => UserDetailCard(user: user),
      ),
    );
  }
}
```

### API Reference

**JetBuilder.list Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `context` | `BuildContext` | Yes | Build context |
| `provider` | `ProviderBase<AsyncValue<List<T>>>` | Yes | Riverpod provider |
| `itemBuilder` | `Widget Function(T, int)` | Yes | Item builder function |
| `onRefresh` | `Future<void> Function()?` | No | Custom refresh handler |
| `onRetry` | `VoidCallback?` | No | Custom retry handler |
| `loading` | `Widget?` | No | Custom loading widget |
| `empty` | `Widget?` | No | Custom empty state widget |
| `emptyTitle` | `String?` | No | Empty state title |
| `error` | `Widget Function(Object, StackTrace?)?` | No | Custom error widget |
| `controller` | `ScrollController?` | No | Scroll controller |
| `scrollPhysics` | `ScrollPhysics?` | No | Scroll physics |
| `padding` | `EdgeInsetsGeometry?` | No | List padding |
| `itemExtent` | `double?` | No | Fixed item extent |
| `shrinkWrap` | `bool` | No | Shrink wrap |
| `scrollDirection` | `Axis` | No | Scroll direction |
| `separatorBuilder` | `Widget Function(BuildContext, int)?` | No | Separator builder |
| `loadingStyle` | `LoadingStyle?` | No | Loading style: normal, skeleton, or none |
| `skeletonConfig` | `SkeletonConfig?` | No | Skeleton loading configuration |
| `skeletonBuilder` | `Widget Function()?` | No | Custom skeleton layout builder |
| `key` | `Key?` | No | Optional key for ListView widget for better rebuild optimization |

**JetBuilder.grid Parameters:**

Same as list, plus:

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `crossAxisCount` | `int` | Yes | Number of columns |
| `crossAxisSpacing` | `double` | No | Horizontal spacing |
| `mainAxisSpacing` | `double` | No | Vertical spacing |
| `childAspectRatio` | `double` | No | Item aspect ratio |
| `key` | `Key?` | No | Optional key for GridView widget for better rebuild optimization |

### Best Practices for JetBuilder

#### 1. Use Keys for Stable Item Identifiers

When your list items have stable, unique identifiers, provide a key to optimize Flutter's rebuild process:

```dart
JetBuilder.list<Post>(
  context: context,
  provider: postsProvider,
  key: const Key('posts_list'),  // Helps Flutter track widget identity
  itemBuilder: (post, index) => PostCard(
    key: ValueKey(post.id),  // Key each item by its unique ID
    post: post,
  ),
)
```

**When to use keys:**
- Items have unique, stable IDs (database IDs, UUIDs)
- List can be reordered, filtered, or sorted
- Items are complex widgets with expensive build operations

#### 2. Leverage Type Safety

Always specify generic types for compile-time safety:

```dart
// Good - type-safe
JetBuilder.list<Post>(
  context: context,
  provider: postsProvider,
  itemBuilder: (post, index) => PostCard(post: post),
)

// Avoid - loses type inference benefits
JetBuilder.list(
  context: context,
  provider: postsProvider,
  itemBuilder: (post, index) => PostCard(post: post as Post),
)
```

#### 3. Optimize Large Lists

For large datasets (hundreds or thousands of items), consider:

- Using `shrinkWrap: false` (default) when possible
- Providing a `ScrollController` if you need scroll position tracking
- Using `itemExtent` for fixed-height items to improve scroll performance

```dart
JetBuilder.list<Product>(
  context: context,
  provider: productsProvider,
  itemExtent: 80.0,  // Fixed height improves performance
  controller: _scrollController,
  itemBuilder: (product, index) => ProductListItem(product: product),
)
```

#### 4. Custom Empty States

Provide meaningful empty states for better UX:

```dart
JetBuilder.list<Message>(
  context: context,
  provider: messagesProvider,
  itemBuilder: (message, index) => MessageCard(message: message),
  empty: EmptyMessagesWidget(
    icon: Icons.inbox_outlined,
    title: 'No messages yet',
    subtitle: 'Start a conversation to see messages here',
  ),
)
```

#### 5. Grid Layout Optimization

For grids, adjust `crossAxisCount` based on screen size:

```dart
JetBuilder.grid<Photo>(
  context: context,
  provider: photosProvider,
  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
  childAspectRatio: 1.0,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  itemBuilder: (photo, index) => PhotoCard(photo: photo),
)
```

### Skeleton Loading

JetBuilder supports skeleton loading states powered by the [skeletonizer](https://pub.dev/packages/skeletonizer) package. Skeleton screens provide a better user experience by showing a placeholder UI with shimmer effects while content loads, giving users a preview of the content structure.

**Features:**
- ✅ Three loading styles: normal, skeleton, none
- ✅ Multiple skeleton effects: shimmer, pulse, fade
- ✅ Global configuration via JetConfig
- ✅ Per-widget customization
- ✅ Manual skeleton builders for complex layouts
- ✅ Automatic or custom skeleton generation

#### Loading Styles

The `LoadingStyle` enum provides three options for displaying loading states:

```dart
enum LoadingStyle {
  normal,    // Default CircularProgressIndicator
  skeleton,  // Skeleton loading with shimmer effects
  none,      // No loading indicator
}
```

#### Basic Usage

Use skeleton loading by setting the `loadingStyle` parameter:

```dart
JetBuilder.list<Post>(
  context: context,
  provider: postsProvider,
  loadingStyle: LoadingStyle.skeleton,
  itemBuilder: (post, index) => PostCard(post: post),
)
```

#### Global Configuration

Set a default loading style for your entire app in `JetConfig`:

```dart
class AppConfig extends JetConfig {
  @override
  LoadingStyle get defaultLoadingStyle => LoadingStyle.skeleton;
  
  @override
  SkeletonConfig get defaultSkeletonConfig => SkeletonConfig.shimmer(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    duration: Duration(seconds: 2),
  );
  
  // ... other config
}
```

Now all JetBuilder widgets will use skeleton loading by default:

```dart
// Uses global skeleton loading style
JetBuilder.list<Post>(
  context: context,
  provider: postsProvider,
  itemBuilder: (post, index) => PostCard(post: post),
)

// Override to use normal loading for specific widget
JetBuilder.list<User>(
  context: context,
  provider: usersProvider,
  loadingStyle: LoadingStyle.normal,  // Override global setting
  itemBuilder: (user, index) => UserCard(user: user),
)
```

#### Skeleton Effects

The `SkeletonConfig` class provides three built-in effects:

**1. Shimmer Effect (Default)**

Creates a shimmering animation that sweeps across skeleton elements:

```dart
JetBuilder.list<Product>(
  context: context,
  provider: productsProvider,
  loadingStyle: LoadingStyle.skeleton,
  skeletonConfig: SkeletonConfig.shimmer(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    duration: Duration(milliseconds: 1500),
  ),
  itemBuilder: (product, index) => ProductCard(product: product),
)
```

**2. Pulse Effect**

Elements fade in and out with a pulsing animation:

```dart
JetBuilder.grid<Photo>(
  context: context,
  provider: photosProvider,
  crossAxisCount: 2,
  loadingStyle: LoadingStyle.skeleton,
  skeletonConfig: SkeletonConfig.pulse(
    duration: Duration(milliseconds: 1000),
  ),
  itemBuilder: (photo, index) => PhotoCard(photo: photo),
)
```

**3. Fade Effect**

Simple fade animation on skeleton elements:

```dart
JetBuilder.list<Message>(
  context: context,
  provider: messagesProvider,
  loadingStyle: LoadingStyle.skeleton,
  skeletonConfig: SkeletonConfig.fade(),
  itemBuilder: (message, index) => MessageTile(message: message),
)
```

#### Custom Skeleton Builders

For complex layouts, provide a custom skeleton builder that shows fake data:

```dart
JetBuilder.list<Post>(
  context: context,
  provider: postsProvider,
  loadingStyle: LoadingStyle.skeleton,
  skeletonConfig: SkeletonConfig.shimmer(),
  skeletonBuilder: () {
    // Return a skeleton layout with fake data
    return ListView.builder(
      itemCount: 5,  // Show 5 skeleton items
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(16),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text('Loading post title here'),
          subtitle: Text('Loading post description that will be replaced'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  },
  itemBuilder: (post, index) => PostCard(post: post),
)
```

#### Advanced Customization

Fine-tune skeleton appearance with detailed configuration:

```dart
JetBuilder.list<Article>(
  context: context,
  provider: articlesProvider,
  loadingStyle: LoadingStyle.skeleton,
  skeletonConfig: SkeletonConfig(
    enabled: true,
    effect: SkeletonEffect.shimmer,
    baseColor: Colors.grey[300],
    highlightColor: Colors.white,
    duration: Duration(seconds: 2),
    ignoreContainers: true,  // Don't skeletonize container widgets
    justifyMultiLineText: true,  // Justify multi-line text skeletons
  ),
  skeletonBuilder: () => ListView.builder(
    itemCount: 7,
    padding: EdgeInsets.all(16),
    itemBuilder: (context, index) => Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Article Title Goes Here',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Article description and preview text that shows what the content will look like when loaded',
              maxLines: 2,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 4),
                Text('5 min read'),
                SizedBox(width: 16),
                Icon(Icons.favorite_border, size: 16),
                SizedBox(width: 4),
                Text('24'),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
  itemBuilder: (article, index) => ArticleCard(article: article),
)
```

#### Grid Skeleton Loading

Skeleton loading works seamlessly with grid layouts:

```dart
JetBuilder.grid<Product>(
  context: context,
  provider: productsProvider,
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  padding: EdgeInsets.all(16),
  loadingStyle: LoadingStyle.skeleton,
  skeletonBuilder: () => GridView.builder(
    padding: EdgeInsets.all(16),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    ),
    itemCount: 6,  // Show 6 skeleton items
    itemBuilder: (context, index) => Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(color: Colors.grey[200]),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Name', style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('\$99.99', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
  itemBuilder: (product, index) => ProductCard(product: product),
)
```

#### Single Item Skeleton

For single item views, skeleton loading provides a smooth loading experience:

```dart
JetBuilder.item<User>(
  context: context,
  provider: userProvider(userId),
  loadingStyle: LoadingStyle.skeleton,
  skeletonBuilder: () => Card(
    margin: EdgeInsets.all(16),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          SizedBox(height: 16),
          Text('User Name', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('user@email.com', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Text(
            'User bio and description text goes here and will be replaced with actual content',
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    ),
  ),
  builder: (user, ref) => UserProfile(user: user),
)
```

#### Best Practices for Skeleton Loading

**1. Match Your Content Structure**

Design skeleton screens that closely match your actual content layout:

```dart
// Good - skeleton matches actual content structure
skeletonBuilder: () => ListView.builder(
  itemCount: 5,
  itemBuilder: (context, index) => ListTile(
    leading: CircleAvatar(),
    title: Text('Loading title'),
    subtitle: Text('Loading subtitle'),
    trailing: Icon(Icons.arrow_forward),
  ),
),
```

**2. Use Realistic Item Counts**

Show a reasonable number of skeleton items based on typical screen content:

```dart
// Mobile: 5-7 items
skeletonBuilder: () => ListView.builder(
  itemCount: 6,
  itemBuilder: (context, index) => SkeletonItem(),
),

// Grid: Based on screen size
skeletonBuilder: () => GridView.builder(
  itemCount: MediaQuery.of(context).size.width > 600 ? 12 : 6,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
  ),
  itemBuilder: (context, index) => SkeletonCard(),
),
```

**3. Keep It Simple**

Don't overcomplicate skeleton screens—focus on the main content structure:

```dart
// Good - simple and clear
skeletonBuilder: () => ListView.builder(
  itemCount: 5,
  itemBuilder: (context, index) => Card(
    child: ListTile(
      title: Text('Loading'),
      subtitle: Text('Description'),
    ),
  ),
),

// Avoid - too detailed
skeletonBuilder: () => /* Complex nested structure with many widgets */,
```

**4. Use Consistent Effects**

Stick to one effect type throughout your app for consistency:

```dart
class AppConfig extends JetConfig {
  @override
  SkeletonConfig get defaultSkeletonConfig => SkeletonConfig.shimmer();
  // All skeleton screens will use shimmer effect
}
```

**5. Consider Performance**

For complex screens, use simpler skeleton layouts to maintain smooth animations:

```dart
JetBuilder.list<ComplexItem>(
  context: context,
  provider: complexItemsProvider,
  loadingStyle: LoadingStyle.skeleton,
  // Simple skeleton for complex items
  skeletonBuilder: () => ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) => Card(
      margin: EdgeInsets.all(8),
      child: Container(height: 100),  // Simple placeholder
    ),
  ),
  itemBuilder: (item, index) => ComplexItemCard(item: item),
)
```

#### API Reference

**LoadingStyle Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `loadingStyle` | `LoadingStyle?` | Loading style: `normal`, `skeleton`, or `none` |
| `skeletonConfig` | `SkeletonConfig?` | Configuration for skeleton effects |
| `skeletonBuilder` | `Widget Function()?` | Custom skeleton layout builder |

**SkeletonConfig Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `enabled` | `bool` | `true` | Whether skeleton is enabled |
| `effect` | `SkeletonEffect` | `shimmer` | Effect type: `shimmer`, `pulse`, or `fade` |
| `baseColor` | `Color?` | `Colors.grey[300]` | Base color for skeleton |
| `highlightColor` | `Color?` | `Colors.grey[100]` | Highlight color for effects |
| `duration` | `Duration` | `1500ms` | Animation duration |
| `ignoreContainers` | `bool` | `false` | Whether to skip container widgets |
| `containersColor` | `Color?` | `null` | Color for container widgets |
| `justifyMultiLineText` | `bool` | `true` | Justify multi-line text skeletons |

**SkeletonConfig Factory Constructors:**

```dart
// Shimmer effect with custom settings
SkeletonConfig.shimmer(
  baseColor: Colors.grey[300],
  highlightColor: Colors.grey[100],
  duration: Duration(milliseconds: 1500),
)

// Pulse effect
SkeletonConfig.pulse(
  duration: Duration(milliseconds: 1000),
)

// Fade effect
SkeletonConfig.fade()
```

## JetPaginator

Powerful infinite scroll pagination that works with **ANY** API format.

### Features

- ✅ **Universal API Support** - Works with offset-based, page-based, cursor-based, or custom pagination
- ✅ **Official Package** - Built on `infinite_scroll_pagination`
- ✅ **Pull-to-Refresh** - Integrated with customizable indicators
- ✅ **Smart Error Handling** - Built-in error handling with retry
- ✅ **List & Grid Layouts** - Support for both views
- ✅ **Type-Safe** - Full generic type support
- ✅ **Customizable** - Extensive customization options

### Basic List

```dart
import 'package:jet/jet.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: JetPaginator.list<Product, Map<String, dynamic>>(
        fetchPage: (pageKey) async {
          final response = await api.getProducts(
            skip: pageKey as int,
            limit: 20,
          );
          return response;
        },
        parseResponse: (response, pageKey) => PageInfo(
          items: (response['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList(),
          nextPageKey: response['skip'] + response['limit'] < response['total']
              ? response['skip'] + response['limit']
              : null,
        ),
        itemBuilder: (product, index) => ListTile(
          leading: Image.network(product.imageUrl),
          title: Text(product.name),
          subtitle: Text('\$${product.price}'),
          onTap: () => _viewProduct(product),
        ),
      ),
    );
  }
}
```

### Grid Layout

```dart
JetPaginator.grid<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey as int, limit: 20),
  parseResponse: (response, pageKey) => PageInfo(
    items: (response['products'] as List)
        .map((json) => Product.fromJson(json))
        .toList(),
    nextPageKey: response['skip'] + response['limit'] < response['total']
        ? response['skip'] + response['limit']
        : null,
  ),
  itemBuilder: (product, index) => ProductCard(product: product),
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 0.75,
)
```

### API Response Formats

JetPaginator works with any API format. Here are common examples:

#### Offset-Based (DummyJSON, Skip/Limit)

```dart
// API Response:
{
  "products": [...],
  "total": 100,
  "skip": 0,
  "limit": 20
}

// Parse Response:
parseResponse: (response, pageKey) => PageInfo(
  items: (response['products'] as List)
      .map((json) => Product.fromJson(json))
      .toList(),
  nextPageKey: response['skip'] + response['limit'] < response['total']
      ? response['skip'] + response['limit']
      : null,
  totalItems: response['total'],
),
```

#### Page-Based (Page Number)

```dart
// API Response:
{
  "data": [...],
  "current_page": 1,
  "last_page": 10,
  "per_page": 15,
  "total": 150
}

// Parse Response:
parseResponse: (response, currentPage) => PageInfo(
  items: (response['data'] as List)
      .map((json) => User.fromJson(json))
      .toList(),
  nextPageKey: response['current_page'] < response['last_page']
      ? (currentPage as int) + 1
      : null,
  totalItems: response['total'],
),
firstPageKey: 1, // Start from page 1
```

#### Cursor-Based (Cursor/Token)

```dart
// API Response:
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true
  }
}

// Parse Response:
parseResponse: (response, currentCursor) => PageInfo(
  items: (response['data'] as List)
      .map((json) => Post.fromJson(json))
      .toList(),
  nextPageKey: response['pagination']?['next_cursor'],
  isLastPage: !(response['pagination']?['has_more'] ?? false),
),
firstPageKey: null, // Initial cursor is null
```

#### Laravel Pagination

```dart
// API Response:
{
  "data": [...],
  "current_page": 1,
  "last_page": 5,
  "per_page": 15,
  "total": 73
}

// Parse Response using Jet's helper:
parseResponse: (response, currentPage) {
  final pagination = PaginationResponse.fromLaravel(
    response,
    Article.fromJson,
  );

  return PageInfo<Article>(
    items: pagination.items,
    nextPageKey: pagination.nextPageKey,
    isLastPage: pagination.isLastPage,
    totalItems: pagination.total,
  );
},
firstPageKey: 1,
```

### Customization

#### Custom Loading Indicator

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  loadingIndicator: CircularProgressIndicator(
    color: Colors.green,
    strokeWidth: 3,
  ),
)
```

#### Custom Error Handling

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  errorIndicator: (error, ref) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, size: 64, color: Colors.red),
      SizedBox(height: 16),
      Text('Failed to load products'),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => ref.invalidate(productsProvider),
        child: Text('Retry'),
      ),
    ],
  ),
)
```

#### Custom Empty State

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  noItemsIndicator: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
      SizedBox(height: 16),
      Text('No products found', style: TextStyle(fontSize: 18)),
      SizedBox(height: 8),
      Text('Try adjusting your filters'),
    ],
  ),
)
```

### Riverpod Integration

```dart
// Non-family provider
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllProducts();
});

// Use with provider integration
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  provider: allProductsProvider, // Enable Riverpod integration
)
```

### API Reference

**JetPaginator.list Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `fetchPage` | `Function` | Yes | - | Function that fetches a page |
| `parseResponse` | `Function` | Yes | - | Extracts PageInfo from response |
| `itemBuilder` | `Function` | Yes | - | Builds each item widget |
| `firstPageKey` | `dynamic` | No | `0` | Initial page key |
| `enablePullToRefresh` | `bool` | No | `true` | Enable pull-to-refresh |
| `provider` | `Object?` | No | `null` | Optional Riverpod provider |
| `loadingIndicator` | `Widget?` | No | `null` | Custom loading widget |
| `errorIndicator` | `Function?` | No | `null` | Custom error widget |
| `noItemsIndicator` | `Widget?` | No | `null` | Custom empty state |
| `padding` | `EdgeInsets?` | No | `null` | List padding |
| `itemsThresholdToTriggerLoad` | `int` | No | `3` | Items from end to trigger load |

**PageInfo Class:**

```dart
class PageInfo<T> {
  final List<T> items;           // Items for current page
  final dynamic nextPageKey;     // Key for next page (null if last)
  final bool? isLastPage;        // Whether this is the last page
  final int? totalItems;         // Total number of items
}
```

## Family Providers

Use family providers for parameterized data:

```dart
// Family provider for category-based posts
final postsByCategoryProvider = AutoDisposeFutureProvider.family<List<Post>, String>(
  (ref, categoryId) async {
    final api = ref.read(apiServiceProvider);
    return await api.getPostsByCategory(categoryId);
  },
);

// Using with JetBuilder
class CategoryPostsList extends StatelessWidget {
  final String categoryId;
  
  @override
  Widget build(BuildContext context) {
    return JetBuilder.familyList<Post, String>(
      provider: postsByCategoryProvider,
      param: categoryId,
      itemBuilder: (post, index) => PostCard(
        post: post,
        onLike: () => _toggleLike(post.id),
      ),
    );
  }
}
```

## Riverpod 3 Generators

Use the new generator syntax for cleaner provider definitions:

### Traditional Approach

```dart
final postsProvider = AutoDisposeFutureProvider<List<Post>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
});
```

### Riverpod 3 Generator Approach (Recommended)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_provider.g.dart';

@riverpod
Future<List<Post>> posts(PostsRef ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllPosts();
}

// Family provider with generators
@riverpod
Future<List<Post>> postsByCategory(PostsByCategoryRef ref, String categoryId) async {
  final api = ref.read(apiServiceProvider);
  return await api.getPostsByCategory(categoryId);
}

// Using generated providers
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return JetBuilder.list<Post>(
      provider: postsProvider, // Generated provider
      itemBuilder: (post, index) => PostCard(post: post),
    );
  }
}
```

**Benefits:**
- ✅ Automatic provider creation
- ✅ Type-safe provider dependencies
- ✅ Compile-time checks
- ✅ Hot reload support
- ✅ Cleaner syntax

## Best Practices

### 1. Use AutoDispose Providers

```dart
// Good
final userProvider = AutoDisposeFutureProvider<User>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getCurrentUser();
});

// Avoid - keeps provider alive unnecessarily
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getCurrentUser();
});
```

### 2. Use Family Providers for Parameterized Data

```dart
// Good
final postProvider = AutoDisposeFutureProvider.family<Post, String>(
  (ref, postId) async {
    final api = ref.read(apiServiceProvider);
    return await api.getPost(postId);
  },
);

// Avoid - creating separate providers for each parameter
final post1Provider = AutoDisposeFutureProvider<Post>((ref) async {...});
final post2Provider = AutoDisposeFutureProvider<Post>((ref) async {...});
```

### 3. Use Code Generation

```dart
// Good - using generators
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getCurrentUser();
}

// Acceptable - manual provider
final currentUserProvider = AutoDisposeFutureProvider<User>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getCurrentUser();
});
```

### 4. Always Specify Generic Types

```dart
// Good
JetBuilder.list<Post>(...)
JetPaginator.list<Product, Map<String, dynamic>>(...)

// Bad - loses type safety
JetBuilder.list(...)
JetPaginator.list(...)
```

### 5. Use Select for Granular State Watching

```dart
// Good - only rebuilds when name changes
final userName = ref.watch(
  userProvider.select((user) => user.value?.name),
);

// Avoid - rebuilds on any user change
final user = ref.watch(userProvider);
final userName = user.value?.name;
```

### 6. Use JetPaginator for Large Lists

```dart
// Good - efficient pagination
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(page: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
)

// Avoid - loading all items at once
JetBuilder.list<Product>(
  provider: allProductsProvider, // Loads all products
  itemBuilder: (product, index) => ProductCard(product: product),
)
```

## See Also

- [Forms Documentation](FORMS.md) - Form state management
- [Networking Documentation](NETWORKING.md) - API integration
- [Error Handling Documentation](ERROR_HANDLING.md) - Error handling patterns

