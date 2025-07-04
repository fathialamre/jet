import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/state/jet_async_refreshable_widget.dart';

/// Convenience functions for common state management patterns
///
/// This file provides shortcuts and utilities to make state management
/// with Jet even more convenient for common use cases.
class JetStateHelpers {
  JetStateHelpers._();

  /// Creates a simple refreshable list widget for AutoDisposeFutureProvider
  ///
  /// This is a convenience method for the most common use case of displaying
  /// a list of items with pull-to-refresh functionality.
  ///
  /// Example:
  /// ```dart
  /// JetStateHelpers.refreshableList<Post>(
  ///   provider: postsProvider,
  ///   itemBuilder: (post, index) => PostCard(post: post),
  /// )
  /// ```
  static Widget refreshableList<T>({
    required AutoDisposeFutureProvider<List<T>> provider,
    required Widget Function(T item, int index) itemBuilder,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    VoidCallback? onRetry,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<T>>(
      provider: provider,
      loadingBuilder: loading,
      errorBuilder: error,
      onRetry: onRetry,
      builder: (items, ref) {
        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  /// Creates a simple refreshable list widget for AutoDisposeFutureProvider.family
  ///
  /// This is a convenience method for displaying a list of items with parameters
  /// and pull-to-refresh functionality.
  ///
  /// Example:
  /// ```dart
  /// JetStateHelpers.refreshableListFamily<Post, String>(
  ///   provider: postsByCategoryProvider,
  ///   param: 'technology',
  ///   itemBuilder: (post, index) => PostCard(post: post),
  /// )
  /// ```
  static Widget refreshableListFamily<T, Param>({
    required AutoDisposeFutureProvider<List<T>> Function(Param) provider,
    required Param param,
    required Widget Function(T item, int index) itemBuilder,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    VoidCallback? onRetry,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<
      List<T>,
      Param
    >(
      provider: provider,
      param: param,
      loading: loading,
      error: error,
      onRetry: onRetry,
      builder: (items, ref) {
        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  /// Creates a simple refreshable grid widget for AutoDisposeFutureProvider
  ///
  /// This is a convenience method for displaying a grid of items with
  /// pull-to-refresh functionality.
  ///
  /// Example:
  /// ```dart
  /// JetStateHelpers.refreshableGrid<Product>(
  ///   provider: productsProvider,
  ///   crossAxisCount: 2,
  ///   itemBuilder: (product, index) => ProductCard(product: product),
  /// )
  /// ```
  static Widget refreshableGrid<T>({
    required AutoDisposeFutureProvider<List<T>> provider,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
    double childAspectRatio = 1.0,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    VoidCallback? onRetry,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProvider<List<T>>(
      provider: provider,
      loadingBuilder: loading,
      errorBuilder: error,
      onRetry: onRetry,
      builder: (items, ref) {
        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  /// Creates a simple refreshable single item widget for AutoDisposeFutureProvider
  ///
  /// This is a convenience method for displaying a single item with
  /// pull-to-refresh functionality. The content is automatically wrapped in
  /// a scrollable container to enable pull-to-refresh gestures.
  ///
  /// Example:
  /// ```dart
  /// JetStateHelpers.refreshableItem<User>(
  ///   provider: userProvider,
  ///   itemBuilder: (user, ref) => UserProfile(user: user),
  /// )
  /// ```
  static Widget refreshableItem<T>({
    required AutoDisposeFutureProvider<T> provider,
    required Widget Function(T item, WidgetRef ref) itemBuilder,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    VoidCallback? onRetry,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProvider<T>(
      provider: provider,
      loadingBuilder: loading,
      errorBuilder: error,
      onRetry: onRetry,
      builder: (item, ref) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          child: itemBuilder(item, ref),
        );
      },
    );
  }

  /// Creates a simple refreshable single item widget for AutoDisposeFutureProvider.family
  ///
  /// This is a convenience method for displaying a single item with parameters
  /// and pull-to-refresh functionality. The content is automatically wrapped in
  /// a scrollable container to enable pull-to-refresh gestures.
  ///
  /// Example:
  /// ```dart
  /// JetStateHelpers.refreshableItemFamily<User, String>(
  ///   provider: userByIdProvider,
  ///   param: 'user123',
  ///   itemBuilder: (user, ref) => UserProfile(user: user),
  /// )
  /// ```
  static Widget refreshableItemFamily<T, Param>({
    required AutoDisposeFutureProvider<T> Function(Param) provider,
    required Param param,
    required Widget Function(T item, WidgetRef ref) itemBuilder,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    VoidCallback? onRetry,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return JetAsyncRefreshableWidget.autoDisposeFutureProviderFamily<T, Param>(
      provider: provider,
      param: param,
      loading: loading,
      error: error,
      onRetry: onRetry,
      builder: (item, ref) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          child: itemBuilder(item, ref),
        );
      },
    );
  }
}
