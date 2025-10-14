# JetPaginator Documentation

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Basic Usage](#basic-usage)
  - [Simple List](#simple-list)
  - [Grid Layout](#grid-layout)
- [API Response Formats](#api-response-formats)
  - [Offset-Based (DummyJSON, Skip/Limit)](#offset-based-dummyjson-skiplimit)
  - [Page-Based (Page Number)](#page-based-page-number)
  - [Cursor-Based (Cursor/Token)](#cursor-based-cursortoken)
  - [Laravel Pagination](#laravel-pagination)
- [Complete Laravel Example](#complete-laravel-example)
- [Customization](#customization)
  - [Custom Loading Indicator](#custom-loading-indicator)
  - [Custom Error Handling](#custom-error-handling)
  - [Custom Empty State](#custom-empty-state)
  - [Custom Refresh Indicator](#custom-refresh-indicator)
  - [Fully Custom Refresh Indicator](#fully-custom-refresh-indicator)
- [Riverpod Integration](#riverpod-integration)
  - [With Non-Family Providers](#with-non-family-providers)
  - [With Family Providers](#with-family-providers)
- [Advanced Features](#advanced-features)
  - [Custom Page Threshold](#custom-page-threshold)
  - [Disable Pull-to-Refresh](#disable-pull-to-refresh)
  - [Custom Padding and Physics](#custom-padding-and-physics)
- [Complete Example](#complete-example)
- [API Reference](#api-reference)
  - [JetPaginator.list](#jetpaginatorlist)
  - [JetPaginator.grid](#jetpaginatorgrid)
  - [PageInfo](#pageinfo)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [See Also](#see-also)

## Overview

**JetPaginator** provides simple, powerful infinite scroll pagination that works with **ANY** API format. Built on top of the official `infinite_scroll_pagination` package for maximum reliability and performance.

## Key Features

- ✅ **Universal API Support** - Works with offset-based, page-based, cursor-based, or any custom pagination
- ✅ **Official Package** - Built on `infinite_scroll_pagination` for robust state management
- ✅ **Pull-to-Refresh** - Integrated pull-to-refresh with customizable indicators
- ✅ **Smart Error Handling** - Built-in error handling with automatic retry functionality
- ✅ **Riverpod Integration** - Optional provider integration for automatic refresh
- ✅ **List & Grid Layouts** - Support for both list and grid views
- ✅ **Type-Safe** - Full generic type support for items and responses
- ✅ **Customizable** - Extensive customization for loading, error, and empty states
- ✅ **Performance Optimized** - Efficient state management and memory handling

## Basic Usage

### Simple List

```dart
import 'package:jet/jet.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: JetPaginator.list<Product, Map<String, dynamic>>(
        fetchPage: (pageKey) async {
          final response = await api.getProducts(
            skip: pageKey as int,
            limit: 20,
          );
          return response;
        },
        parseResponse: (response, pageKey) => PageInfo(
          items: (response['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList(),
          nextPageKey: response['skip'] + response['limit'] < response['total']
              ? response['skip'] + response['limit']
              : null,
        ),
        itemBuilder: (product, index) => ListTile(
          leading: Image.network(product.imageUrl),
          title: Text(product.name),
          subtitle: Text('\$${product.price}'),
          onTap: () => _viewProduct(product),
        ),
      ),
    );
  }
}
```

### Grid Layout

```dart
JetPaginator.grid<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey as int, limit: 20),
  parseResponse: (response, pageKey) => PageInfo(
    items: (response['products'] as List)
        .map((json) => Product.fromJson(json))
        .toList(),
    nextPageKey: response['skip'] + response['limit'] < response['total']
        ? response['skip'] + response['limit']
        : null,
  ),
  itemBuilder: (product, index) => Card(
    child: Column(
      children: [
        Image.network(product.imageUrl),
        Text(product.name),
        Text('\$${product.price}'),
      ],
    ),
  ),
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 0.75,
)
```

## API Response Formats

JetPaginator works with any API format by using the `parseResponse` function to extract pagination information.

**💡 Pro Tip:** Jet includes a built-in `PaginationResponse` class with pre-configured factory methods for common API formats:
- `PaginationResponse.fromLaravel()` - Laravel pagination
- `PaginationResponse.fromDummyJson()` - DummyJSON-style APIs
- `PaginationResponse.fromPageBased()` - Page-based pagination
- `PaginationResponse.fromCursorBased()` - Cursor-based pagination
- `PaginationResponse.fromJson()` - Custom format with extractors

These helpers make parsing API responses easier and more consistent across your app.

### Offset-Based (DummyJSON, Skip/Limit)

```dart
// API Response:
{
  "products": [...],
  "total": 100,
  "skip": 0,
  "limit": 20
}

// Parse Response (Manual):
parseResponse: (response, pageKey) => PageInfo(
  items: (response['products'] as List)
      .map((json) => Product.fromJson(json))
      .toList(),
  nextPageKey: response['skip'] + response['limit'] < response['total']
      ? response['skip'] + response['limit']
      : null,
  totalItems: response['total'],
),

// Or use Jet's PaginationResponse:
parseResponse: (response, pageKey) {
  final pagination = PaginationResponse.fromDummyJson(
    response,
    Product.fromJson,
    'products', // data key
  );
  return PageInfo(
    items: pagination.items,
    nextPageKey: pagination.nextPageKey,
    totalItems: pagination.total,
  );
},
```

### Page-Based (Page Number)

```dart
// API Response:
{
  "data": [...],
  "current_page": 1,
  "last_page": 10,
  "per_page": 15,
  "total": 150
}

// Parse Response (Manual):
parseResponse: (response, currentPage) => PageInfo(
  items: (response['data'] as List)
      .map((json) => User.fromJson(json))
      .toList(),
  nextPageKey: response['current_page'] < response['last_page']
      ? (currentPage as int) + 1
      : null,
  totalItems: response['total'],
),
firstPageKey: 1, // Start from page 1

// Or use Jet's PaginationResponse:
parseResponse: (response, currentPage) {
  final pagination = PaginationResponse.fromPageBased(
    response,
    User.fromJson,
    dataKey: 'data',
    currentPageKey: 'current_page',
    lastPageKey: 'last_page',
    perPageKey: 'per_page',
    totalKey: 'total',
  );
  return PageInfo(
    items: pagination.items,
    nextPageKey: pagination.nextPageKey,
    totalItems: pagination.total,
  );
},
firstPageKey: 1,
```

### Cursor-Based (Cursor/Token)

```dart
// API Response:
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true
  }
}

// Parse Response (Manual):
parseResponse: (response, currentCursor) => PageInfo(
  items: (response['data'] as List)
      .map((json) => Post.fromJson(json))
      .toList(),
  nextPageKey: response['pagination']?['next_cursor'],
  isLastPage: !(response['pagination']?['has_more'] ?? false),
),
firstPageKey: null, // Initial cursor is null

// Or use Jet's PaginationResponse:
parseResponse: (response, currentCursor) {
  final pagination = PaginationResponse.fromCursorBased(
    response,
    Post.fromJson,
    dataKey: 'data',
    paginationKey: 'pagination',
    nextCursorKey: 'next_cursor',
    hasMoreKey: 'has_more',
  );
  return PageInfo(
    items: pagination.items,
    nextPageKey: pagination.nextPageKey,
    isLastPage: pagination.isLastPage,
  );
},
firstPageKey: null,
```

### Laravel Pagination

```dart
// API Response:
{
  "data": [...],
  "current_page": 1,
  "last_page": 5,
  "per_page": 15,
  "total": 73
}

// Parse Response:
parseResponse: (response, currentPage) => PageInfo(
  items: (response['data'] as List)
      .map((json) => Item.fromJson(json))
      .toList(),
  nextPageKey: response['current_page'] < response['last_page']
      ? (response['current_page'] + 1)
      : null,
  totalItems: response['total'],
),
firstPageKey: 1,
```

## Complete Laravel Example

Here's a full working example using Laravel's pagination format with Jet's built-in `PaginationResponse.fromLaravel()`:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet.dart';

// API Service
class ArticleApiService extends JetApiService {
  @override
  String get baseUrl => 'https://your-api.com/api';

  Future<Map<String, dynamic>> getArticles({required int page, int perPage = 15}) async {
    final response = await get(
      '/articles',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}

// Article Model
class Article {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String author;
  final DateTime publishedAt;
  final String? imageUrl;
  final int viewCount;

  Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.author,
    required this.publishedAt,
    this.imageUrl,
    required this.viewCount,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'] as int,
    title: json['title'] as String,
    excerpt: json['excerpt'] as String,
    content: json['content'] as String,
    author: json['author'] as String,
    publishedAt: DateTime.parse(json['published_at'] as String),
    imageUrl: json['image_url'] as String?,
    viewCount: json['view_count'] as int,
  );
}

// Provider
final articleApiServiceProvider = Provider<ArticleApiService>((ref) {
  return ArticleApiService();
});

// Articles Page with Laravel Pagination
class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.read(articleApiServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: JetPaginator.list<Article, Map<String, dynamic>>(
        // Fetch page from Laravel API
        fetchPage: (pageKey) async {
          final response = await apiService.getArticles(
            page: pageKey as int,
            perPage: 15,
          );
          return response;
        },
        
        // Parse Laravel pagination response using Jet's PaginationResponse
        parseResponse: (response, currentPage) {
          final pagination = PaginationResponse.fromLaravel(
            response,
            (json) => Article.fromJson(json),
          );

          return PageInfo<Article>(
            items: pagination.items,
            nextPageKey: pagination.nextPageKey,
            isLastPage: pagination.isLastPage,
            totalItems: pagination.total,
          );
        },
        
        // Build each article item
        itemBuilder: (article, index) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: () => _navigateToArticle(context, article),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Article Image
                if (article.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.network(
                      article.imageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Title
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // Article Excerpt
                      Text(
                        article.excerpt,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Article Meta
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.author,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            article.publishedAt.formattedDate(
                              format: 'MMM dd, yyyy',
                            ),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${article.viewCount}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Configuration
        firstPageKey: 1, // Laravel pagination starts at 1
        enablePullToRefresh: true,
        refreshIndicatorColor: Theme.of(context).primaryColor,
        
        // Empty state
        noItemsTitle: 'No Articles Found',
        noItemsMessage: 'There are no articles available at this time.',
        
        // Pagination behavior
        itemsThresholdToTriggerLoad: 3, // Load next page when 3 items from bottom
        
        // Callbacks
        onRefresh: () {
          // Invalidate providers or perform custom refresh logic
          dump('Refreshing articles...');
        },
      ),
    );
  }

  void _navigateToArticle(BuildContext context, Article article) {
    // Navigate to article details
    context.router.push(ArticleDetailsRoute(articleId: article.id));
  }

  void _showSearch(BuildContext context) {
    // Show search dialog
    showSearch(
      context: context,
      delegate: ArticleSearchDelegate(),
    );
  }
}

// Alternative: Using a helper function for cleaner code
PageInfo<T> parseLaravelPagination<T>(
  Map<String, dynamic> response,
  T Function(Map<String, dynamic>) fromJson,
) {
  final pagination = PaginationResponse.fromLaravel(response, fromJson);
  
  return PageInfo<T>(
    items: pagination.items,
    nextPageKey: pagination.nextPageKey,
    isLastPage: pagination.isLastPage,
    totalItems: pagination.total,
  );
}

// Usage with helper function
class ArticlesPageSimplified extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiService = ref.read(articleApiServiceProvider);

    return Scaffold(
      body: JetPaginator.list<Article, Map<String, dynamic>>(
        fetchPage: (page) => apiService.getArticles(page: page as int),
        parseResponse: (response, page) => parseLaravelPagination(
          response,
          Article.fromJson,
        ),
        itemBuilder: (article, index) => ArticleCard(article: article),
        firstPageKey: 1,
      ),
    );
  }
}
```

**Laravel Pagination Key Points:**
- Start page counting from `1` (not `0`)
- Use Jet's built-in `PaginationResponse.fromLaravel()` for easy parsing
- Laravel provides helpful metadata like `total`, `per_page`, `from`, `to`
- The `PaginationResponse` class handles all pagination logic automatically
- Use a helper function for cleaner pagination parsing across your app

## Customization

### Custom Loading Indicator

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  loadingIndicator: CircularProgressIndicator(
    color: Colors.green,
    strokeWidth: 3,
  ),
)
```

### Custom Error Handling

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  errorIndicator: (error, ref) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, size: 64, color: Colors.red),
      SizedBox(height: 16),
      Text('Failed to load products'),
      SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => ref.invalidate(productsProvider),
        child: Text('Retry'),
      ),
    ],
  ),
  fetchMoreErrorIndicator: (error, ref) => Padding(
    padding: EdgeInsets.all(16),
    child: Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 12),
            Expanded(child: Text('Failed to load more')),
            TextButton(
              onPressed: () => {/* retry */},
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

### Custom Empty State

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  noItemsIndicator: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
      SizedBox(height: 16),
      Text('No products found', style: TextStyle(fontSize: 18)),
      SizedBox(height: 8),
      Text('Try adjusting your filters'),
    ],
  ),
  noItemsTitle: 'No Products',
  noItemsMessage: 'There are no products available at this time.',
  noItemsActionTitle: 'Refresh',
  onNoItemsActionTap: () => _refreshProducts(),
)
```

### Custom Refresh Indicator

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  // Simple color customization
  refreshIndicatorColor: Colors.green,
  refreshIndicatorBackgroundColor: Colors.grey[100],
  refreshIndicatorStrokeWidth: 3.0,
  refreshIndicatorDisplacement: 50.0,
)
```

### Fully Custom Refresh Indicator

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  refreshIndicatorBuilder: (context, controller) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Icon(
        Icons.refresh,
        color: controller.state.isLoading ? Colors.blue : Colors.grey,
        size: 24 + (controller.value * 12), // Animated size
      ),
    );
  },
)
```

## Riverpod Integration

### With Non-Family Providers

```dart
// Define a simple provider
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(apiServiceProvider);
  return await api.getAllProducts();
});

// Use with provider integration
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey, limit: 20),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  provider: allProductsProvider, // Enable Riverpod integration
)
```

### With Family Providers

```dart
// Family providers can't be passed directly, use manual invalidate
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => ref.read(productsProvider(categoryId).future),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  onRefresh: () => ref.invalidate(productsProvider), // Manual invalidate
)
```

## Advanced Features

### Custom Page Threshold

Control when the next page is fetched:

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  itemsThresholdToTriggerLoad: 5, // Fetch when 5 items from end
)
```

### Disable Pull-to-Refresh

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  enablePullToRefresh: false,
)
```

### Custom Padding and Physics

```dart
JetPaginator.list<Product, Map<String, dynamic>>(
  fetchPage: (pageKey) => api.getProducts(skip: pageKey),
  parseResponse: (response, pageKey) => PageInfo(...),
  itemBuilder: (product, index) => ProductCard(product: product),
  padding: EdgeInsets.all(16),
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
)
```

## Complete Example

Here's a complete example demonstrating various features:

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet.dart';

class ProductsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: JetPaginator.list<Product, Map<String, dynamic>>(
        // Fetch function
        fetchPage: (pageKey) async {
          final api = ref.read(apiServiceProvider);
          final response = await api.getProducts(
            skip: pageKey as int,
            limit: 20,
          );
          return response;
        },
        
        // Parse pagination info
        parseResponse: (response, pageKey) {
          final products = (response['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
          
          final skip = response['skip'] as int;
          final limit = response['limit'] as int;
          final total = response['total'] as int;
          
          return PageInfo(
            items: products,
            nextPageKey: skip + limit < total ? skip + limit : null,
            totalItems: total,
          );
        },
        
        // Item builder
        itemBuilder: (product, index) => Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.thumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(product.title),
            subtitle: Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${product.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (product.discountPercentage > 0)
                  Text(
                    '${product.discountPercentage}% OFF',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            onTap: () => context.router.push(
              ProductDetailsRoute(product: product),
            ),
          ),
        ),
        
        // Customization
        firstPageKey: 0,
        enablePullToRefresh: true,
        refreshIndicatorColor: Theme.of(context).primaryColor,
        
        // Empty state
        noItemsTitle: 'No Products Found',
        noItemsMessage: 'Try adjusting your search or filters',
        
        // Callbacks
        onRefresh: () {
          ref.invalidate(productsProvider);
        },
      ),
    );
  }
}

// Models
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    price: json['price'].toDouble(),
    discountPercentage: json['discountPercentage'].toDouble(),
    thumbnail: json['thumbnail'],
  );
}
```

## API Reference

### JetPaginator.list

Creates an infinite scroll list.

**Type Parameters:**
- `T` - Type of items in the list
- `TResponse` - Type of API response (usually `Map<String, dynamic>`)

**Parameters:**

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `fetchPage` | `Function` | Yes | - | Function that fetches a page of data |
| `parseResponse` | `Function` | Yes | - | Function that extracts PageInfo from response |
| `itemBuilder` | `Function` | Yes | - | Function to build each item widget |
| `firstPageKey` | `dynamic` | No | `0` | Initial page key (page number, offset, cursor, etc.) |
| `enablePullToRefresh` | `bool` | No | `true` | Enable/disable pull-to-refresh |
| `provider` | `Object?` | No | `null` | Optional provider for Riverpod integration |
| `refreshIndicatorBuilder` | `Function?` | No | `null` | Custom refresh indicator builder |
| `refreshIndicatorColor` | `Color?` | No | `null` | Color of refresh indicator |
| `refreshIndicatorBackgroundColor` | `Color?` | No | `null` | Background color of refresh indicator |
| `refreshIndicatorStrokeWidth` | `double?` | No | `2.0` | Stroke width of refresh indicator |
| `refreshIndicatorDisplacement` | `double?` | No | `40.0` | Distance to trigger refresh |
| `loadingIndicator` | `Widget?` | No | `null` | Custom loading indicator |
| `errorIndicator` | `Function?` | No | `null` | Custom error widget builder |
| `fetchMoreErrorIndicator` | `Function?` | No | `null` | Custom pagination error widget builder |
| `noItemsIndicator` | `Widget?` | No | `null` | Custom empty state widget |
| `noMoreItemsIndicator` | `Widget?` | No | `null` | Custom end of list widget |
| `padding` | `EdgeInsets?` | No | `null` | List padding |
| `shrinkWrap` | `bool` | No | `false` | Whether to shrink wrap the list |
| `physics` | `ScrollPhysics?` | No | `null` | Scroll physics |
| `onRetry` | `VoidCallback?` | No | `null` | Callback when retry is tapped |
| `onRefresh` | `VoidCallback?` | No | `null` | Callback when pull-to-refresh is triggered |
| `onNoItemsActionTap` | `VoidCallback?` | No | `null` | Callback when empty state action is tapped |
| `noItemsTitle` | `String?` | No | `null` | Title for empty state |
| `noItemsMessage` | `String?` | No | `null` | Message for empty state |
| `noItemsActionTitle` | `String?` | No | `null` | Action button text for empty state |
| `noMoreItemsTitle` | `String?` | No | `null` | Title for end of list |
| `noMoreItemsMessage` | `String?` | No | `null` | Message for end of list |
| `noMoreItemsActionTitle` | `String?` | No | `null` | Action button text for end of list |
| `itemsThresholdToTriggerLoad` | `int` | No | `3` | Items from end to trigger next page load |

### JetPaginator.grid

Creates an infinite scroll grid.

Similar parameters to `list`, plus:

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `crossAxisCount` | `int` | Yes | - | Number of columns in grid |
| `crossAxisSpacing` | `double` | No | `8.0` | Horizontal spacing between items |
| `mainAxisSpacing` | `double` | No | `8.0` | Vertical spacing between items |
| `childAspectRatio` | `double` | No | `1.0` | Aspect ratio of grid items |

### PageInfo

Represents pagination information extracted from API response.

**Properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `items` | `List<T>` | Yes | List of items for current page |
| `nextPageKey` | `dynamic` | No | Key for next page (null if last page) |
| `isLastPage` | `bool?` | No | Whether this is the last page |
| `totalItems` | `int?` | No | Total number of items (if available) |

## Best Practices

1. **Always specify generic types:**
   ```dart
   // Good
   JetPaginator.list<Product, Map<String, dynamic>>(...)
   
   // Bad - loses type safety
   JetPaginator.list(...)
   ```

2. **Handle errors gracefully:**
   ```dart
   fetchPage: (pageKey) async {
     try {
       return await api.getProducts(skip: pageKey);
     } catch (error) {
       // Let JetPaginator handle the error display
       rethrow;
     }
   }
   ```

3. **Use appropriate page keys:**
   ```dart
   // Offset-based: use int
   firstPageKey: 0
   nextPageKey: 20
   
   // Page-based: use int
   firstPageKey: 1
   nextPageKey: 2
   
   // Cursor-based: use string or null
   firstPageKey: null
   nextPageKey: "eyJpZCI6MTAwfQ=="
   ```

4. **Optimize item builders:**
   ```dart
   // Good - extract to separate widget
   itemBuilder: (product, index) => ProductCard(product: product)
   
   // Avoid - inline complex widgets
   itemBuilder: (product, index) => Card(
     child: Column(children: [/* complex UI */]),
   )
   ```

5. **Use custom error indicators for better UX:**
   ```dart
   errorIndicator: (error, ref) {
     if (error is JetError && error.isNoInternet) {
       return NoInternetWidget(
         onRetry: () => ref.invalidate(provider),
       );
     }
     return GenericErrorWidget();
   }
   ```

## Troubleshooting

### Pages not loading

Check that your `parseResponse` function:
- Returns correct `nextPageKey`
- Returns `null` for `nextPageKey` on last page
- Correctly maps JSON to your model

### Pull-to-refresh not working

Ensure:
- `enablePullToRefresh` is `true` (default)
- Widget is not wrapped in another scroll view
- Physics allow scrolling

### Memory issues with large lists

- Use `shrinkWrap: false` (default)
- Ensure images are properly cached
- Consider using cached network images

## See Also

- [JetBuilder Documentation](./JET_BUILDER.md)
- [State Management Guide](./STATE_MANAGEMENT.md)
- [Example App](../../example/lib/features/users/pages/users_page.dart)

