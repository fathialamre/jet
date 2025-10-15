# Extensions Documentation

Complete guide to utility extensions in the Jet framework.

## Overview

Jet provides powerful extensions to enhance Flutter's built-in classes with commonly needed functionality. These extensions use Dart's extension methods feature to add convenient utilities without modifying the original classes.

**Packages Used:**
- **intl** - ^0.18.1 - [pub.dev](https://pub.dev/packages/intl) - Date formatting for DateTime extensions
- Flutter SDK - BuildContext, Text, and Widget extensions

**Key Benefits:**
- ✅ Fluent, chainable API for common operations
- ✅ Type-safe with full compile-time checking
- ✅ No performance overhead (compile-time extensions)
- ✅ Clean, readable code
- ✅ Context-aware theme and localization access
- ✅ Material Design typography support
- ✅ Flexible date/time formatting
- ✅ Platform detection utilities

## BuildContext Extensions

Access theme, localization, and utilities directly from context.

### Theme Access

```dart
// Access theme
final primaryColor = context.theme.colorScheme.primary;
final textTheme = context.theme.textTheme;
final isDark = context.theme.brightness == Brightness.dark;
```

### Localization

```dart
// Access localization
final localizedText = context.jetI10n.confirm;
final cancelText = context.jetI10n.cancel;
```

### Platform Checks

```dart
if (context.isAndroid) {
  // Android-specific UI
} else if (context.isIOS) {
  // iOS-specific UI
}

if (context.isMobile) {
  // Mobile layout
} else if (context.isDesktop) {
  // Desktop layout
}
```

### Toast Notifications

```dart
// Simple toast
context.showToast('Operation completed successfully!');

// Toast with action button
context.showToast(
  'Failed to load data',
  actionLabel: 'Retry',
  onPressed: () => _retryLoad(),
  duration: Duration(seconds: 5),
);

// Clear previous toasts
context.showToast(
  'New message',
  clearOldToasts: true,
);
```

## Text Extensions

Style text widgets with fluent, chainable methods.

### Theme-Based Typography

```dart
// Material Design typography
Text('Title').titleLarge(context)
Text('Subtitle').titleMedium(context)
Text('Caption').bodySmall(context)
Text('Headline').headlineLarge(context)
Text('Display').displayMedium(context)
Text('Label').labelSmall(context)
```

### Style Modifiers

```dart
// Chainable modifiers
Text('Important Text')
  .titleLarge(context)
  .bold()
  .color(Colors.red)

Text('Centered Bold Text')
  .bodyLarge(context)
  .bold()
  .center()

Text('Link Text')
  .bodyMedium(context)
  .color(Colors.blue)
  .underline()

Text('Custom Size')
  .bodyMedium(context)
  .fontSize(18)
  .bold()
  .color(Theme.of(context).primaryColor)
```

### All Typography Variants

- **Title**: `titleSmall`, `titleMedium`, `titleLarge`
- **Body**: `bodySmall`, `bodyMedium`, `bodyLarge`
- **Headline**: `headlineSmall`, `headlineMedium`, `headlineLarge`
- **Display**: `displaySmall`, `displayMedium`, `displayLarge`
- **Label**: `labelSmall`, `labelMedium`, `labelLarge`

### Example in a Card

```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Product Name').titleLarge(context).bold(),
      SizedBox(height: 8),
      Text('Description text').bodyMedium(context),
      SizedBox(height: 4),
      Text('\$99.99').titleMedium(context).color(Colors.green).bold(),
    ],
  ),
)
```

## DateTime Extensions

Format dates and times with ease.

### Basic Formatting

```dart
final now = DateTime.now();

// Formatted date
final date = now.formattedDate(); // Default: "01/10/2025"
final customDate = now.formattedDate(format: 'MMM dd, yyyy'); // "Oct 01, 2025"

// Formatted time
final time = now.formattedTime(); // Default: "14:30"
final customTime = now.formattedTime(format: 'hh:mm a'); // "02:30 PM"

// Formatted date and time
final dateTime = now.formattedDateTime(); // "01/10/2025 14:30"
final customDateTime = now.formattedDateTime(
  format: 'EEEE, MMMM dd, yyyy at hh:mm a',
); // "Wednesday, October 01, 2025 at 02:30 PM"
```

### Usage in Widgets

```dart
class EventCard extends StatelessWidget {
  final Event event;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.title).titleMedium(context).bold(),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 4),
              Text(event.date.formattedDate(format: 'MMM dd, yyyy'))
                .bodySmall(context),
            ],
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 16),
              SizedBox(width: 4),
              Text(event.date.formattedTime(format: 'hh:mm a'))
                .bodySmall(context),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Number Extensions

Format numbers with custom patterns.

### Order ID Formatting

```dart
int orderId = 123;
String formattedOrderId = orderId.toOrderId(); // "00123"

orderId = 45678;
formattedOrderId = orderId.toOrderId(); // "45678"
```

### Usage in Order Tracking

```dart
class OrderTile extends StatelessWidget {
  final int orderId;
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shopping_bag),
      title: Text('Order #${orderId.toOrderId()}').titleMedium(context).bold(),
      subtitle: Text('Tap to view details').bodySmall(context),
    );
  }
}
```

## Features Summary

- ✅ **BuildContext extensions** - Theme, localization, platform checks, toasts
- ✅ **Text extensions** - Fluent API for Material Design typography
- ✅ **DateTime extensions** - Flexible date/time formatting
- ✅ **Number extensions** - Format numbers for specific use cases
- ✅ **Chainable methods** - Combine multiple style modifiers
- ✅ **Type-safe** - Full compile-time type checking
- ✅ **Performance optimized** - Minimal overhead

## See Also

- [Components Documentation](COMPONENTS.md)
- [Theming Documentation](THEMING.md)
- [Localization Documentation](LOCALIZATION.md)

