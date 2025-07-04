import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// Information extracted from a paginated API response
///
/// This class represents the essential pagination information that can be
/// extracted from any API response format.
class PaginationInfo<T> {
  /// The list of items for the current page
  final List<T> items;

  /// The key for the next page (can be page number, offset, cursor, etc.)
  /// If null, indicates this is the last page
  final dynamic nextPageKey;

  /// Whether this is the last page (optional, can be inferred from nextPageKey)
  final bool? isLastPage;

  /// Total number of items (optional, not all APIs provide this)
  final int? totalItems;

  const PaginationInfo({
    required this.items,
    this.nextPageKey,
    this.isLastPage,
    this.totalItems,
  });

  /// Whether this is the last page (computed property)
  bool get isLast => isLastPage ?? (nextPageKey == null);
}

/// Generic pagination helpers for infinite scroll functionality
///
/// This class provides completely generic methods for creating infinite scroll
/// lists and grids that can work with ANY API pagination format. You just need
/// to provide a response parser that extracts the pagination information.
///
/// **Key Features:**
/// - Works with ANY API response format
/// - Support for offset-based, page-based, cursor-based, and custom pagination
/// - Automatic error handling and retry functionality
/// - Pull-to-refresh integration
/// - Customizable loading and error indicators
/// - Search and filtering support
/// - Grid and list layouts
///
/// **Examples:**
///
/// **DummyJSON API (offset-based):**
/// ```dart
/// JetPaginationHelpers.infiniteList<Product, Map<String, dynamic>>(
///   fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
///   responseParser: (response, pageKey) => PaginationInfo(
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
/// **Cursor-based API:**
/// ```dart
/// JetPaginationHelpers.infiniteList<Post, ApiResponse>(
///   fetchPage: (cursor) => api.getPosts(cursor: cursor, limit: 20),
///   responseParser: (response, currentCursor) => PaginationInfo(
///     items: response.data.map((json) => Post.fromJson(json)).toList(),
///     nextPageKey: response.pagination?.nextCursor,
///     isLastPage: !response.pagination?.hasMore,
///   ),
///   itemBuilder: (post, index) => PostCard(post: post),
/// )
/// ```
///
/// **Page-based API:**
/// ```dart
/// JetPaginationHelpers.infiniteList<User, PagedResponse>(
///   fetchPage: (page) => api.getUsers(page: page, size: 15),
///   responseParser: (response, currentPage) => PaginationInfo(
///     items: response.content.map((json) => User.fromJson(json)).toList(),
///     nextPageKey: response.hasNext ? (currentPage as int) + 1 : null,
///     totalItems: response.totalElements,
///   ),
///   itemBuilder: (user, index) => UserCard(user: user),
/// )
/// ```
class JetPaginationHelpers {
  JetPaginationHelpers._();

