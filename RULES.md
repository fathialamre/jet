# 🚀 Jet Framework Rules & Optimization Guide

## 📋 Framework Overview

Jet is a comprehensive Flutter framework that provides:
- **Networking Layer**: Built on Dio with singleton pattern and error handling
- **State Management**: Riverpod-based with unified JetBuilder widget
- **Form Management**: Flutter Form Builder with validation and async handling
- **Localization**: Multi-language support with RTL handling
- **Storage**: Secure and regular storage with type-safe serialization
- **Theming**: Dynamic theme switching with dark mode support
- **Routing**: Auto Route integration with type-safe navigation
- **Error Handling**: Centralized error processing with JetError

## 🎯 Core Design Principles

### 1. **Configuration-First Architecture**
- All app configuration centralized in `JetConfig`
- Adapter pattern for extensibility
- Boot sequence with lifecycle hooks

### 2. **Type Safety**
- Strong typing throughout the framework
- Generic support for API responses
- Type-safe routing with Auto Route

### 3. **Developer Experience**
- Unified widget patterns (JetBuilder)
- Automatic error handling
- Pull-to-refresh built-in

## ⚡ Performance Optimizations

### 1. **Networking Optimizations**

#### Current Issues:
- ❌ Singleton pattern creates unnecessary instances
- ❌ No request deduplication
- ❌ Missing request caching layer
- ❌ No request prioritization

#### Improvements:
```dart
// Add request deduplication
class RequestDeduplicator {
  final Map<String, Future> _pendingRequests = {};
  
  Future<T> deduplicate<T>(String key, Future<T> Function() request) {
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key] as Future<T>;
    }
    
    final future = request().whenComplete(() => _pendingRequests.remove(key));
    _pendingRequests[key] = future;
    return future;
  }
}

// Add response caching with TTL
class ResponseCache {
  final Map<String, CachedResponse> _cache = {};
  
  T? get<T>(String key) {
    final cached = _cache[key];
    if (cached != null && !cached.isExpired) {
      return cached.data as T;
    }
    _cache.remove(key);
    return null;
  }
  
  void set<T>(String key, T data, Duration ttl) {
    _cache[key] = CachedResponse(data, DateTime.now().add(ttl));
  }
}
```

### 2. **State Management Optimizations**

#### Current Issues:
- ❌ No selective rebuilds optimization
- ❌ Missing state persistence
- ❌ No state preloading

#### Improvements:
```dart
// Add state persistence
mixin StatePersistence<T> on StateNotifier<T> {
  String get persistenceKey;
  
  @override
  void initState() {
    super.initState();
    _loadPersistedState();
  }
  
  Future<void> _loadPersistedState() async {
    final persisted = await JetStorage.read<T>(persistenceKey);
    if (persisted != null) {
      state = persisted;
    }
  }
  
  @override
  set state(T value) {
    super.state = value;
    JetStorage.write(persistenceKey, value);
  }
}

// Add provider preloading
class ProviderPreloader {
  static Future<void> preload(WidgetRef ref, List<Provider> providers) async {
    await Future.wait(
      providers.map((p) => ref.read(p.future)),
    );
  }
}
```

### 3. **Widget Optimization**

#### Current Issues:
- ❌ JetBuilder creates unnecessary wrapper widgets
- ❌ No widget recycling for lists
- ❌ Missing image caching strategy

#### Improvements:
```dart
// Optimized JetBuilder with fewer rebuilds
class OptimizedJetBuilder<T> extends ConsumerWidget {
  final AutoDisposeFutureProvider<T> provider;
  final Widget Function(T data) builder;
  
  const OptimizedJetBuilder({
    required this.provider,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(provider);
    
    // Use select to minimize rebuilds
    return asyncValue.maybeWhen(
      data: (data) => RepaintBoundary(
        child: builder(data),
      ),
      orElse: () => const JetLoader(),
    );
  }
}
```

### 4. **Memory Management**

#### Current Issues:
- ❌ No automatic cleanup of unused resources
- ❌ Memory leaks in long-running operations
- ❌ Large images not optimized

#### Improvements:
```dart
// Add resource manager
class ResourceManager {
  static final _disposables = <Disposable>[];
  
  static void register(Disposable resource) {
    _disposables.add(resource);
  }
  
  static void cleanup() {
    for (final resource in _disposables) {
      resource.dispose();
    }
    _disposables.clear();
  }
}

// Image optimization helper
class ImageOptimizer {
  static Widget optimized(String url, {double? width, double? height}) {
    return CachedNetworkImage(
      imageUrl: url,
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      placeholder: (context, url) => const JetLoader(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
```

## 🛠️ Development Speed Improvements

### 1. **Code Generation**

#### Add Templates:
```dart
// Generate boilerplate with jet CLI
// jet generate page UserProfile
// jet generate api UserService
// jet generate form LoginForm
```

### 2. **Hot Reload Enhancements**

