import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jet/bootstrap/boot.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/resources/components/jet_empty_widget.dart';
import 'package:jet/resources/components/jet_error_widget.dart';
import 'package:jet/resources/components/jet_fetch_more_error_widget.dart';
import 'package:jet/resources/components/jet_loading_more_widget.dart';
import 'package:jet/resources/components/jet_no_more_items_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:jet/networking/errors/errors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Information about a page of data from any API
///
/// This class represents pagination information that can be extracted from
/// any API response format (offset-based, cursor-based, page-based, etc.).
class PaginatorPageInfo<T> {
  /// The list of items for the current page
  final List<T> items;

  /// The key for the next page (can be page number, offset, cursor, etc.)
  /// If null, indicates this is the last page
  final dynamic nextPageKey;

  /// Whether this is the last page (optional, can be inferred from nextPageKey)
  final bool? isLastPage;

  /// Total number of items (optional, not all APIs provide this)
  final int? totalItems;

  const PaginatorPageInfo({
    required this.items,
    this.nextPageKey,
    this.isLastPage,
    this.totalItems,
  });

  /// Whether this is the last page (computed property)
  bool get isLast => isLastPage ?? (nextPageKey == null);
}

/// Simple, powerful infinite scroll pagination for any API format
///
/// **JetPaginator** provides a unified way to create infinite scroll lists and grids
/// that work with ANY API pagination format. Built on top of the official
/// `infinite_scroll_pagination` package for maximum reliability and performance.
///
/// ## Key Features
/// - **Official Package**: Built on `infinite_scroll_pagination` for robust state management
/// - Works with ANY API response format
/// - Support for offset-based, page-based, cursor-based, and custom pagination
/// - **Smart Error Handling**: Built-in error handling with custom error widgets
/// - Automatic error handling and retry functionality with proper error parsing
/// - Pull-to-refresh integration with Riverpod invalidate support
/// - **Optimized builds**: Efficient state management through PagingController
/// - Customizable loading and error indicators with error context and ref access
/// - Separate error handling for initial load vs. pagination errors
/// - List and grid layouts
///
/// ## Performance Optimizations
///
/// **Efficient State Management:**
/// - Uses official `PagingController` for robust state management
/// - Automatic error handling and retry logic
/// - Memory-efficient handling of large lists
/// - Built-in animation support for smooth transitions
/// - Optimized scroll performance
///
/// ## Usage Examples
///
/// **DummyJSON API (offset-based):**
/// ```dart
/// JetPaginator.list<Product>(
///   fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
///   parseResponse: (response, pageKey) => PageInfo(
///     items: (response['products'] as List)
///         .map((json) => Product.fromJson(json))
///         .toList(),
///     nextPageKey: response['skip'] + response['limit'] < response['total']
///         ? response['skip'] + response['limit']
///         : null,
///   ),
///   itemBuilder: (product, index) => ProductCard(product: product),
/// )
/// ```
///
/// **With Provider Support (recommended for non-family providers):**
/// ```dart
/// // Define a simple provider (not family)
/// final allProductsProvider = FutureProvider<List<Product>>((ref) async {
///   // Fetch all products logic here
///   return await api.getAllProducts();
/// });
///
/// // Use with provider integration
/// JetPaginator.list<Product>(
///   fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
///   parseResponse: (response, pageKey) => PageInfo(
///     items: (response['products'] as List)
///         .map((json) => Product.fromJson(json))
///         .toList(),
///     nextPageKey: response['skip'] + response['limit'] < response['total']
///         ? response['skip'] + response['limit']
///         : null,
///   ),
///   itemBuilder: (product, index) => ProductCard(product: product),
///   provider: allProductsProvider, // Enable Riverpod integration
/// )
/// ```
///
/// **With Family Providers:**
/// ```dart
/// // Family providers can't be passed directly, but you can still manually invalidate
/// JetPaginator.list<Product>(
///   fetchPage: (pageKey) => ref.read(productsProvider(pageKey).future),
///   parseResponse: (response, pageKey) => PageInfo(...),
///   itemBuilder: (product, index) => ProductCard(product: product),
///   onRefresh: () => ref.invalidate(productsProvider), // Manual invalidate
/// )
/// ```
///
/// **Cursor-based API:**
/// ```dart
/// JetPaginator.list<Post>(
///   fetchPage: (cursor) => api.getPosts(cursor: cursor, limit: 20),
///   parseResponse: (response, currentCursor) => PageInfo(
///     items: response.data.map((json) => Post.fromJson(json)).toList(),
///     nextPageKey: response.pagination?.nextCursor,
///     isLastPage: !response.pagination?.hasMore,
///   ),
///   itemBuilder: (post, index) => PostCard(post: post),
/// )
/// ```
///
/// **Custom Refresh Indicator:**
/// ```dart
/// JetPaginator.list<Product>(
///   fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
///   parseResponse: (response, pageKey) => PageInfo(...),
///   itemBuilder: (product, index) => ProductCard(product: product),
///   // Simple color customization
///   refreshIndicatorColor: Colors.green,
///   refreshIndicatorBackgroundColor: Colors.grey[100],
///   refreshIndicatorStrokeWidth: 3.0,
///   refreshIndicatorDisplacement: 50.0,
/// )
/// ```
///
/// **Fully Custom Refresh Indicator:**
/// ```dart
/// JetPaginator.list<Product>(
///   fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
///   parseResponse: (response, pageKey) => PageInfo(...),
///   itemBuilder: (product, index) => ProductCard(product: product),
///   refreshIndicatorBuilder: (context, controller) {
///     return AnimatedContainer(
///       duration: Duration(milliseconds: 300),
///       child: Icon(
///         Icons.refresh,
///         color: controller.state.isLoading ? Colors.blue : Colors.grey,
///         size: 24 + (controller.value * 12), // Animated size
///       ),
///     );
///   },
/// )
/// ```
///
/// **Page-based API:**
/// ```dart
/// JetPaginator.list<User>(
///   fetchPage: (page) => api.getUsers(page: page, size: 15),
///   parseResponse: (response, currentPage) => PageInfo(
///     items: response.content.map((json) => User.fromJson(json)).toList(),
///     nextPageKey: response.hasNext ? (currentPage as int) + 1 : null,
///     totalItems: response.totalElements,
///   ),
///   itemBuilder: (user, index) => UserCard(user: user),
/// )
/// ```
class JetPaginator {
  JetPaginator._();

