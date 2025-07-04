import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/state/extensions/jet_async_refreshable_extensions.dart';
import 'package:jet/resources/state/jet_refreshable_widget.dart';

/// Helper class to create refresh widgets with cleaner syntax
///
/// This class provides static methods for different provider types to create
/// refreshable widgets with proper type safety and performance optimizations.
///
/// **Performance Note**: Different provider types use different refresh strategies:
/// - StateNotifier: Uses invalidate() for immediate refresh
/// - FutureProvider: Uses refresh(provider.future) to maintain loading state
///
/// ## Usage Examples:
///
/// ### For FutureProvider (Recommended):
/// ```dart
/// JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<Post>>(
///   provider: postsProvider,
///   builder: (posts, ref) => ListView(...),
/// )
/// ```
///
/// ### For FutureProvider.family (Recommended):
/// ```dart
/// JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<List<Post>, String>(
///   provider: postsProvider,
///   param: 'category',
///   builder: (posts, ref) => ListView(...),
/// )
/// ```
class JetAsyncRefreshableWidget {
  // Private constructor to prevent instantiation
  JetAsyncRefreshableWidget._();

  // =============================================================================
  // LEGACY METHODS (for StateNotifier providers)
  // =============================================================================

  /// Creates a refresh widget for a regular provider (legacy StateNotifier approach)
  ///
  /// **Deprecated**: Consider using [futureProvider] or [autoDisposeFutureProvider] instead
  static Widget provider<T>({
    required ProviderBase<AsyncValue<T>> provider,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loadingBuilder,
    Widget Function(Object error, StackTrace? stackTrace)? errorBuilder,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(provider),
          onRefresh: onRefresh ?? ref.refreshByInvalidating(provider),
          onRetry: onRetry ?? () => ref.invalidate(provider),
          loading: loadingBuilder,
          error: errorBuilder,
          builder: builder,
        );
      },
    );
  }

  /// Creates a refresh widget for a family provider (legacy StateNotifier approach)
  ///
  /// **Deprecated**: Consider using [futureProviderFamily] or [autoDisposeFutureProviderFamily] instead
  static Widget family<T, Param>({
    required ProviderBase<AsyncValue<T>> Function(Param) provider,
    required Param param,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final familyProvider = provider(param);
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(familyProvider),
          onRefresh:
              onRefresh ?? ref.refreshFamilyByInvalidating(provider, param),
          onRetry: onRetry ?? () => ref.invalidate(familyProvider),
          loading: loading,
          error: error,
          builder: builder,
        );
      },
    );
  }

  /// Creates a refresh widget for StateNotifier providers with custom refresh method
  static Widget notifier<T>({
    required ProviderBase<AsyncValue<T>> provider,
    required Future<void> Function() refreshMethod,
    required RefreshWidgetBuilder<T> builder,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(provider),
          onRefresh: refreshMethod,
          onRetry: onRetry ?? () => ref.invalidate(provider),
          loading: loading,
          error: error,
          builder: builder,
        );
      },
    );
  }

  // =============================================================================
  // RECOMMENDED METHODS (for FutureProvider)
  // =============================================================================

  /// Creates a refresh widget for FutureProvider (recommended approach)
  ///
  /// Uses ref.refresh(provider.future) as per Riverpod documentation
  /// This ensures the refresh indicator stays visible until refresh completes
  static Widget futureProvider<T>({
    required FutureProvider<T> provider,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loadingBuilder,
    Widget Function(Object error, StackTrace? stackTrace)? errorBuilder,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(provider),
          onRefresh: onRefresh ?? ref.refreshFutureProvider(provider),
          onRetry: onRetry ?? () => ref.invalidate(provider),
          loading: loadingBuilder,
          error: errorBuilder,
          builder: builder,
        );
      },
    );
  }

  /// Creates a refresh widget for AutoDisposeFutureProvider (recommended approach)
  ///
  /// Uses ref.refresh(provider.future) as per Riverpod documentation
  /// This ensures the refresh indicator stays visible until refresh completes
  static Widget autoDisposeFutureProvider<T>({
    required AutoDisposeFutureProvider<T> provider,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loadingBuilder,
    Widget Function(Object error, StackTrace? stackTrace)? errorBuilder,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(provider),
          onRefresh:
              onRefresh ?? ref.refreshAutoDisposeFutureProvider(provider),
          onRetry: onRetry ?? () => ref.invalidate(provider),
          loading: loadingBuilder,
          error: errorBuilder,
          builder: builder,
        );
      },
    );
  }

  /// Creates a refresh widget for FutureProvider.family (recommended approach)
  ///
  /// Uses ref.refresh(provider.future) as per Riverpod documentation
  /// This ensures the refresh indicator stays visible until refresh completes
  static Widget futureProviderFamily<T, Param>({
    required FutureProvider<T> Function(Param) provider,
    required Param param,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final familyProvider = provider(param);
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(familyProvider),
          onRefresh:
              onRefresh ?? ref.refreshFutureProviderFamily(provider, param),
          onRetry: onRetry ?? () => ref.invalidate(familyProvider),
          loading: loading,
          error: error,
          builder: builder,
        );
      },
    );
  }

  /// Creates a refresh widget for AutoDisposeFutureProvider.family (recommended approach)
  ///
  /// Uses ref.refresh(provider.future) as per Riverpod documentation
  /// This ensures the refresh indicator stays visible until refresh completes
  static Widget autoDisposeFutureProviderFamily<T, Param>({
    required AutoDisposeFutureProvider<T> Function(Param) provider,
    required Param param,
    required RefreshWidgetBuilder<T> builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final familyProvider = provider(param);
        return JetRefreshableWidget<T>(
          asyncValue: (ref) => ref.watch(familyProvider),
          onRefresh:
              onRefresh ??
              ref.refreshAutoDisposeFutureProviderFamily(provider, param),
          onRetry: onRetry ?? () => ref.invalidate(familyProvider),
          loading: loading,
          error: error,
          builder: builder,
        );
      },
    );
  }
}