```dart
// Add hot reload preservation
class HotReloadState {
  static final Map<String, dynamic> _preserved = {};
  
  static void preserve(String key, dynamic value) {
    _preserved[key] = value;
  }
  
  static T? restore<T>(String key) {
    return _preserved[key] as T?;
  }
}
```

### 3. **Development Mode Helpers**

```dart
// Add debug overlays
class JetDebugOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox();
    
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        children: [
          _buildNetworkIndicator(),
          _buildPerformanceMonitor(),
          _buildStateInspector(),
        ],
      ),
    );
  }
}
```

## 📐 Architecture Rules

### 1. **File Organization**
```
lib/
├── core/
│   ├── config/       # App configuration
│   ├── adapters/     # Jet adapters
│   └── router/       # Routing setup
├── features/
│   └── {feature}/
│       ├── models/   # Data models
│       ├── providers/ # State providers
│       ├── services/ # API services
│       ├── widgets/  # UI components
│       └── pages/    # Screen pages
└── shared/
    ├── widgets/      # Reusable widgets
    └── utils/        # Shared utilities
```

### 2. **Naming Conventions**
- **Pages**: `{Name}Page` (e.g., `LoginPage`)
- **Providers**: `{name}Provider` (e.g., `userProvider`)
- **Services**: `{Name}Service` (e.g., `AuthService`)
- **Models**: `{Name}Model` or just `{Name}` (e.g., `UserModel`, `Product`)

### 3. **Provider Rules**
```dart
// Always use autoDispose for providers
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return UserService.getUser();
});

// Use family for parameterized providers
final productProvider = FutureProvider.autoDispose.family<Product, String>(
  (ref, productId) async {
    return ProductService.getProduct(productId);
  },
);

// Cache providers when appropriate
@Riverpod(keepAlive: true)
Future<AppConfig> appConfig(AppConfigRef ref) async {
  return await loadAppConfig();
}
```

### 4. **Error Handling Rules**
```dart
// Always use JetError for consistent error handling
try {
  // operation
} catch (e, stack) {
  final jetError = jet.config.errorHandler.handle(e, context, stackTrace: stack);
  // Handle jetError
}

// Custom error types
class CustomError extends JetError {
  CustomError() : super(
    type: JetErrorType.client,
    message: 'Custom error occurred',
  );
}
```

## 🚀 Performance Best Practices

### 1. **Lazy Loading**
```dart
// Use lazy loading for heavy components
class LazyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration.zero),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return HeavyWidget();
        }
        return const JetLoader();
      },
    );
  }
}
```

### 2. **List Optimization**
```dart
// Use itemExtent for fixed height items
ListView.builder(
  itemExtent: 80.0, // Fixed height improves performance
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Use const constructors
const ItemWidget(this.item); // Prevents unnecessary rebuilds
```

### 3. **Image Optimization**
```dart
// Always specify dimensions
Image.network(
  url,
  width: 200,
  height: 200,
  cacheWidth: 200, // Cache at display size
  cacheHeight: 200,
)
```

### 4. **State Management**
```dart
// Use select to minimize rebuilds
final userName = ref.watch(userProvider.select((user) => user.name));

// Batch state updates
ref.read(stateProvider.notifier).batchUpdate((state) {
  state.field1 = value1;
  state.field2 = value2;
});
```

## 📦 Bundle Size Optimization

### 1. **Tree Shaking**
```dart
// Use conditional imports
import 'package:jet/jet.dart' if (dart.library.io) 'package:jet/jet_io.dart';

// Remove unused dependencies
// Run: flutter pub deps --no-dev --executables
```

### 2. **Asset Optimization**
```yaml
flutter:
  assets:
    # Use asset variants for different densities
    - assets/images/
    - assets/images/2.0x/
    - assets/images/3.0x/
```

### 3. **Code Splitting**
```dart
// Use deferred loading for large features
import 'package:heavy_feature/heavy_feature.dart' deferred as heavy;

Future<void> loadFeature() async {
  await heavy.loadLibrary();
  heavy.showFeature();
}
```

## 🔧 Development Workflow

### 1. **Quick Start**
```bash
# Create new Jet app
jet create my_app --template=default

# Add new feature
jet generate feature user

# Run with hot reload
jet run --flavor=dev
```

### 2. **Testing Strategy**
```dart
// Unit test providers
test('user provider returns user', () async {
  final container = ProviderContainer();
  final user = await container.read(userProvider.future);
  expect(user.name, 'John');
});

// Widget test with Jet
testWidgets('JetBuilder shows data', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dataProvider.overrideWith(() => AsyncValue.data(['item'])),
      ],
      child: JetBuilder.list(
        provider: dataProvider,
        itemBuilder: (item, index) => Text(item),
      ),
    ),
  );
  
  expect(find.text('item'), findsOneWidget);
});
```

### 3. **Debugging Tools**
```dart
// Enable Jet debug mode
JetConfig(
  debugMode: true,
  enablePerformanceOverlay: true,
  enableNetworkLogging: true,
)

// Use debug helpers
dump('Variable value', variable);
JetLogger.debug('Debug message');
```