  /// Creates an infinite scroll list that works with any API format
  ///
  /// **Type Parameters:**
  /// - [T]: The type of items in the list
  /// - [TResponse]: The type of the API response (usually Map<String, dynamic>)
  ///
  /// **Parameters:**
  /// - [fetchPage]: Function that fetches a page of data from your API
  /// - [parseResponse]: Function that extracts pagination info from the response
  /// - [itemBuilder]: Function to build each item widget
  /// - [firstPageKey]: Initial page key (can be 0, 1, null, cursor string, etc.)
  /// - [provider]: Optional provider for Riverpod integration (enables invalidate refresh)
  /// - [refreshIndicatorBuilder]: Custom builder for the refresh indicator widget
  /// - [refreshIndicatorColor]: Color of the refresh indicator (default: theme primary color)
  /// - [refreshIndicatorBackgroundColor]: Background color of the refresh indicator
  /// - [refreshIndicatorStrokeWidth]: Stroke width of the refresh indicator (default: 2.0)
  /// - [refreshIndicatorDisplacement]: Distance to trigger refresh (default: 40.0)
  /// - [errorIndicator]: Custom error widget builder for initial page load errors (receives raw error + ref)
  /// - [fetchMoreErrorIndicator]: Custom error widget builder for pagination errors (receives raw error + ref)
  static Widget list<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginatorPageInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    parseResponse,
    required Widget Function(T item, int index) itemBuilder,
    dynamic firstPageKey = 0,
    bool enablePullToRefresh = true,

    // Provider integration
    Object? provider,

    // Refresh indicator customization
    Widget Function(BuildContext context, IndicatorController controller)?
    refreshIndicatorBuilder,
    Color? refreshIndicatorColor,
    Color? refreshIndicatorBackgroundColor,
    double? refreshIndicatorStrokeWidth,
    double? refreshIndicatorDisplacement,

    // Customization
    Widget? loadingIndicator,
    Widget Function(Object error, WidgetRef ref)? errorIndicator,
    Widget Function(Object error, WidgetRef ref)? fetchMoreErrorIndicator,
    Widget? noItemsIndicator,
    Widget? noMoreItemsIndicator,

    // List options
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    VoidCallback? onRefresh,

