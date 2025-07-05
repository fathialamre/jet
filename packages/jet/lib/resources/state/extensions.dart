import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Extension methods for Jet state management
///
/// This file provides convenient extension methods to make working with
/// Riverpod providers and state management even easier.

/// Extension to make it easier to create refresh and error handling with providers
extension JetProviderExtensions on WidgetRef {
  /// Creates a simple refresh callback that invalidates the provider
  ///
  /// Use this for providers that don't need to wait for completion.
  /// The widget will automatically rebuild when the provider state changes.
  Future<void> Function() refreshByInvalidating<T>(
    ProviderBase<AsyncValue<T>> provider,
  ) {
    return () async {
      invalidate(provider);
    };
  }

  /// Creates a refresh callback for family providers
  ///
  /// Use this for family providers that don't need to wait for completion.
  Future<void> Function() refreshFamilyByInvalidating<T, Param>(
    ProviderBase<AsyncValue<T>> Function(Param) provider,
    Param param,
  ) {
    return () async {
      invalidate(provider(param));
    };
  }

  /// Creates a refresh callback for FutureProvider that waits for completion
  ///
  /// This is the recommended approach for FutureProvider as per Riverpod docs.
  /// The refresh indicator stays visible until refresh completes.
  Future<void> Function() refreshFutureProvider<T>(
    FutureProvider<T> provider,
  ) {
    return () => refresh(provider.future);
  }

  /// Creates a refresh callback for AutoDisposeFutureProvider that waits for completion
  ///
  /// This is the recommended approach for AutoDisposeFutureProvider.
  /// The refresh indicator stays visible until refresh completes.
  Future<void> Function() refreshAutoDisposeFutureProvider<T>(
    AutoDisposeFutureProvider<T> provider,
  ) {
    return () => refresh(provider.future);
  }

  /// Creates a refresh callback for FutureProvider.family that waits for completion
  Future<void> Function() refreshFutureProviderFamily<T, Param>(
    FutureProvider<T> Function(Param) provider,
    Param param,
  ) {
    return () => refresh(provider(param).future);
  }

  /// Creates a refresh callback for AutoDisposeFutureProvider.family that waits for completion
  Future<void> Function() refreshAutoDisposeFutureProviderFamily<T, Param>(
    AutoDisposeFutureProvider<T> Function(Param) provider,
    Param param,
  ) {
    return () => refresh(provider(param).future);
  }

  /// Creates a retry callback that invalidates a provider
  ///
  /// Use this for error states when you want to retry an operation.
  VoidCallback retryProvider<T>(ProviderBase<AsyncValue<T>> provider) {
    return () => invalidate(provider);
  }

  /// Creates a retry callback for family providers
  VoidCallback retryFamilyProvider<T, Param>(
    ProviderBase<AsyncValue<T>> Function(Param) provider,
    Param param,
  ) {
    return () => invalidate(provider(param));
  }
}

/// Extension methods for easier error handling in UI
extension JetErrorExtensions on Object {
  /// Gets a user-friendly error message
  String get friendlyMessage {
    if (this is Exception) {
      return toString().replaceFirst('Exception: ', '');
    }
    return toString();
  }

  /// Whether this error is a network-related error
  bool get isNetworkError {
    final message = toString().toLowerCase();
    return message.contains('socket') ||
        message.contains('network') ||
        message.contains('connection') ||
        message.contains('timeout') ||
        message.contains('unreachable');
  }

  /// Whether this error is a timeout error
  bool get isTimeoutError {
    final message = toString().toLowerCase();
    return message.contains('timeout') || message.contains('deadline');
  }

  /// Whether this error is an authentication error
  bool get isAuthError {
    final message = toString().toLowerCase();
    return message.contains('unauthorized') ||
        message.contains('authentication') ||
        message.contains('401');
  }

  /// Whether this error is a permission error
  bool get isPermissionError {
    final message = toString().toLowerCase();
    return message.contains('forbidden') ||
        message.contains('permission') ||
        message.contains('403');
  }

  /// Whether this error is a not found error
  bool get isNotFoundError {
    final message = toString().toLowerCase();
    return message.contains('not found') || message.contains('404');
  }

  /// Whether this error is a server error
  bool get isServerError {
    final message = toString().toLowerCase();
    return message.contains('server') ||
        message.contains('500') ||
        message.contains('internal');
  }
}

/// Builder function type for creating refresh widgets
typedef RefreshWidgetBuilder<T> = Widget Function(T data, WidgetRef ref);

/// Extension methods for BuildContext to access common values
extension JetContextExtensions on BuildContext {
  /// Gets the current theme
  ThemeData get theme => Theme.of(this);

  /// Gets the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Gets the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Gets the screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Gets the screen width
  double get screenWidth => screenSize.width;

  /// Gets the screen height
  double get screenHeight => screenSize.height;

  /// Whether the screen is considered small (width < 600)
  bool get isSmallScreen => screenWidth < 600;

  /// Whether the screen is considered medium (600 <= width < 900)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 900;

  /// Whether the screen is considered large (width >= 900)
  bool get isLargeScreen => screenWidth >= 900;

  /// Gets the safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Gets the keyboard height
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;

  /// Whether the keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;
}
