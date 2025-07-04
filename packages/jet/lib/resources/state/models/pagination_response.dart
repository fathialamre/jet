/// Common pagination response models for API integration
///
/// This file provides flexible models that work with various pagination
/// strategies and API response formats, including offset-based, cursor-based,
/// and page-based pagination.

/// Generic pagination response wrapper
///
/// This class can adapt to different API response formats by using
/// custom extractors for data, total count, and pagination metadata.
///
/// Example usage:
/// ```dart
/// // For DummyJSON-style APIs
/// final response = PaginationResponse.fromJson(
///   json,
///   dataExtractor: (json) => (json['products'] as List).cast<Map<String, dynamic>>(),
///   totalExtractor: (json) => json['total'] as int,
///   skipExtractor: (json) => json['skip'] as int,
///   limitExtractor: (json) => json['limit'] as int,
/// );
/// ```
class PaginationResponse<T> {
  /// The list of items for the current page
  final List<T> items;

  /// Total number of items available (across all pages)
  final int total;

  /// Current skip/offset value
  final int skip;

  /// Number of items per page
  final int limit;

  /// Whether this is the last page
  final bool isLastPage;

  /// Next page key (can be page number, cursor, or offset)
  final dynamic nextPageKey;

  const PaginationResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
    required this.isLastPage,
    this.nextPageKey,
  });

  /// Creates a PaginationResponse from JSON with custom extractors
  ///
  /// This factory allows adaptation to different API response formats
  /// by providing custom functions to extract data from the JSON response.
  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson, {
    List<dynamic> Function(Map<String, dynamic>)? dataExtractor,
    int Function(Map<String, dynamic>)? totalExtractor,
    int Function(Map<String, dynamic>)? skipExtractor,
    int Function(Map<String, dynamic>)? limitExtractor,
    dynamic Function(Map<String, dynamic>)? nextPageKeyExtractor,
  }) {
    // Default extractors for common API patterns
    final items =
        (dataExtractor?.call(json) ??
                json['data'] ??
                json['items'] ??
                json['results'] ??
                json['products'] ??
                json)
            as List<dynamic>;

    final itemList = items
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .toList();

    final total =
        totalExtractor?.call(json) ??
        json['total'] ??
        json['totalCount'] ??
        json['count'] ??
        itemList.length;

    final skip =
        skipExtractor?.call(json) ?? json['skip'] ?? json['offset'] ?? 0;

    final limit =
        limitExtractor?.call(json) ??
        json['limit'] ??
        json['pageSize'] ??
        json['size'] ??
        itemList.length;

    final nextPageKey =
        nextPageKeyExtractor?.call(json) ??
        (skip + limit < total ? skip + limit : null);

    return PaginationResponse<T>(
      items: itemList,
      total: total as int,
      skip: skip as int,
      limit: limit as int,
      isLastPage: skip + limit >= total,
      nextPageKey: nextPageKey,
    );
  }

  /// Creates a PaginationResponse for DummyJSON-style APIs
  ///
  /// This is a convenience factory for APIs that follow the DummyJSON format:
  /// ```json
  /// {
  ///   "products": [...],
  ///   "total": 194,
  ///   "skip": 10,
  ///   "limit": 10
  /// }
  /// ```
  factory PaginationResponse.fromDummyJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
    String dataKey,
  ) {
    return PaginationResponse.fromJson(
      json,
      itemFromJson,
      dataExtractor: (json) => json[dataKey] as List<dynamic>,
      totalExtractor: (json) => json['total'] as int,
      skipExtractor: (json) => json['skip'] as int,
      limitExtractor: (json) => json['limit'] as int,
    );
  }

  /// Creates a PaginationResponse for cursor-based pagination
  ///
  /// This factory supports APIs that use cursor-based pagination:
  /// ```json
  /// {
  ///   "data": [...],
  ///   "pagination": {
  ///     "next_cursor": "cursor_string",
  ///     "has_more": true
  ///   }
  /// }
  /// ```
  factory PaginationResponse.fromCursorBased(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson, {
    String dataKey = 'data',
    String paginationKey = 'pagination',
    String nextCursorKey = 'next_cursor',
    String hasMoreKey = 'has_more',
  }) {
    final items = json[dataKey] as List<dynamic>;
    final itemList = items
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .toList();
    final pagination = json[paginationKey] as Map<String, dynamic>?;
    final hasMore = pagination?[hasMoreKey] as bool? ?? false;
    final nextCursor = pagination?[nextCursorKey];

    return PaginationResponse<T>(
      items: itemList,
      total: -1, // Unknown for cursor-based pagination
      skip: 0, // Not applicable for cursor-based
      limit: itemList.length,
      isLastPage: !hasMore,
      nextPageKey: hasMore ? nextCursor : null,
    );
  }

  /// Creates a PaginationResponse for page-based pagination
  ///
  /// This factory supports APIs that use page numbers:
  /// ```json
  /// {
  ///   "data": [...],
  ///   "current_page": 1,
  ///   "last_page": 10,
  ///   "per_page": 15,
  ///   "total": 150
  /// }
  /// ```
  factory PaginationResponse.fromPageBased(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson, {
    String dataKey = 'data',
    String currentPageKey = 'current_page',
    String lastPageKey = 'last_page',
    String perPageKey = 'per_page',
    String totalKey = 'total',
  }) {
    final items = json[dataKey] as List<dynamic>;
    final itemList = items
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .toList();
    final currentPage = json[currentPageKey] as int;
    final lastPage = json[lastPageKey] as int;
    final perPage = json[perPageKey] as int;
    final total = json[totalKey] as int;

    return PaginationResponse<T>(
      items: itemList,
      total: total,
      skip: (currentPage - 1) * perPage,
      limit: perPage,
      isLastPage: currentPage >= lastPage,
      nextPageKey: currentPage < lastPage ? currentPage + 1 : null,
    );
  }

  @override
  String toString() {
    return 'PaginationResponse(items: ${items.length}, total: $total, skip: $skip, limit: $limit, isLastPage: $isLastPage, nextPageKey: $nextPageKey)';
  }
}

