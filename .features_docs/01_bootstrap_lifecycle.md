# Bootstrap & Lifecycle

**Status:** Active  
**Version:** 0.0.1  
**Last Updated:** October 1, 2025

## Overview

The Bootstrap & Lifecycle system provides a structured way to initialize the Jet framework and manage the application lifecycle through adapters. It ensures proper initialization order and provides hooks for setup and cleanup.

### Key Benefits
- **Predictable Initialization:** Guaranteed order of operations during app startup
- **Modular Setup:** Adapter pattern allows feature-specific initialization
- **ProviderContainer Access:** Centralized Riverpod container management
- **Lifecycle Hooks:** Clear separation between initialization and post-initialization

### Use Cases
- Initializing services before app starts (storage, cache, notifications)
- Setting up routing and navigation
- Configuring third-party SDKs
- Loading initial data or configuration

## Architecture

### Design Philosophy

The bootstrap system follows a **two-phase initialization pattern**:

1. **Boot Phase:** Services are initialized in order, with each adapter potentially transforming the Jet instance
2. **Finished Phase:** Post-initialization hooks run after the app is fully configured

This ensures dependencies are available when needed and allows for complex initialization flows.

### Component Diagram

```
main.dart
    ↓
Jet.fly() → Boot.start()
    ↓
Create Jet Instance
    ↓
Create ProviderContainer → Set on Jet
    ↓
Boot Adapters (in order)
    ↓
Boot.finished()
    ↓
After Boot Hooks
    ↓
runJetApp() → MaterialApp
```

### Key Components

#### Component 1: Boot
- **Location:** `packages/jet/lib/bootstrap/boot.dart`
- **Purpose:** Orchestrates the application initialization sequence
- **Key Methods:**
  - `start(JetConfig config)`: Creates Jet instance and ProviderContainer, boots adapters
  - `finished(Jet jet, JetConfig config)`: Runs post-boot hooks and launches the app

#### Component 2: Jet
- **Location:** `packages/jet/lib/jet.dart`
- **Purpose:** Core framework instance holding configuration and global services
- **Key Methods:**
  - `fly()`: Static factory for controlled initialization
  - `setContainer()`: Registers the ProviderContainer for app-wide access
  - `setRouter()`: Registers the router provider

#### Component 3: JetAdapter
- **Location:** `packages/jet/lib/adapters/jet_adapter.dart`
- **Purpose:** Abstract interface for feature initialization
- **Key Methods:**
  - `boot(Jet jet)`: Initialize the feature, return modified Jet if needed
  - `afterBoot(Jet jet)`: Post-initialization cleanup or finalization

### Data Flow

```
User defines JetConfig
    ↓
Jet.fly() called from main()
    ↓
Boot.start() creates Jet + ProviderContainer
    ↓
Adapters boot sequentially (can modify Jet)
    ↓
Boot.finished() runs afterBoot hooks
    ↓
runJetApp() launches MaterialApp with UncontrolledProviderScope
    ↓
App runs with access to Jet via jetProvider
```

## Implementation Details

### Core Implementation

```dart
// main.dart - Entry point
void main() async {
  final jet = await Jet.fly(
    setup: () async => await Boot.start(AppConfig()),
    setupFinished: (jet) async => await Boot.finished(jet, AppConfig()),
  );
}

// boot.dart - Initialization sequence
static Future<Jet> start(JetConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Jet instance
  final jet = Jet(config: config);

  // Create ProviderContainer BEFORE adapters
  final container = ProviderContainer(
    overrides: [jetProvider.overrideWith((ref) => jet)],
  );

  // Critical: Set container so adapters can access it
  jet.setContainer(container);

  // Boot adapters with container available
  return bootApplication(config, jet: jet);
}

static Future<void> finished(Jet jet, JetConfig config) async {
  // Run after-boot hooks
  await bootFinished(jet, config);

  // Launch app
  runJetApp(jet: jet);
}
```

### State Management

