# 🏗️ Notification Riverpod Architecture

## Overview

This document explains the architecture of how ProviderContainer flows through the Jet framework to enable Riverpod access in notification events.

---

## 🔄 Architecture Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        boot.dart                            │
│  ┌────────────────────────────────────────────────────┐     │
│  │ 1. Create ProviderContainer                        │     │
│  │    final container = ProviderContainer(...)        │     │
│  │                                                     │     │
│  │ 2. Set on Jet instance                             │     │
│  │    jet.setContainer(container)                     │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                         Jet Class                           │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Stores ProviderContainer as framework resource     │     │
│  │                                                     │     │
│  │ Properties:                                         │     │
│  │ - config: JetConfig                               │     │
│  │ - routerProvider: AutoRouteProvider               │     │
│  │ - container: ProviderContainer ⭐ NEW             │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   NotificationsAdapter                      │
│  ┌────────────────────────────────────────────────────┐     │
│  │ 1. Read container from Jet                         │     │
│  │    jet.container                                   │     │
│  │                                                     │     │
│  │ 2. Pass to JetNotifications                        │     │
│  │    JetNotifications.setContainer(jet.container)    │     │
│  │                                                     │     │
│  │ ⭐ Acts as bridge between framework and service    │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    JetNotifications                         │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Stores container for notification events           │     │
│  │                                                     │     │
│  │ static ProviderContainer? _container;              │     │
│  │                                                     │     │
│  │ Provides getter for events to access:             │     │
│  │ static ProviderContainer? get container            │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                  JetNotificationEvent                       │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Access container via getter                        │     │
│  │                                                     │     │
│  │ ProviderContainer? get container =>                │     │
│  │     JetNotifications.container                     │     │
│  │                                                     │     │
│  │ Use in event handlers:                             │     │
│  │ container?.read(myProvider)                        │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Design Principles

### 1. **Single Source of Truth**
- **Jet class** is the single source of truth for the ProviderContainer
- Container is a first-class framework resource alongside `config` and `routerProvider`
- Other framework components get it from Jet

### 2. **Clear Responsibility Layers**

| Layer | Responsibility | Example |
|-------|---------------|---------|
| **Framework** | Own and manage container | `Jet.container` |
| **Adapter** | Bridge framework to services | `NotificationsAdapter` |
| **Service** | Provide functionality | `JetNotifications` |
| **Event** | Handle specific events | `JetNotificationEvent` |

### 3. **Adapter Pattern**
- Adapters act as **bridges** between framework and services
- NotificationsAdapter:
  - Reads from `jet.container` (framework resource)
  - Passes to `JetNotifications.setContainer()` (service configuration)
  - Decouples framework from service implementation

### 4. **Separation of Concerns**
- **boot.dart**: Creates and initializes
- **Jet**: Stores framework resources
- **Adapter**: Configures services
- **Service**: Provides functionality
- **Event**: Handles specific logic

---

## 💡 Why This Architecture?

### Problem with Previous Approach
```dart
// boot.dart directly calls JetNotifications
JetNotifications.setContainer(container);  // ❌ Tight coupling
```

**Issues:**
- Framework code (boot.dart) directly depends on service (JetNotifications)
- Container not available to other services
- Hard to extend or reuse
- Not following framework patterns

### Solution: Container in Jet Class
```dart
// boot.dart sets on framework
jet.setContainer(container);  // ✅ Framework manages resources

// Adapter bridges to service
JetNotifications.setContainer(jet.container);  // ✅ Adapter configures service
```

**Benefits:**
- ✅ Framework owns the container
- ✅ Adapters configure services
- ✅ Clean separation of concerns
- ✅ Easy to extend to other services
- ✅ Follows framework patterns

---

## 🔌 Extending to Other Services

With container in Jet class, other services can easily access it:

### Example: Deep Linking Service

```dart
class DeepLinkingAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    // Get container from Jet
    final container = jet.container;
    
    // Pass to deep linking service
    DeepLinkHandler.setContainer(container);
    
    // Configure deep link handlers
    DeepLinkHandler.configure(...);
    
    return jet;
  }
}
```

### Example: Background Tasks

```dart
class BackgroundTasksAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    // Get container from Jet
    final container = jet.container;
    
    // Use in background isolates
    BackgroundTaskRunner.initialize(container);
    
    return jet;
  }
}
```

### Example: App Lifecycle Events

```dart
class LifecycleAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    // Get container from Jet
    final container = jet.container;
    
    // Update providers on lifecycle events
    AppLifecycleObserver.initialize(
      onResume: () => container?.read(appStateProvider.notifier).resume(),
      onPause: () => container?.read(appStateProvider.notifier).pause(),
    );
    
    return jet;
  }
}
```

---

## 🎨 Pattern Summary

### The Pattern
1. **Framework creates** the resource (ProviderContainer)
2. **Framework stores** it (Jet.container)
3. **Adapters read** from framework (jet.container)
4. **Adapters configure** services with it
5. **Services provide** access to their domain
6. **Events/Handlers use** it for logic

### Code Example
```dart
// 1. Framework creates & stores
final container = ProviderContainer(...);
jet.setContainer(container);

// 2. Adapter reads & configures
final container = jet.container;
MyService.setContainer(container);

// 3. Service provides access
static ProviderContainer? get container => _container;

// 4. Events use it
container?.read(myProvider);
```

---

## 🚀 Benefits of This Architecture

### 1. **Scalability**
- Easy to add new services that need container access
- Pattern is repeatable and predictable

### 2. **Testability**
- Can inject different containers for different Jet instances
- Easy to mock in tests

### 3. **Maintainability**
- Clear flow: Framework → Adapter → Service → Event
- Easy to understand and debug

### 4. **Flexibility**
- Container is a framework resource, not tied to any service
- Services can be swapped or changed independently

### 5. **Consistency**
- Follows same pattern as router: `jet.routerProvider`
- Consistent API across framework

---

## 📝 Summary

The ProviderContainer flows through the Jet framework in a clean, layered architecture:

1. **Created** in boot.dart
2. **Stored** in Jet class (framework layer)
3. **Passed** by adapters (configuration layer)
4. **Used** by services (service layer)
5. **Accessed** by events (event layer)

This architecture ensures:
- ✅ Single source of truth (Jet class)
- ✅ Clear separation of concerns
- ✅ Reusability across services
- ✅ Consistency with framework patterns
- ✅ Easy to extend and maintain

The adapter pattern makes the connection between framework resources and service implementations, creating a clean and maintainable architecture.

