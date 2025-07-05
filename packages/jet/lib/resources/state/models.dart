/// Data models for Jet state management
///
/// This file contains all the model classes used by the Jet state management system,
/// including pagination responses and related data structures.
library;

/// Generic pagination response wrapper
///
/// This class can adapt to different API response formats by using
/// custom extractors for data, total count, and pagination metadata.
///
/// **Examples:**
///
/// **DummyJSON-style APIs:**
/// ```dart
/// final response = PaginationResponse.fromJson(
///   json,
///   Product.fromJson,
///   dataExtractor: (json) => json['products'] as List<dynamic>,
///   totalExtractor: (json) => json['total'] as int,
///   skipExtractor: (json) => json['skip'] as int,
///   limitExtractor: (json) => json['limit'] as int,
/// );
/// ```
///
/// **Standard REST APIs:**
/// ```dart
/// final response = PaginationResponse.fromJson(
///   json,
///   User.fromJson,
///   dataExtractor: (json) => json['data'] as List<dynamic>,
///   totalExtractor: (json) => json['total'] as int,
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
  ///
  /// **Parameters:**
  /// - [json]: The JSON response from the API
  /// - [itemFromJson]: Function to convert each item JSON to type T
  /// - [dataExtractor]: Custom function to extract the items array
  /// - [totalExtractor]: Custom function to extract total count
  /// - [skipExtractor]: Custom function to extract skip/offset value
  /// - [limitExtractor]: Custom function to extract limit/page size
  /// - [nextPageKeyExtractor]: Custom function to extract next page key
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

  /// Creates a PaginationResponse for Laravel-style pagination
  ///
  /// This factory supports Laravel's paginate() response format:
  /// ```json
  /// {
  ///   "data": [...],
  ///   "current_page": 1,
  ///   "last_page": 10,
  ///   "per_page": 15,
  ///   "total": 150,
  ///   "from": 1,
  ///   "to": 15
  /// }
  /// ```
  factory PaginationResponse.fromLaravel(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    return PaginationResponse.fromPageBased(
      json,
      itemFromJson,
      dataKey: 'data',
      currentPageKey: 'current_page',
      lastPageKey: 'last_page',
      perPageKey: 'per_page',
      totalKey: 'total',
    );
  }

  /// Creates an empty PaginationResponse
  ///
  /// Useful for initial states or when no data is available.
  factory PaginationResponse.empty() {
    return PaginationResponse<T>(
      items: const [],
      total: 0,
      skip: 0,
      limit: 0,
      isLastPage: true,
      nextPageKey: null,
    );
  }

  /// Creates a single-page PaginationResponse from a list of items
  ///
  /// Useful when you have all data in memory and want to display it
  /// in a paginated format.
  factory PaginationResponse.fromList(List<T> items) {
    return PaginationResponse<T>(
      items: items,
      total: items.length,
      skip: 0,
      limit: items.length,
      isLastPage: true,
      nextPageKey: null,
    );
  }

  /// Converts this pagination response to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) itemToJson) {
    return {
      'data': items.map(itemToJson).toList(),
      'total': total,
      'skip': skip,
      'limit': limit,
      'isLastPage': isLastPage,
      'nextPageKey': nextPageKey,
    };
  }

  /// Returns a copy of this pagination response with updated values
  PaginationResponse<T> copyWith({
    List<T>? items,
    int? total,
    int? skip,
    int? limit,
    bool? isLastPage,
    dynamic nextPageKey,
  }) {
    return PaginationResponse<T>(
      items: items ?? this.items,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      isLastPage: isLastPage ?? this.isLastPage,
      nextPageKey: nextPageKey ?? this.nextPageKey,
    );
  }

  /// Whether there are more pages available
  bool get hasNextPage => !isLastPage;

  /// Whether there are previous pages available
  bool get hasPreviousPage => skip > 0;

  /// The current page number (1-based)
  int get currentPage => (skip ~/ limit) + 1;

  /// The total number of pages
  int get totalPages => total > 0 ? (total / limit).ceil() : 0;

  /// The range of items on the current page (e.g., "1-10 of 100")
  String get itemRange {
    if (items.isEmpty) return '0 of $total';
    final from = skip + 1;
    final to = skip + items.length;
    return '$from-$to of $total';
  }

  @override
  String toString() {
    return 'PaginationResponse('
        'items: ${items.length}, '
        'total: $total, '
        'skip: $skip, '
        'limit: $limit, '
        'isLastPage: $isLastPage, '
        'nextPageKey: $nextPageKey'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PaginationResponse<T>) return false;
    return items == other.items &&
        total == other.total &&
        skip == other.skip &&
        limit == other.limit &&
        isLastPage == other.isLastPage &&
        nextPageKey == other.nextPageKey;
  }

  @override
  int get hashCode {
    return Object.hash(
      items,
      total,
      skip,
      limit,
      isLastPage,
      nextPageKey,
    );
  }
}