The bootstrap uses **UncontrolledProviderScope** to inject the pre-created ProviderContainer:

```dart
void runJetApp({required Jet jet}) async {
  runApp(
    UncontrolledProviderScope(
      container: jet.container, // Pre-created container
      child: JetApp(jet: jet),
    ),
  );
}
```

This allows:
- Adapters to access the container during initialization
- Services to use Riverpod providers before the widget tree exists
- Global access to the Jet instance via `jetProvider`

### Error Handling

Currently basic - errors during boot will throw and crash the app. **Future improvement needed:**

```dart
// Recommended enhancement
try {
  final jet = await Jet.fly(
    setup: () async => await Boot.start(AppConfig()),
  );
} catch (error, stack) {
  // Show error screen or fallback UI
  runApp(BootErrorApp(error: error));
}
```

## Usage Examples

### Basic Usage

```dart
// 1. Define your configuration
class AppConfig extends JetConfig {
  @override
  List<JetAdapter> get adapters => [
    StorageAdapter(),
    CacheAdapter(),
    RouterAdapter(),
  ];
  
  @override
  List<LocaleInfo> get supportedLocales => [
    LocaleInfo(locale: const Locale('en'), displayName: 'English'),
  ];
}

// 2. Initialize in main
void main() async {
  final jet = await Jet.fly(
    setup: () async => await Boot.start(AppConfig()),
    setupFinished: (jet) async => await Boot.finished(jet, AppConfig()),
  );
}
```

### Advanced Usage with Custom Adapter

```dart
class DatabaseAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    // Access container during boot
    final container = jet.container;
    
    // Initialize database
    await DatabaseService.initialize();
    
    // Register provider
    container.read(databaseProvider);
    
    return null; // Return modified Jet if needed
  }

  @override
  Future<void> afterBoot(Jet jet) async {
    // Run migrations after all adapters are ready
    await DatabaseService.runMigrations();
  }
}
```

### Accessing Jet in App

```dart
// In widgets
class MyWidget extends JetConsumerWidget {
  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    // Direct access to Jet instance
    final config = jet.config;
    final router = jet.routerProvider;
    
    return Container();
  }
}

// In services
class MyService {
  final Ref ref;
  
  MyService(this.ref);
  
  void doSomething() {
    final jet = ref.read(jetProvider);
    final loader = jet.config.loader;
  }
}
```

## Performance Considerations

### Strengths
- **Lazy Initialization:** Adapters only initialize what's needed
- **Parallel Initialization:** Adapters can run concurrently (with Future.wait if independent)
- **Early Container Creation:** Container available to all adapters, preventing recreation

### Bottlenecks
- **Sequential Adapter Execution:** Default implementation runs adapters in sequence
- **Blocking Boot:** App doesn't start until all adapters complete
- **No Timeout:** Hung adapter blocks app indefinitely

### Optimization Tips

1. **Order Adapters by Dependency:** Put independent adapters first
2. **Parallelize Independent Adapters:**
```dart
// In bootApplication()
final independentAdapters = [StorageAdapter(), CacheAdapter()];
await Future.wait(independentAdapters.map((a) => a.boot(jet)));
```

3. **Use afterBoot for Non-Critical Setup:**
```dart
@override
Future<void> afterBoot(Jet jet) async {
  // Non-blocking background work
  unawaited(preloadData());
}
```

### Benchmarks

| Operation | Time | Notes |
|-----------|------|-------|
| Create Jet + Container | ~5ms | Very fast |
| Boot 3 adapters | ~50-200ms | Depends on adapter complexity |
| Run afterBoot hooks | ~10-50ms | Usually quick |
| Total cold start | ~100-300ms | Acceptable for most apps |

## Common Pitfalls

### Pitfall 1: Using Providers Before Container is Set
**Problem:** Trying to access providers in adapter boot before container exists  
**Solution:** Container is guaranteed to be set before adapters run - always safe to use `jet.container`