  /// Creates an infinite scroll list widget that works with any API format
  ///
  /// This method provides a complete infinite scroll solution with automatic
  /// pagination, error handling, and pull-to-refresh functionality.
  ///
  /// **Type Parameters:**
  /// - [T]: The type of items in the list
  /// - [TResponse]: The type of the API response
  ///
  /// **Parameters:**
  /// - [fetchPage]: Function that fetches a page of data from your API
  /// - [responseParser]: Function that extracts pagination info from the response
  /// - [itemBuilder]: Function to build each item widget
  /// - [firstPageKey]: Initial page key (can be 0, 1, null, cursor string, etc.)
  /// - [enablePullToRefresh]: Whether to enable pull-to-refresh (default: true)
  static Widget infiniteList<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginationInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    responseParser,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return _InfiniteScrollWidget<T, TResponse>(
      fetchPage: fetchPage,
      responseParser: responseParser,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      onRetry: onRetry,
      onRefresh: onRefresh,
      builder: (context, state, fetchNextPage) {
        return PagedListView<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (context, item, index) => itemBuilder(item, index),
            firstPageProgressIndicatorBuilder:
                firstPageProgressIndicator != null
                ? (_) => firstPageProgressIndicator
                : null,
            newPageProgressIndicatorBuilder: newPageProgressIndicator != null
                ? (_) => newPageProgressIndicator
                : null,
            firstPageErrorIndicatorBuilder: firstPageErrorIndicator != null
                ? (_) => firstPageErrorIndicator
                : null,
            newPageErrorIndicatorBuilder: newPageErrorIndicator != null
                ? (_) => newPageErrorIndicator
                : null,
            noItemsFoundIndicatorBuilder: noItemsFoundIndicator != null
                ? (_) => noItemsFoundIndicator
                : null,
            noMoreItemsIndicatorBuilder: noMoreItemsIndicator != null
                ? (_) => noMoreItemsIndicator
                : null,
            invisibleItemsThreshold: invisibleItemsThreshold,
            animateTransitions: true,
          ),
        );
      },
    );
  }

  /// Creates an infinite scroll grid widget that works with any API format
  ///
  /// Similar to [infiniteList] but renders items in a grid layout.
  static Widget infiniteGrid<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginationInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    responseParser,
    required Widget Function(T item, int index) itemBuilder,
    dynamic firstPageKey = 0,
    bool enablePullToRefresh = true,

    // Grid-specific options
    required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return _InfiniteScrollWidget<T, TResponse>(
      fetchPage: fetchPage,
      responseParser: responseParser,
      firstPageKey: firstPageKey,
      enablePullToRefresh: enablePullToRefresh,
      onRetry: onRetry,
      onRefresh: onRefresh,
      builder: (context, state, fetchNextPage) {
        return PagedGridView<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          showNewPageProgressIndicatorAsGridChild:
              showNewPageProgressIndicatorAsGridChild,
          showNewPageErrorIndicatorAsGridChild:
              showNewPageErrorIndicatorAsGridChild,
          showNoMoreItemsIndicatorAsGridChild:
              showNoMoreItemsIndicatorAsGridChild,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (context, item, index) => itemBuilder(item, index),
            firstPageProgressIndicatorBuilder:
                firstPageProgressIndicator != null
                ? (_) => firstPageProgressIndicator
                : null,
            newPageProgressIndicatorBuilder: newPageProgressIndicator != null
                ? (_) => newPageProgressIndicator
                : null,
            firstPageErrorIndicatorBuilder: firstPageErrorIndicator != null
                ? (_) => firstPageErrorIndicator
                : null,
            newPageErrorIndicatorBuilder: newPageErrorIndicator != null
                ? (_) => newPageErrorIndicator
                : null,
            noItemsFoundIndicatorBuilder: noItemsFoundIndicator != null
                ? (_) => noItemsFoundIndicator
                : null,
            noMoreItemsIndicatorBuilder: noMoreItemsIndicator != null
                ? (_) => noMoreItemsIndicator
                : null,
            invisibleItemsThreshold: invisibleItemsThreshold,
            animateTransitions: true,
          ),
        );
      },
    );
  }

  /// Creates an infinite scroll sliver list for use in CustomScrollView
  ///
  /// This is useful when you need to combine the infinite scroll list
  /// with other slivers like headers, search bars, or other content.
  static Widget infiniteSliverList<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginationInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    responseParser,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return _InfiniteScrollWidget<T, TResponse>(
      fetchPage: fetchPage,
      responseParser: responseParser,
      firstPageKey: firstPageKey,
      enablePullToRefresh: false, // Slivers handle refresh differently
      onRetry: onRetry,
      builder: (context, state, fetchNextPage) {
        return PagedSliverList<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (context, item, index) => itemBuilder(item, index),
            firstPageProgressIndicatorBuilder:
                firstPageProgressIndicator != null
                ? (_) => firstPageProgressIndicator
                : null,
            newPageProgressIndicatorBuilder: newPageProgressIndicator != null
                ? (_) => newPageProgressIndicator
                : null,
            firstPageErrorIndicatorBuilder: firstPageErrorIndicator != null
                ? (_) => firstPageErrorIndicator
                : null,
            newPageErrorIndicatorBuilder: newPageErrorIndicator != null
                ? (_) => newPageErrorIndicator
                : null,
            noItemsFoundIndicatorBuilder: noItemsFoundIndicator != null
                ? (_) => noItemsFoundIndicator
                : null,
            noMoreItemsIndicatorBuilder: noMoreItemsIndicator != null
                ? (_) => noMoreItemsIndicator
                : null,
            invisibleItemsThreshold: invisibleItemsThreshold,
            animateTransitions: true,
          ),
        );
      },
    );
  }

  /// Creates an infinite scroll sliver grid for use in CustomScrollView
  ///
  /// Similar to [infiniteSliverList] but for grid layouts.
  static Widget infiniteSliverGrid<T, TResponse>({
    required Future<TResponse> Function(dynamic pageKey) fetchPage,
    required PaginationInfo<T> Function(
      TResponse response,
      dynamic currentPageKey,
    )
    responseParser,
    required Widget Function(T item, int index) itemBuilder,
    dynamic firstPageKey = 0,

    // Grid-specific options
    required int crossAxisCount,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
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
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  }) {
    return _InfiniteScrollWidget<T, TResponse>(
      fetchPage: fetchPage,
      responseParser: responseParser,
      firstPageKey: firstPageKey,
      enablePullToRefresh: false, // Slivers handle refresh differently
      onRetry: onRetry,
      builder: (context, state, fetchNextPage) {
        return PagedSliverGrid<dynamic, T>(
          state: state,
          fetchNextPage: fetchNextPage,
          showNewPageProgressIndicatorAsGridChild:
              showNewPageProgressIndicatorAsGridChild,
          showNewPageErrorIndicatorAsGridChild:
              showNewPageErrorIndicatorAsGridChild,
          showNoMoreItemsIndicatorAsGridChild:
              showNoMoreItemsIndicatorAsGridChild,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          builderDelegate: PagedChildBuilderDelegate<T>(
            itemBuilder: (context, item, index) => itemBuilder(item, index),
            firstPageProgressIndicatorBuilder:
                firstPageProgressIndicator != null
                ? (_) => firstPageProgressIndicator
                : null,
            newPageProgressIndicatorBuilder: newPageProgressIndicator != null
                ? (_) => newPageProgressIndicator
                : null,
            firstPageErrorIndicatorBuilder: firstPageErrorIndicator != null
                ? (_) => firstPageErrorIndicator
                : null,
            newPageErrorIndicatorBuilder: newPageErrorIndicator != null
                ? (_) => newPageErrorIndicator
                : null,
            noItemsFoundIndicatorBuilder: noItemsFoundIndicator != null
                ? (_) => noItemsFoundIndicator
                : null,
            noMoreItemsIndicatorBuilder: noMoreItemsIndicator != null
                ? (_) => noMoreItemsIndicator
                : null,
            invisibleItemsThreshold: invisibleItemsThreshold,
            animateTransitions: true,
          ),
        );
      },
    );
  }
}