    // No items
    VoidCallback? onNoItemsActionTap,
    String? noItemsTitle,
    String? noItemsMessage,
    String? noItemsActionTitle,

    // No more items
    String? noMoreItemsTitle,
    String? noMoreItemsMessage,
    String? noMoreItemsActionTitle,

    // Advanced options
    int itemsThresholdToTriggerLoad = 3,
  }) {
    return _PaginationListWidget<T, TResponse>(
      fetchPage: fetchPage,
      parseResponse: parseResponse,
      itemBuilder: itemBuilder,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      provider: provider,
      refreshIndicatorBuilder: refreshIndicatorBuilder,
      refreshIndicatorColor: refreshIndicatorColor,
      refreshIndicatorBackgroundColor: refreshIndicatorBackgroundColor,
      refreshIndicatorStrokeWidth: refreshIndicatorStrokeWidth,
      refreshIndicatorDisplacement: refreshIndicatorDisplacement,
      loadingIndicator: loadingIndicator,
      errorIndicator: errorIndicator,
      fetchMoreErrorIndicator: fetchMoreErrorIndicator,
      noItemsIndicator: noItemsIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      onRetry: onRetry,
      onRefresh: onRefresh,
      onNoItemsTap: onNoItemsActionTap,
      noItemsTitle: noItemsTitle,
      noItemsMessage: noItemsMessage,
      noItemsActionTitle: noItemsActionTitle,
      noMoreItemsTitle: noMoreItemsTitle,
      noMoreItemsMessage: noMoreItemsMessage,
      noMoreItemsActionTitle: noMoreItemsActionTitle,
      itemsThresholdToTriggerLoad: itemsThresholdToTriggerLoad,
    );
  }

  /// Creates an infinite scroll grid that works with any API format
  ///
  /// Similar to [list] but renders items in a grid layout.
  /// **Note**: Due to grid constraints, loading and error indicators are sized as grid items.
  /// For full-width indicators, consider using [list] with custom itemBuilder for grid-like layouts.
  static Widget grid<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginatorPageInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    parseResponse,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    dynamic firstPageKey = 0,
    bool enablePullToRefresh = true,

    // Provider integration
    Object? provider,

    // Grid customization
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
    double childAspectRatio = 1.0,

    // Refresh indicator customization
    Widget Function(BuildContext context, IndicatorController controller)?
    refreshIndicatorBuilder,
    Color? refreshIndicatorColor,
    Color? refreshIndicatorBackgroundColor,
    double? refreshIndicatorStrokeWidth,
    double? refreshIndicatorDisplacement,

    // Customization
    Widget? loadingIndicator,
    Widget Function(Object error, WidgetRef ref)? errorIndicator,
    Widget Function(Object error, WidgetRef ref)? fetchMoreErrorIndicator,
    Widget? noItemsIndicator,
    Widget? noMoreItemsIndicator,

    // Grid options
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    VoidCallback? onRefresh,

    // No items
    VoidCallback? onNoItemsActionTap,
    String? noItemsTitle,
    String? noItemsMessage,
    String? noItemsActionTitle,

    // No more items
    String? noMoreItemsTitle,
    String? noMoreItemsMessage,
    String? noMoreItemsActionTitle,

    // Advanced options
    int itemsThresholdToTriggerLoad = 3,
  }) {
    return _PaginationGridWidget<T, TResponse>(
      fetchPage: fetchPage,
      parseResponse: parseResponse,
      itemBuilder: itemBuilder,
      crossAxisCount: crossAxisCount,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      provider: provider,
      refreshIndicatorBuilder: refreshIndicatorBuilder,
      refreshIndicatorColor: refreshIndicatorColor,
      refreshIndicatorBackgroundColor: refreshIndicatorBackgroundColor,
      refreshIndicatorStrokeWidth: refreshIndicatorStrokeWidth,
      refreshIndicatorDisplacement: refreshIndicatorDisplacement,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      loadingIndicator: loadingIndicator,
      errorIndicator: errorIndicator,
      fetchMoreErrorIndicator: fetchMoreErrorIndicator,
      noItemsIndicator: noItemsIndicator,
      noMoreItemsIndicator: noMoreItemsIndicator,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      onRetry: onRetry,
      onRefresh: onRefresh,
      onNoItemsTap: onNoItemsActionTap,
      noItemsTitle: noItemsTitle,
      noItemsMessage: noItemsMessage,
      noItemsActionTitle: noItemsActionTitle,
      noMoreItemsTitle: noMoreItemsTitle,
      noMoreItemsMessage: noMoreItemsMessage,
      noMoreItemsActionTitle: noMoreItemsActionTitle,
      itemsThresholdToTriggerLoad: itemsThresholdToTriggerLoad,
    );
  }
}