```dart
// ✅ CORRECT
class MyAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    final container = jet.container; // Always available
    final myService = container.read(myServiceProvider);
  }
}
```

### Pitfall 2: Circular Adapter Dependencies
**Problem:** Adapter A depends on B, B depends on A  
**Solution:** Extract shared logic to a separate adapter or use afterBoot

```dart
// ❌ BAD - Circular dependency
class AdapterA extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await serviceB.initialize(); // Depends on B
  }
}

class AdapterB extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await serviceA.initialize(); // Depends on A
  }
}

// ✅ GOOD - Use afterBoot
class AdapterA extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await serviceA.initialize();
    return null;
  }
  
  @override
  Future<void> afterBoot(Jet jet) async {
    // Now can safely use serviceB
    await serviceA.connectToB(serviceB);
  }
}
```

### Pitfall 3: Long-Running Operations in boot()
**Problem:** Blocking app start with slow operations  
**Solution:** Move to afterBoot or background task

```dart
// ❌ BAD - Blocks app startup
class DataAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await downloadLargeDataset(); // Could take seconds!
  }
}

// ✅ GOOD - Non-blocking
class DataAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    await initializeDataService(); // Quick setup
    return null;
  }
  
  @override
  Future<void> afterBoot(Jet jet) async {
    // Background download
    unawaited(downloadLargeDataset());
  }
}
```

## Testing

### Unit Tests

```dart
void main() {
  group('Boot', () {
    test('creates Jet instance with config', () async {
      final jet = await Boot.start(TestConfig());
      
      expect(jet.config, isA<TestConfig>());
      expect(jet.container, isNotNull);
    });

    test('boots adapters in order', () async {
      final order = <String>[];
      
      class TestAdapter extends JetAdapter {
        final String name;
        TestAdapter(this.name);
        
        @override
        Future<Jet?> boot(Jet jet) async {
          order.add(name);
          return null;
        }
      }
      
      final config = TestConfig(
        adapters: [
          TestAdapter('A'),
          TestAdapter('B'),
          TestAdapter('C'),
        ],
      );
      
      await Boot.start(config);
      
      expect(order, ['A', 'B', 'C']);
    });
  });
}
```

### Integration Tests

```dart
void main() {
  testWidgets('App boots and shows home screen', (tester) async {
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
```

## Dependencies

### Internal Dependencies
- None (foundation of framework)

### External Dependencies
- `hooks_riverpod: ^3.0.0` - Provider container management
- `flutter/widgets.dart` - WidgetsFlutterBinding

## Future Improvements

### Planned Enhancements
- [ ] Parallel adapter execution for independent adapters
- [ ] Timeout handling for hung adapters
- [ ] Retry mechanism for failed adapters
- [ ] Boot progress indicator
- [ ] Adapter dependency graph resolution
- [ ] Hot reload support for adapters

### Known Issues
- No error recovery if adapter fails
- No way to skip failed adapters
- Sequential execution can be slow

### Breaking Changes Considerations
- Adding required methods to JetAdapter
- Changing boot order behavior
- Modifying ProviderContainer lifecycle

## Related Documentation

- [Dependency Injection](./02_dependency_injection.md)
- [Configuration](./03_configuration.md)
- [Adapters](../packages/jet/lib/adapters/README.md)

## FAQs

**Q: When should I use boot() vs afterBoot()?**  
A: Use `boot()` for critical initialization that must complete before the app starts. Use `afterBoot()` for non-blocking setup that can happen in the background.

**Q: Can I access widgets during boot?**  
A: No, the widget tree doesn't exist yet. Use `afterBoot()` or initialization in a widget's `initState`.

**Q: How do I handle boot errors?**  
A: Currently errors will crash the app. Wrap initialization in try-catch and show an error screen if needed.

**Q: Can I modify the Jet instance in an adapter?**  
A: Yes, return a new Jet instance from `boot()` to replace it. However, this is rarely needed.

---

**Contributors:** Jet Framework Team  
**Reviewers:** Core Team

