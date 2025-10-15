# Dialogs and Sheets Documentation

Complete guide to dialogs and bottom sheets in the Jet framework.

## Overview

Jet provides beautiful, adaptive dialogs and bottom sheets with built-in confirmation workflows. The dialogs automatically adapt to platform conventions (Material on Android, Cupertino on iOS) for a native feel on each platform.

**Packages Used:**
- Flutter SDK - Material and Cupertino dialog widgets
- **flutter_hooks** - ^0.20.5 - [pub.dev](https://pub.dev/packages/flutter_hooks) - For stateful dialog management

**Key Benefits:**
- ✅ Platform-aware design (Material on Android, Cupertino on iOS)
- ✅ Haptic feedback on user interaction
- ✅ Async operation support with Future-based API
- ✅ Customizable actions with callbacks
- ✅ Visual feedback with colored icons and themes
- ✅ Flexible button layouts (horizontal/vertical)
- ✅ Built-in localization support
- ✅ Confirmation sheet types (success, error, warning, info, normal)
- ✅ Barrier dismissible options
- ✅ Custom styling support

## Adaptive Confirmation Dialog

Platform-aware dialogs that adapt to iOS and Android design patterns.

### Basic Usage

```dart
await showAdaptiveConfirmationDialog(
  context: context,
  title: 'Delete Account',
  message: 'Are you sure you want to delete your account? This action cannot be undone.',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  onConfirm: () async {
    await deleteAccount();
    context.router.pushNamed('/login');
  },
  onCancel: () {
    // Handle cancel action
  },
);
```

### With Icon

```dart
await showAdaptiveConfirmationDialog(
  context: context,
  title: 'Logout',
  message: 'Are you sure you want to logout?',
  icon: Icon(Icons.logout, size: 48, color: Colors.orange),
  confirmText: 'Logout',
  cancelText: 'Cancel',
  onConfirm: () async {
    await performLogout();
  },
);
```

### Custom Behavior

```dart
await showAdaptiveConfirmationDialog(
  context: context,
  title: 'Confirm Action',
  message: 'This is a critical action',
  barrierDismissible: false,  // Prevent dismissing by tapping outside
  popOnConfirm: false,         // Keep dialog open after confirm
  onConfirm: () async {
    await criticalAction();
  },
);
```

## Confirmation Bottom Sheet

Modern bottom sheets with visual feedback and customizable types.

### Basic Usage

```dart
showConfirmationSheet(
  context: context,
  title: 'Save Changes',
  message: 'Do you want to save your changes before leaving?',
  icon: Icons.save_outlined,
  onConfirm: () async {
    await saveChanges();
  },
);
```

### Sheet Types

```dart
// Success sheet
showConfirmationSheet(
  context: context,
  title: 'Success!',
  message: 'Your order has been placed successfully.',
  icon: Icons.check_circle_outline,
  type: ConfirmationSheetType.success,  // Green theme
  confirmText: 'View Order',
  onConfirm: () => context.router.push(OrderDetailsRoute()),
);

// Error sheet
showConfirmationSheet(
  context: context,
  title: 'Error',
  message: 'Failed to process your request. Would you like to retry?',
  icon: Icons.error_outline,
  type: ConfirmationSheetType.error,  // Red theme
  confirmText: 'Retry',
  onConfirm: () async {
    await retryOperation();
  },
);

// Warning sheet
showConfirmationSheet(
  context: context,
  title: 'Warning',
  message: 'This action will overwrite your existing data.',
  icon: Icons.warning_amber_rounded,
  type: ConfirmationSheetType.warning,  // Orange theme
  onConfirm: () async {
    await overwriteData();
  },
);

// Info sheet
showConfirmationSheet(
  context: context,
  title: 'New Feature',
  message: 'Check out our new dark mode feature!',
  icon: Icons.info_outline,
  type: ConfirmationSheetType.info,  // Blue theme
  confirmText: 'Try It',
  onConfirm: () {
    ref.read(themeSwitcherProvider.notifier).toggleTheme();
  },
);
```

### Vertical Button Layout

```dart
showConfirmationSheet(
  context: context,
  title: 'Confirm',
  message: 'Are you sure?',
  buttonLayout: Axis.vertical,  // Stack buttons vertically
  confirmText: 'Confirm',
  cancelText: 'Cancel',
  onConfirm: () async {
    await performAction();
  },
);
```

## Available Sheet Types

- `ConfirmationSheetType.normal` - Default primary color
- `ConfirmationSheetType.success` - Green theme for success messages
- `ConfirmationSheetType.error` - Red theme for errors
- `ConfirmationSheetType.warning` - Orange theme for warnings
- `ConfirmationSheetType.info` - Blue theme for information

## Features

- ✅ Platform-aware design - Material on Android, Cupertino on iOS
- ✅ Haptic feedback - Subtle vibrations on interaction
- ✅ Async operation support - Await user confirmation
- ✅ Customizable actions - Custom text and callbacks
- ✅ Visual feedback - Colored icons and themed buttons
- ✅ Flexible layouts - Horizontal or vertical button arrangement
- ✅ Built-in localization - Uses Jet's i18n system

## See Also

- [Components Documentation](COMPONENTS.md)
- [Extensions Documentation](EXTENSIONS.md)