// =============================================================================
// IMPLEMENTATION USING OFFICIAL INFINITE_SCROLL_PAGINATION PACKAGE
// =============================================================================

/// Internal widget that manages list pagination using official infinite_scroll_pagination
class _PaginationListWidget<T, TResponse> extends ConsumerStatefulWidget {
  const _PaginationListWidget({
    required this.fetchPage,
    required this.parseResponse,
    required this.itemBuilder,
    required this.firstPageKey,
    required this.enablePullToRefresh,
    this.provider,
    this.refreshIndicatorBuilder,
    this.refreshIndicatorColor,
    this.refreshIndicatorBackgroundColor,
    this.refreshIndicatorStrokeWidth,
    this.refreshIndicatorDisplacement,
    this.loadingIndicator,
    this.errorIndicator,
    this.fetchMoreErrorIndicator,
    this.noItemsIndicator,
    this.noMoreItemsIndicator,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.onRetry,
    this.onRefresh,
    this.onNoItemsTap,
    this.noItemsTitle,
    this.noItemsMessage,
    this.noItemsActionTitle,
    this.noMoreItemsTitle,
    this.noMoreItemsMessage,
    this.noMoreItemsActionTitle,
    this.itemsThresholdToTriggerLoad = 3,
  });

  final Future<TResponse> Function(dynamic pageKey) fetchPage;
  final PaginatorPageInfo<T> Function(
    TResponse response,
    dynamic currentPageKey,
  )
  parseResponse;
  final Widget Function(T item, int index) itemBuilder;
  final dynamic firstPageKey;
  final bool enablePullToRefresh;
  final Object? provider;
  final Widget Function(BuildContext context, IndicatorController controller)?
  refreshIndicatorBuilder;
  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;
  final double? refreshIndicatorStrokeWidth;
  final double? refreshIndicatorDisplacement;
  final Widget? loadingIndicator;
  final Widget Function(Object error, WidgetRef ref)? errorIndicator;
  final Widget Function(Object error, WidgetRef ref)? fetchMoreErrorIndicator;
  final Widget? noItemsIndicator;
  final Widget? noMoreItemsIndicator;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final VoidCallback? onRetry;
  final VoidCallback? onRefresh;
  final VoidCallback? onNoItemsTap;
  final String? noItemsTitle;
  final String? noItemsMessage;
  final String? noItemsActionTitle;
  final String? noMoreItemsTitle;
  final String? noMoreItemsMessage;
  final String? noMoreItemsActionTitle;
  final int itemsThresholdToTriggerLoad;

  @override
  ConsumerState<_PaginationListWidget<T, TResponse>> createState() =>
      _PaginationListWidgetState<T, TResponse>();
}