## 🎨 UI/UX Best Practices

### 1. **Responsive Design**
```dart
// Use ScreenUtil for responsive sizing
Container(
  width: 100.w, // 100 logical pixels scaled
  height: 50.h,  // 50 logical pixels scaled
  padding: EdgeInsets.all(10.sp), // Scaled padding
)
```

### 2. **Animation Performance**
```dart
// Use implicit animations for simple cases
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  // properties
)

// Use explicit animations for complex cases
class ComplexAnimation extends StatefulWidget {
  @override
  _ComplexAnimationState createState() => _ComplexAnimationState();
}
```

### 3. **Accessibility**
```dart
// Always add semantics
Semantics(
  label: 'Submit button',
  hint: 'Double tap to submit the form',
  child: JetButton(
    onPressed: submit,
    child: Text('Submit'),
  ),
)
```

## 📊 Monitoring & Analytics

### 1. **Performance Monitoring**
```dart
class PerformanceMonitor {
  static void trackScreenLoad(String screenName) {
    final stopwatch = Stopwatch()..start();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stopwatch.stop();
      analytics.logEvent('screen_load', {
        'screen': screenName,
        'duration_ms': stopwatch.elapsedMilliseconds,
      });
    });
  }
}
```

### 2. **Error Tracking**
```dart
// Automatic error reporting
class ErrorReporter {
  static void report(JetError error) {
    if (kReleaseMode) {
      // Send to crash reporting service
      Crashlytics.recordError(
        error.rawError,
        error.stackTrace,
        reason: error.message,
      );
    }
  }
}
```

## 🔐 Security Best Practices

### 1. **Data Protection**
```dart
// Always use secure storage for sensitive data
await JetStorage.writeSecure('token', authToken);

// Encrypt sensitive data in regular storage
final encrypted = encrypt(sensitiveData);
await JetStorage.write('data', encrypted);
```

### 2. **API Security**
```dart
// Use certificate pinning
class SecureApiService extends JetApiService {
  @override
  List<Interceptor> get interceptors => [
    CertificatePinningInterceptor(
      allowedSHAFingerprints: ['SHA256:XXXXXX'],
    ),
  ];
}
```

## 📱 Platform-Specific Optimizations

### 1. **iOS Optimizations**
```dart
// Use Cupertino widgets on iOS
if (Platform.isIOS) {
  return CupertinoPageScaffold(...);
} else {
  return Scaffold(...);
}
```

### 2. **Android Optimizations**
```dart
// Handle Android back button
WillPopScope(
  onWillPop: () async {
    // Custom back navigation logic
    return true;
  },
  child: ...,
)
```

## 🚦 Migration Guide

### From Other Frameworks
```dart
// GetX to Jet
// Before (GetX):
Get.to(NextPage());
// After (Jet):
context.router.push(NextRoute());

// Provider to Jet
// Before (Provider):
Provider.of<UserService>(context).getUser();
// After (Jet):
ref.read(userServiceProvider).getUser();
```

## 📈 Future Optimizations

### Planned Improvements:
1. **Build-time Optimization**
   - Code generation for providers
   - Compile-time validation
   - Dead code elimination

2. **Runtime Performance**
   - Widget recycling pool
   - Predictive prefetching
   - Smart caching strategies

3. **Developer Experience**
   - AI-powered code suggestions
   - Visual debugging tools
   - Performance profiler integration

4. **Framework Core**
   - Incremental rendering
   - Partial hydration
   - Edge computing support

## 🎯 Quick Reference

### Essential Imports
```dart
import 'package:jet/jet_framework.dart'; // Full framework
import 'package:jet/jet.dart';           // Core only
```

### Common Patterns
```dart
// API Service
class UserService extends JetApiService {
  @override
  String get baseUrl => 'https://api.example.com';
  
  Future<User> getUser(String id) => network(
    request: () => get<User>('/users/$id', decoder: User.fromJson),
  );
}

// Provider
final userProvider = FutureProvider.autoDispose<User>((ref) async {
  return UserService().getUser('123');
});

// Page with JetBuilder
class UserPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JetBuilder.item(
      provider: userProvider,
      builder: (user, ref) => UserProfile(user: user),
    );
  }
}
```

## 📝 Checklist for Optimal Performance

- [ ] Use `const` constructors wherever possible
- [ ] Implement proper error handling with JetError
- [ ] Use autoDispose providers by default
- [ ] Specify image dimensions and cache sizes
- [ ] Implement lazy loading for heavy components
- [ ] Use RepaintBoundary for expensive widgets
- [ ] Profile and optimize build methods
- [ ] Minimize widget rebuilds with select()
- [ ] Cache API responses appropriately
- [ ] Use itemExtent for fixed-height lists
- [ ] Implement proper state persistence
- [ ] Add loading and error states
- [ ] Test on low-end devices
- [ ] Monitor bundle size
- [ ] Track performance metrics

---

*This document should be updated as the framework evolves and new optimizations are discovered.*
