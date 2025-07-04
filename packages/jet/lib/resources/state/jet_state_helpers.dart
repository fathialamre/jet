import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/resources/state/jet_async_refreshable_widget.dart';
import 'package:jet/resources/state/jet_pagination_helpers.dart';
import 'package:jet/resources/state/models/pagination_response.dart';

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

  // =============================================================================
  // INFINITE SCROLL PAGINATION METHODS
  // =============================================================================

  /// Creates an infinite scroll list widget with pagination
  ///
  /// This method provides a powerful infinite scroll solution with automatic
  /// pagination, error handling, and pull-to-refresh functionality. It's perfect
  /// for APIs that return paginated data.
  ///
  /// **Supports multiple pagination strategies:**
  /// - Offset-based (skip/limit) - like DummyJSON
  /// - Page-based (page numbers)
  /// - Cursor-based pagination
  ///
  /// **Example:**
  /// ```dart
  /// JetStateHelpers.infiniteList<Product>(
  ///   fetchPage: (pageKey) async {
  ///     final response = await dio.get(
  ///       'https://dummyjson.com/products',
  ///       queryParameters: {
  ///         'skip': pageKey,
  ///         'limit': 20,
  ///       },
  ///     );
  ///     return PaginationResponse.fromDummyJson(
  ///       response.data,
  ///       (json) => Product.fromJson(json),
  ///       'products',
  ///     );
  ///   },
  ///   itemBuilder: (product, index) => ProductCard(product: product),
  /// )
  /// ```
  static Widget infiniteList<T>({
    required Future<PaginationResponse<T>> Function(dynamic pageKey) fetchPage,
    required Widget Function(T item, int index) itemBuilder,
    dynamic firstPageKey = 0,
    bool enablePullToRefresh = true,

    // Customization options
    Widget? firstPageProgressIndicator,
    Widget? newPageProgressIndicator,
    Widget? firstPageErrorIndicator,
    Widget? newPageErrorIndicator,
    Widget? noItemsFoundIndicator,
    Widget? noMoreItemsIndicator,

    // List view options
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    VoidCallback? onRefresh,

    // Advanced options
    int invisibleItemsThreshold = 3,
  }) {
    return JetPaginationHelpers.infiniteList<T, PaginationResponse<T>>(
      fetchPage: fetchPage,
      itemBuilder: itemBuilder,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      firstPageProgressIndicator: firstPageProgressIndicator,
      newPageProgressIndicator: newPageProgressIndicator,
      firstPageErrorIndicator: firstPageErrorIndicator,
      newPageErrorIndicator: newPageErrorIndicator,
      noItemsFoundIndicator: noItemsFoundIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      onRetry: onRetry,
      onRefresh: onRefresh,
      invisibleItemsThreshold: invisibleItemsThreshold,
      responseParser: (PaginationResponse<T> response, dynamic currentPageKey) {
        return PaginationInfo(
          items: response.items,
          nextPageKey: response.nextPageKey,
        );
      },
    );
  }

  /// Creates an infinite scroll grid widget with pagination
  ///
  /// Similar to [infiniteList] but renders items in a grid layout.
  /// Perfect for product catalogs, image galleries, and card-based layouts.
  ///
  /// **Example:**
  /// ```dart
  /// JetStateHelpers.infiniteGrid<Product>(
  ///   fetchPage: (pageKey) async {
  ///     final response = await dio.get(
  ///       'https://dummyjson.com/products',
  ///       queryParameters: {
  ///         'skip': pageKey,
  ///         'limit': 20,
  ///       },
  ///     );
  ///     return PaginationResponse.fromDummyJson(
  ///       response.data,
  ///       (json) => Product.fromJson(json),
  ///       'products',
  ///     );
  ///   },
  ///   itemBuilder: (product, index) => ProductCard(product: product),
  ///   crossAxisCount: 2,
  ///   childAspectRatio: 0.8,
  /// )
  /// ```
  static Widget infiniteGrid<T>({
    required Future<PaginationResponse<T>> Function(dynamic pageKey) fetchPage,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    dynamic firstPageKey = 0,
    bool enablePullToRefresh = true,

    // Grid-specific options
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
    double childAspectRatio = 1.0,

    // Customization options
    Widget? firstPageProgressIndicator,
    Widget? newPageProgressIndicator,
    Widget? firstPageErrorIndicator,
    Widget? newPageErrorIndicator,
    Widget? noItemsFoundIndicator,
    Widget? noMoreItemsIndicator,

    // Grid view options
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Grid indicator positioning
    bool showNewPageProgressIndicatorAsGridChild = true,
    bool showNewPageErrorIndicatorAsGridChild = true,
    bool showNoMoreItemsIndicatorAsGridChild = true,

    // Callbacks
    VoidCallback? onRetry,
    VoidCallback? onRefresh,

    // Advanced options
    int invisibleItemsThreshold = 3,
  }) {
    return JetPaginationHelpers.infiniteGrid<T, PaginationResponse<T>>(
      responseParser: (PaginationResponse<T> response, dynamic currentPageKey) {
        return PaginationInfo(
          items: response.items,
          nextPageKey: response.nextPageKey,
        );
      },
      fetchPage: fetchPage,
      itemBuilder: itemBuilder,
      crossAxisCount: crossAxisCount,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      firstPageProgressIndicator: firstPageProgressIndicator,
      newPageProgressIndicator: newPageProgressIndicator,
      firstPageErrorIndicator: firstPageErrorIndicator,
      newPageErrorIndicator: newPageErrorIndicator,
      noItemsFoundIndicator: noItemsFoundIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      showNewPageProgressIndicatorAsGridChild:
          showNewPageProgressIndicatorAsGridChild,
      showNewPageErrorIndicatorAsGridChild:
          showNewPageErrorIndicatorAsGridChild,
      showNoMoreItemsIndicatorAsGridChild: showNoMoreItemsIndicatorAsGridChild,
      onRetry: onRetry,
      onRefresh: onRefresh,
      invisibleItemsThreshold: invisibleItemsThreshold,
    );
  }

  /// Creates an infinite scroll sliver list for use in CustomScrollView
  ///
  /// This is useful when you need to combine the infinite scroll list
  /// with other slivers like headers, search bars, or filters.
  ///
  /// **Example:**
  /// ```dart
  /// CustomScrollView(
  ///   slivers: [
  ///     SliverAppBar(
  ///       title: Text('Products'),
  ///       floating: true,
  ///       snap: true,
  ///     ),
  ///     SliverToBoxAdapter(
  ///       child: SearchBar(),
  ///     ),
  ///     JetStateHelpers.infiniteSliverList<Product>(
  ///       fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
  ///       itemBuilder: (product, index) => ProductCard(product: product),
  ///     ),
  ///   ],
  /// )
  /// ```
  static Widget infiniteSliverList<T>({
    required Future<PaginationResponse<T>> Function(dynamic pageKey) fetchPage,
    required Widget Function(T item, int index) itemBuilder,
    dynamic firstPageKey = 0,

    // Customization options
    Widget? firstPageProgressIndicator,
    Widget? newPageProgressIndicator,
    Widget? firstPageErrorIndicator,
    Widget? newPageErrorIndicator,
    Widget? noItemsFoundIndicator,
    Widget? noMoreItemsIndicator,

    // Callbacks
    VoidCallback? onRetry,

    // Advanced options
    int invisibleItemsThreshold = 3,
  }) {
    return JetPaginationHelpers.infiniteSliverList<T, PaginationResponse<T>>(
      responseParser: (PaginationResponse<T> response, dynamic currentPageKey) {
        return PaginationInfo(
          items: response.items,
          nextPageKey: response.nextPageKey,
        );
      },
      fetchPage: fetchPage,
      itemBuilder: itemBuilder,
      firstPageKey: firstPageKey,
      firstPageProgressIndicator: firstPageProgressIndicator,
      newPageProgressIndicator: newPageProgressIndicator,
      firstPageErrorIndicator: firstPageErrorIndicator,
      newPageErrorIndicator: newPageErrorIndicator,
      noItemsFoundIndicator: noItemsFoundIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      onRetry: onRetry,
      invisibleItemsThreshold: invisibleItemsThreshold,
    );
  }

  /// Creates an infinite scroll sliver grid for use in CustomScrollView
  ///
  /// Similar to [infiniteSliverList] but for grid layouts.
  /// Perfect for use in complex scrollable layouts with headers and filters.
  static Widget infiniteSliverGrid<T>({
    required Future<PaginationResponse<T>> Function(dynamic pageKey) fetchPage,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    dynamic firstPageKey = 0,

    // Grid-specific options
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
    double childAspectRatio = 1.0,

    // Customization options
    Widget? firstPageProgressIndicator,
    Widget? newPageProgressIndicator,
    Widget? firstPageErrorIndicator,
    Widget? newPageErrorIndicator,
    Widget? noItemsFoundIndicator,
    Widget? noMoreItemsIndicator,

    // Grid indicator positioning
    bool showNewPageProgressIndicatorAsGridChild = true,
    bool showNewPageErrorIndicatorAsGridChild = true,
    bool showNoMoreItemsIndicatorAsGridChild = true,

    // Callbacks
    VoidCallback? onRetry,

    // Advanced options
    int invisibleItemsThreshold = 3,
  }) {
    return JetPaginationHelpers.infiniteSliverGrid<T, PaginationResponse<T>>(
      responseParser: (PaginationResponse<T> response, dynamic currentPageKey) {
        return PaginationInfo(
          items: response.items,
          nextPageKey: response.nextPageKey,
        );
      },
      fetchPage: fetchPage,
      itemBuilder: itemBuilder,
      crossAxisCount: crossAxisCount,
      firstPageKey: firstPageKey,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      firstPageProgressIndicator: firstPageProgressIndicator,
      newPageProgressIndicator: newPageProgressIndicator,
      firstPageErrorIndicator: firstPageErrorIndicator,
      newPageErrorIndicator: newPageErrorIndicator,
      noItemsFoundIndicator: noItemsFoundIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      showNewPageProgressIndicatorAsGridChild:
          showNewPageProgressIndicatorAsGridChild,
      showNewPageErrorIndicatorAsGridChild:
          showNewPageErrorIndicatorAsGridChild,
      showNoMoreItemsIndicatorAsGridChild: showNoMoreItemsIndicatorAsGridChild,
      onRetry: onRetry,
      invisibleItemsThreshold: invisibleItemsThreshold,
    );
  }
}