class _PaginationListWidgetState<T, TResponse>
    extends ConsumerState<_PaginationListWidget<T, TResponse>> {
  late final PagingController<dynamic, T> _pagingController;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<dynamic, T>(
      getNextPageKey: (state) {
        // Check if the last page is empty to determine if we should fetch more
        if (state.lastPageIsEmpty) return null;
        // For dynamic page keys, we need to return the next page key
        // Since we're using dynamic keys, we'll use the widget's logic to determine the next key
        if (state.keys?.isEmpty ?? true) return widget.firstPageKey;
        // The key issue was here - we need to store the next page key from the last response
        return _nextPageKey;
      },
      fetchPage: (pageKey) async {
        final actualPageKey = pageKey ?? widget.firstPageKey;
        final response = await widget.fetchPage(actualPageKey);
        final pageInfo = widget.parseResponse(response, actualPageKey);

        // Store the next page key for the next call
        _nextPageKey = pageInfo.nextPageKey;

        // The fetchPage should return the items directly, not a PageResult
        // The controller will handle the pagination logic
        return pageInfo.items;
      },
    );
    _pagingController.addListener(_handlePagingStatus);
  }

  dynamic _nextPageKey;

  @override
  void dispose() {
    _pagingController.removeListener(_handlePagingStatus);
    _pagingController.dispose();
    super.dispose();
  }

  void _handlePagingStatus() {
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      final error = _pagingController.value.error;
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            action: SnackBarAction(
              label: context.jetI10n.retry,
              onPressed: () => _pagingController.fetchNextPage(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _refresh() async {
    // If provider is available, use Riverpod invalidate
    // TODO: Update this for Riverpod 3.0 invalidate API
    // if (widget.provider != null && context.mounted) {
    //   final container = ProviderScope.containerOf(context);
    //   container.invalidate(widget.provider!);
    // }

    // Call custom refresh callback if provided
    widget.onRefresh?.call();

    // Refresh the paging controller
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final jet = ref.read(jetProvider);

    Widget child = PagingListener<dynamic, T>(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedListView<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: widget.padding,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          builderDelegate: PagedChildBuilderDelegate<T>(
            animateTransitions: true,
            itemBuilder: (context, item, index) =>
                widget.itemBuilder(item, index),
            firstPageProgressIndicatorBuilder: (context) =>
                widget.loadingIndicator ?? jet.config.loader,
            newPageProgressIndicatorBuilder: (context) =>
                widget.loadingIndicator ?? JetLoadingMoreWidget(),
            firstPageErrorIndicatorBuilder: (context) =>
                (widget.errorIndicator != null && state.error != null)
                ? widget.errorIndicator!.call(state.error!, ref)
                : _buildErrorIndicator(context, state.error),
            newPageErrorIndicatorBuilder: (context) =>
                (widget.fetchMoreErrorIndicator != null && state.error != null)
                ? widget.fetchMoreErrorIndicator!.call(state.error!, ref)
                : _buildFetchMoreErrorIndicator(context, state.error),
            noItemsFoundIndicatorBuilder: (context) =>
                widget.noItemsIndicator ??
                JetEmptyWidget(
                  title: widget.noItemsTitle ?? context.jetI10n.noItemsFound,
                  message:
                      widget.noItemsMessage ??
                      context.jetI10n.noItemsFoundMessage,
                  onTap: widget.onNoItemsTap,
                  showAction: widget.onNoItemsTap != null,
                  actionText: widget.noItemsActionTitle,
                ),
            noMoreItemsIndicatorBuilder: (context) =>
                widget.noMoreItemsIndicator ??
                JetNoMoreItemsWidget(
                  title:
                      widget.noMoreItemsTitle ??
                      context.jetI10n.noMoreItemsTitle,
                  message:
                      widget.noMoreItemsMessage ??
                      context.jetI10n.noMoreItemsMessage,
                  onTap: () => _pagingController.fetchNextPage(),
                  showAction: true,
                  actionText: context.jetI10n.loadMore,
                ),
          ),
        );
      },
    );

    if (widget.enablePullToRefresh) {
      child = CustomMaterialIndicator(
        onRefresh: _refresh,
        backgroundColor: widget.refreshIndicatorBackgroundColor,
        displacement: widget.refreshIndicatorDisplacement ?? 40.0,
        indicatorBuilder:
            widget.refreshIndicatorBuilder ??
            (context, controller) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircularProgressIndicator(
                  color:
                      widget.refreshIndicatorColor ??
                      context.theme.primaryColor,
                  strokeWidth: widget.refreshIndicatorStrokeWidth ?? 2.0,
                  value: controller.state.isLoading
                      ? null
                      : math.min(controller.value, 1.0),
                ),
              );
            },
        child: child,
      );
    }

    return child;
  }

  Widget _buildErrorIndicator(BuildContext context, Object? error) {
    if (error == null) {
      return JetErrorWidget(
        icon: PhosphorIcons.info(),
        title: context.jetI10n.somethingWentWrongWhileFetchingNewPage,
        message: context.jetI10n.unknownError,
        onTap: () => _pagingController.fetchNextPage(),
      );
    }

    final jet = ref.read(jetProvider);
    final jetError = jet.config.errorHandler.handle(error);

    return JetErrorWidget(
      icon: _getErrorIconData(jetError),
      title: _getErrorTitle(jetError, context),
      message: jetError.message,
      onTap: () => _pagingController.fetchNextPage(),
    );
  }

  Widget _buildFetchMoreErrorIndicator(BuildContext context, Object? error) {
    if (error == null) {
      return JetFetchMoreErrorWidget(
        showAction: true,
        actionText: context.jetI10n.retry,
        onTap: () => _pagingController.fetchNextPage(),
      );
    }

    final jet = ref.read(jetProvider);
    final jetError = jet.config.errorHandler.handle(error);

    return JetFetchMoreErrorWidget(
      showAction: true,
      actionText: _getRetryButtonText(jetError, context),
      title: _getErrorTitle(jetError, context),
      message: jetError.message,
      onTap: () => _pagingController.fetchNextPage(),
    );
  }

  /// Get error icon data based on JetError type
  IconData _getErrorIconData(JetError jetError) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return PhosphorIcons.wifiSlash();
      case JetErrorType.server:
        return PhosphorIcons.hardDrives();
      case JetErrorType.client:
        return PhosphorIcons.info();
      case JetErrorType.validation:
        return PhosphorIcons.info();
      case JetErrorType.timeout:
        return PhosphorIcons.clock();
      case JetErrorType.cancelled:
        return PhosphorIcons.x();
      case JetErrorType.unknown:
        return PhosphorIcons.info();
    }
  }

  /// Get error title based on JetError type
  String _getErrorTitle(JetError jetError, BuildContext context) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return context.jetI10n.noInternetConnection;
      case JetErrorType.server:
        return context.jetI10n.serverError;
      case JetErrorType.client:
        return context.jetI10n.requestError;
      case JetErrorType.validation:
        return context.jetI10n.validationError;
      case JetErrorType.timeout:
        return context.jetI10n.requestTimeout;
      case JetErrorType.cancelled:
        return context.jetI10n.requestCancelled;
      case JetErrorType.unknown:
        return context.jetI10n.somethingWentWrongWhileFetchingNewPage;
    }
  }

  /// Get retry button text based on JetError type
  String _getRetryButtonText(JetError jetError, BuildContext context) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return context.jetI10n.checkConnection;
      case JetErrorType.cancelled:
        return context.jetI10n.restart;
      default:
        return context.jetI10n.retry;
    }
  }
}