/// Convenience methods for common API formats
///
/// These methods provide shortcuts for common pagination patterns,
/// but you can always use the main methods with custom response parsers
/// for maximum flexibility.
extension JetPaginationHelpersConvenience on JetPaginationHelpers {
  /// Creates an infinite scroll list for DummyJSON-style APIs
  ///
  /// This is a convenience method for APIs that return responses like:
  /// ```json
  /// {
  ///   "products": [...],
  ///   "total": 194,
  ///   "skip": 10,
  ///   "limit": 10
  /// }
  /// ```
  static Widget infiniteListForDummyJson<T>({
    required Future<Map<String, dynamic>> Function(int skip, int limit)
    fetchPage,
    required T Function(Map<String, dynamic>) itemFromJson,
    required Widget Function(T item, int index) itemBuilder,
    required String dataKey,
    int limit = 20,
    bool enablePullToRefresh = true,
    // ... other parameters can be added as needed
  }) {
    return JetPaginationHelpers.infiniteList<T, Map<String, dynamic>>(
      fetchPage: (pageKey) => fetchPage(pageKey as int, limit),
      responseParser: (response, currentPageKey) {
        final items = (response[dataKey] as List<dynamic>)
            .map((json) => itemFromJson(json as Map<String, dynamic>))
            .toList();
        final total = response['total'] as int;
        final skip = response['skip'] as int;
        final responseLimit = response['limit'] as int;

        return PaginationInfo(
          items: items,
          nextPageKey: skip + responseLimit < total
              ? skip + responseLimit
              : null,
          totalItems: total,
        );
      },
      itemBuilder: itemBuilder,
      firstPageKey: 0,
      enablePullToRefresh: enablePullToRefresh,
    );
  }