/// Parameters for pagination requests
///
/// This class provides a unified way to specify pagination parameters
/// that can be adapted to different API requirements.
class PaginationParams {
  /// Page number (1-based, will be converted to 0-based if needed)
  final int? page;

  /// Skip/offset value (0-based)
  final int? skip;

  /// Number of items per page
  final int limit;

  /// Cursor for cursor-based pagination
  final String? cursor;

  /// Additional query parameters
  final Map<String, dynamic>? extraParams;

  const PaginationParams({
    this.page,
    this.skip,
    required this.limit,
    this.cursor,
    this.extraParams,
  });

  /// Creates pagination params for offset-based pagination (like DummyJSON)
  factory PaginationParams.offset({
    required int skip,
    required int limit,
    Map<String, dynamic>? extraParams,
  }) {
    return PaginationParams(
      skip: skip,
      limit: limit,
      extraParams: extraParams,
    );
  }

  /// Creates pagination params for page-based pagination
  factory PaginationParams.page({
    required int page,
    required int limit,
    Map<String, dynamic>? extraParams,
  }) {
    return PaginationParams(
      page: page,
      limit: limit,
      extraParams: extraParams,
    );
  }

  /// Creates pagination params for cursor-based pagination
  factory PaginationParams.cursor({
    required int limit,
    String? cursor,
    Map<String, dynamic>? extraParams,
  }) {
    return PaginationParams(
      limit: limit,
      cursor: cursor,
      extraParams: extraParams,
    );
  }

  /// Converts to query parameters map
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (page != null) {
      params['page'] = page;
    }

    if (skip != null) {
      params['skip'] = skip;
    }

    params['limit'] = limit;

    if (cursor != null) {
      params['cursor'] = cursor;
    }

    if (extraParams != null) {
      params.addAll(extraParams!);
    }

    return params;
  }

  /// Creates new params for the next page
  PaginationParams nextPage() {
    if (page != null) {
      return PaginationParams(
        page: page! + 1,
        limit: limit,
        extraParams: extraParams,
      );
    } else if (skip != null) {
      return PaginationParams(
        skip: skip! + limit,
        limit: limit,
        extraParams: extraParams,
      );
    } else {
      return this;
    }
  }

  @override
  String toString() {
    return 'PaginationParams(page: $page, skip: $skip, limit: $limit, cursor: $cursor, extraParams: $extraParams)';
  }
}