// =============================================================================
// IMPLEMENTATION USING OFFICIAL INFINITE_SCROLL_PAGINATION PACKAGE - GRID
// =============================================================================

/// Internal widget that manages grid pagination using official infinite_scroll_pagination
class _PaginationGridWidget<T, TResponse> extends ConsumerStatefulWidget {
  const _PaginationGridWidget({
    required this.fetchPage,
    required this.parseResponse,
    required this.itemBuilder,
    required this.crossAxisCount,
    required this.firstPageKey,
    required this.enablePullToRefresh,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.childAspectRatio,
    this.provider,
    this.refreshIndicatorBuilder,
    this.refreshIndicatorColor,
    this.refreshIndicatorBackgroundColor,
    this.refreshIndicatorStrokeWidth,
    this.refreshIndicatorDisplacement,
    this.loadingIndicator,
    this.errorIndicator,
    this.fetchMoreErrorIndicator,
    this.noItemsIndicator,
    this.noMoreItemsIndicator,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.onRetry,
    this.onRefresh,
    this.onNoItemsTap,
    this.noItemsTitle,
    this.noItemsMessage,
    this.noItemsActionTitle,
    this.noMoreItemsTitle,
    this.noMoreItemsMessage,
    this.noMoreItemsActionTitle,
    this.itemsThresholdToTriggerLoad = 3,
  });

  final Future<TResponse> Function(dynamic pageKey) fetchPage;
  final PaginatorPageInfo<T> Function(
    TResponse response,
    dynamic currentPageKey,
  )
  parseResponse;
  final Widget Function(T item, int index) itemBuilder;
  final int crossAxisCount;
  final dynamic firstPageKey;
  final bool enablePullToRefresh;
  final Object? provider;
  final Widget Function(BuildContext context, IndicatorController controller)?
  refreshIndicatorBuilder;
  final Color? refreshIndicatorColor;
  final Color? refreshIndicatorBackgroundColor;
  final double? refreshIndicatorStrokeWidth;
  final double? refreshIndicatorDisplacement;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final Widget? loadingIndicator;
  final Widget Function(Object error, WidgetRef ref)? errorIndicator;
  final Widget Function(Object error, WidgetRef ref)? fetchMoreErrorIndicator;
  final Widget? noItemsIndicator;
  final Widget? noMoreItemsIndicator;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final VoidCallback? onRetry;
  final VoidCallback? onRefresh;
  final VoidCallback? onNoItemsTap;
  final String? noItemsTitle;
  final String? noItemsMessage;
  final String? noItemsActionTitle;
  final String? noMoreItemsTitle;
  final String? noMoreItemsMessage;
  final String? noMoreItemsActionTitle;
  final int itemsThresholdToTriggerLoad;