  /// Creates an infinite scroll list for page-based APIs
  ///
  /// This is a convenience method for APIs that use page numbers.
  static Widget infiniteListForPageBased<T>({
    required Future<Map<String, dynamic>> Function(int page, int size)
    fetchPage,
    required T Function(Map<String, dynamic>) itemFromJson,
    required Widget Function(T item, int index) itemBuilder,
    String dataKey = 'content',
    String currentPageKey = 'number',
    String totalPagesKey = 'totalPages',
    String isLastPageKey = 'last',
    int size = 20,
    bool enablePullToRefresh = true,
    // ... other parameters can be added as needed
  }) {
    return JetPaginationHelpers.infiniteList<T, Map<String, dynamic>>(
      fetchPage: (pageKey) => fetchPage(pageKey as int, size),
      responseParser: (response, currentPageKey) {
        final items = (response[dataKey] as List<dynamic>)
            .map((json) => itemFromJson(json as Map<String, dynamic>))
            .toList();
        final currentPage = response[currentPageKey] as int;
        final totalPages = response[totalPagesKey] as int;
        final isLast =
            response[isLastPageKey] as bool? ?? (currentPage >= totalPages - 1);

        return PaginationInfo(
          items: items,
          nextPageKey: !isLast ? currentPage + 1 : null,
          isLastPage: isLast,
        );
      },
      itemBuilder: itemBuilder,
      firstPageKey: 0,
      enablePullToRefresh: enablePullToRefresh,
    );
  }
}

/// Internal widget that manages the PagingController lifecycle
///
/// This widget handles the setup, lifecycle, and state management
/// of the PagingController, including error handling and refresh functionality.
class _InfiniteScrollWidget<T, TResponse> extends ConsumerStatefulWidget {
  final Future<TResponse> Function(dynamic pageKey) fetchPage;
  final PaginationInfo<T> Function(TResponse response, dynamic currentPageKey)
  responseParser;
  final dynamic firstPageKey;
  final bool enablePullToRefresh;
  final VoidCallback? onRetry;
  final VoidCallback? onRefresh;
  final Widget Function(
    BuildContext context,
    PagingState<dynamic, T> state,
    VoidCallback fetchNextPage,
  )
  builder;

  const _InfiniteScrollWidget({
    required this.fetchPage,
    required this.responseParser,
    required this.firstPageKey,
    required this.enablePullToRefresh,
    required this.builder,
    this.onRetry,
    this.onRefresh,
  });

  @override
  ConsumerState<_InfiniteScrollWidget<T, TResponse>> createState() =>
      _InfiniteScrollWidgetState<T, TResponse>();
}

class _InfiniteScrollWidgetState<T, TResponse>
    extends ConsumerState<_InfiniteScrollWidget<T, TResponse>> {
  late final PagingController<dynamic, T> _pagingController;
  final Map<dynamic, dynamic> _pageKeyToNextKey = {};

  @override
  void initState() {
    super.initState();
    print(
      'Initializing PagingController with firstPageKey: ${widget.firstPageKey}',
    );
    _pagingController = PagingController<dynamic, T>(
      getNextPageKey: (state) {
        print('getNextPageKey called with state: $state');
        // Return null if there's an error
        if (state.error != null) {
          print('Error detected, returning null');
          return null;
        }

        // If this is the very first call (no pages loaded yet), return firstPageKey
        if (state.keys == null || state.keys!.isEmpty) {
          print(
            'First page load, returning firstPageKey: ${widget.firstPageKey}',
          );
          return widget.firstPageKey;
        }

        // Get the last page key that was successfully loaded
        final lastKey = state.keys!.last;
        print('Last key: $lastKey');

        // Return the stored next key for this page
        final nextKey = _pageKeyToNextKey[lastKey];
        print('Next key: $nextKey');
        return nextKey;
      },
      fetchPage: _fetchPage,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  /// Fetches a page of data and updates the PagingController
  Future<List<T>> _fetchPage(dynamic pageKey) async {
    print('_fetchPage called with pageKey: $pageKey');
    try {
      print('Calling widget.fetchPage with pageKey: $pageKey');
      final response = await widget.fetchPage(pageKey);
      print('Got response from fetchPage');
      final paginationInfo = widget.responseParser(response, pageKey);
      print(
        'Parsed pagination info: ${paginationInfo.items.length} items, nextPageKey: ${paginationInfo.nextPageKey}',
      );

      // Store the next page key for this current page key
      _pageKeyToNextKey[pageKey] = paginationInfo.nextPageKey;

      return paginationInfo.items;
    } catch (error) {
      print('Error in _fetchPage: $error');
      rethrow; // Let the PagingController handle the error
    }
  }

  /// Handles refresh functionality
  Future<void> _handleRefresh() async {
    if (widget.onRefresh != null) {
      widget.onRefresh!();
    }
    // Clear the page key mapping on refresh
    _pageKeyToNextKey.clear();
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener<dynamic, T>(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        final content = widget.builder(context, state, fetchNextPage);

        if (widget.enablePullToRefresh) {
          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: content,
          );
        }

        return content;
      },
    );
  }
}