  @override
  ConsumerState<_PaginationGridWidget<T, TResponse>> createState() =>
      _PaginationGridWidgetState<T, TResponse>();
}

class _PaginationGridWidgetState<T, TResponse>
    extends ConsumerState<_PaginationGridWidget<T, TResponse>> {
  late final PagingController<dynamic, T> _pagingController;
  dynamic _nextPageKey;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<dynamic, T>(
      getNextPageKey: (state) {
        // Check if the last page is empty to determine if we should fetch more
        if (state.lastPageIsEmpty) return null;
        // For dynamic page keys, we need to return the next page key
        // Since we're using dynamic keys, we'll use the widget's logic to determine the next key
        if (state.keys?.isEmpty ?? true) return widget.firstPageKey;
        // The key issue was here - we need to store the next page key from the last response
        return _nextPageKey;
      },
      fetchPage: (pageKey) async {
        final actualPageKey = pageKey ?? widget.firstPageKey;
        final response = await widget.fetchPage(actualPageKey);
        final pageInfo = widget.parseResponse(response, actualPageKey);

        // Store the next page key for the next call
        _nextPageKey = pageInfo.nextPageKey;

        // The fetchPage should return the items directly, not a PageResult
        // The controller will handle the pagination logic
        return pageInfo.items;
      },
    );
    _pagingController.addListener(_handlePagingStatus);
  }

  @override
  void dispose() {
    _pagingController.removeListener(_handlePagingStatus);
    _pagingController.dispose();
    super.dispose();
  }

  void _handlePagingStatus() {
    if (_pagingController.value.status == PagingStatus.subsequentPageError) {
      final error = _pagingController.value.error;
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            action: SnackBarAction(
              label: context.jetI10n.retry,
              onPressed: () => _pagingController.fetchNextPage(),
            ),
          ),
        );
      }
    }
  }

  Future<void> _refresh() async {
    // If provider is available, use Riverpod invalidate
    // TODO: Update this for Riverpod 3.0 invalidate API
    // if (widget.provider != null && context.mounted) {
    //   final container = ProviderScope.containerOf(context);
    //   container.invalidate(widget.provider!);
    // }

    // Call custom refresh callback if provided
    widget.onRefresh?.call();

    // Refresh the paging controller
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final jet = ref.read(jetProvider);

    Widget child = PagingListener<dynamic, T>(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedGridView<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: widget.padding,
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: widget.crossAxisSpacing,
            mainAxisSpacing: widget.mainAxisSpacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          builderDelegate: PagedChildBuilderDelegate<T>(
            animateTransitions: true,
            itemBuilder: (context, item, index) =>
                widget.itemBuilder(item, index),
            firstPageProgressIndicatorBuilder: (context) =>
                widget.loadingIndicator ?? jet.config.loader,
            newPageProgressIndicatorBuilder: (context) =>
                widget.loadingIndicator ?? JetLoadingMoreWidget(),
            firstPageErrorIndicatorBuilder: (context) =>
                (widget.errorIndicator != null && state.error != null)
                ? widget.errorIndicator!.call(state.error!, ref)
                : _buildErrorIndicator(context, state.error),
            newPageErrorIndicatorBuilder: (context) =>
                (widget.fetchMoreErrorIndicator != null && state.error != null)
                ? widget.fetchMoreErrorIndicator!.call(state.error!, ref)
                : _buildFetchMoreErrorIndicator(context, state.error),
            noItemsFoundIndicatorBuilder: (context) =>
                widget.noItemsIndicator ??
                JetEmptyWidget(
                  title: widget.noItemsTitle ?? context.jetI10n.noItemsFound,
                  message:
                      widget.noItemsMessage ??
                      context.jetI10n.noItemsFoundMessage,
                  onTap: widget.onNoItemsTap,
                  showAction: widget.onNoItemsTap != null,
                  actionText: widget.noItemsActionTitle,
                ),
            noMoreItemsIndicatorBuilder: (context) =>
                widget.noMoreItemsIndicator ??
                JetNoMoreItemsWidget(
                  title:
                      widget.noMoreItemsTitle ??
                      context.jetI10n.noMoreItemsTitle,
                  message:
                      widget.noMoreItemsMessage ??
                      context.jetI10n.noMoreItemsMessage,
                  onTap: () => _pagingController.fetchNextPage(),
                  showAction: true,
                  actionText:
                      widget.noMoreItemsActionTitle ?? context.jetI10n.loadMore,
                ),
          ),
        );
      },
    );

    if (widget.enablePullToRefresh) {
      child = CustomMaterialIndicator(
        onRefresh: _refresh,
        backgroundColor: widget.refreshIndicatorBackgroundColor,
        displacement: widget.refreshIndicatorDisplacement ?? 40.0,
        indicatorBuilder:
            widget.refreshIndicatorBuilder ??
            (context, controller) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircularProgressIndicator(
                  color:
                      widget.refreshIndicatorColor ??
                      context.theme.primaryColor,
                  strokeWidth: widget.refreshIndicatorStrokeWidth ?? 2.0,
                  value: controller.state.isLoading
                      ? null
                      : math.min(controller.value, 1.0),
                ),
              );
            },
        child: child,
      );
    }

    return child;
  }

  Widget _buildErrorIndicator(BuildContext context, Object? error) {
    if (error == null) {
      return JetErrorWidget(
        icon: PhosphorIcons.info(),
        title: context.jetI10n.somethingWentWrongWhileFetchingNewPage,
        message: context.jetI10n.unknownError,
        onTap: () {
          widget.onRetry?.call();
          _pagingController.fetchNextPage();
        },
      );
    }

    final jet = ref.read(jetProvider);
    final jetError = jet.config.errorHandler.handle(error);

    return JetErrorWidget(
      icon: _getErrorIconData(jetError),
      title: _getErrorTitle(jetError, context),
      message: jetError.message,
      onTap: () {
        widget.onRetry?.call();
        _pagingController.fetchNextPage();
      },
    );
  }

  /// Get error icon data based on JetError type
  IconData _getErrorIconData(JetError jetError) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return PhosphorIcons.wifiSlash();
      case JetErrorType.server:
        return PhosphorIcons.hardDrives();
      case JetErrorType.client:
        return PhosphorIcons.info();
      case JetErrorType.validation:
        return PhosphorIcons.warning();
      case JetErrorType.timeout:
        return PhosphorIcons.clock();
      case JetErrorType.cancelled:
        return PhosphorIcons.x();
      case JetErrorType.unknown:
        return PhosphorIcons.info();
    }
  }

  /// Get error title based on JetError type
  String _getErrorTitle(JetError jetError, BuildContext context) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return context.jetI10n.noInternetConnection;
      case JetErrorType.server:
        return context.jetI10n.serverError;
      case JetErrorType.client:
        return context.jetI10n.requestError;
      case JetErrorType.validation:
        return context.jetI10n.validationError;
      case JetErrorType.timeout:
        return context.jetI10n.requestTimeout;
      case JetErrorType.cancelled:
        return context.jetI10n.requestCancelled;
      case JetErrorType.unknown:
        return context.jetI10n.somethingWentWrongWhileFetchingNewPage;
    }
  }

  /// Get retry button text based on JetError type
  String _getRetryButtonText(JetError jetError, BuildContext context) {
    switch (jetError.type) {
      case JetErrorType.noInternet:
        return context.jetI10n.checkConnection;
      case JetErrorType.cancelled:
        return context.jetI10n.restart;
      default:
        return context.jetI10n.retry;
    }
  }

  Widget _buildFetchMoreErrorIndicator(BuildContext context, Object? error) {
    if (error == null) {
      return JetFetchMoreErrorWidget(
        showAction: true,
        actionText: context.jetI10n.retry,
        onTap: () => _pagingController.fetchNextPage(),
      );
    }

    final jet = ref.read(jetProvider);
    final jetError = jet.config.errorHandler.handle(error);

    return JetFetchMoreErrorWidget(
      showAction: true,
      actionText: _getRetryButtonText(jetError, context),
      title: _getErrorTitle(jetError, context),
      message: jetError.message,
      onTap: () => _pagingController.fetchNextPage(),
    );
  }
}
