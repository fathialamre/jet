import 'package:example/features/cache/models/cache_models.dart';
import 'package:jet/storage/jet_cache.dart';

/// Cache Service for Jet Cache Example
///
/// This service provides high-level methods for caching different types of data
/// using JetCache with appropriate TTL (Time To Live) settings.
class CacheService {
  // Private constructor to prevent instantiation
  CacheService._();

  /// Cache user data with 30-second TTL
  static Future<void> cacheUser(User user) async {
    await JetCache.write(
      CacheKeys.user,
      user.toJson(),
      ttl: CacheTTL.user,
    );
  }

  /// Get user data from cache
  static Future<User?> getUser() async {
    final data = await JetCache.read(CacheKeys.user);
    if (data == null) return null;
    return User.fromJson(data);
  }

  /// Check if user exists in cache
  static Future<bool> userExists() async {
    return await JetCache.exists(CacheKeys.user);
  }

  /// Delete user from cache
  static Future<void> deleteUser() async {
    await JetCache.delete(CacheKeys.user);
  }

  /// Cache products list with 1-minute TTL
  static Future<void> cacheProducts(List<Product> products) async {
    final data = {
      'products': products.map((p) => p.toJson()).toList(),
      'cachedAt': DateTime.now().millisecondsSinceEpoch,
    };

    await JetCache.write(
      CacheKeys.products,
      data,
      ttl: CacheTTL.products,
    );
  }

  /// Get products list from cache
  static Future<List<Product>?> getProducts() async {
    final data = await JetCache.read(CacheKeys.products);
    if (data == null) return null;

    final productsData = data['products'] as List;
    return productsData
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Check if products exist in cache
  static Future<bool> productsExist() async {
    return await JetCache.exists(CacheKeys.products);
  }

  /// Delete products from cache
  static Future<void> deleteProducts() async {
    await JetCache.delete(CacheKeys.products);
  }

  /// Cache app settings with 30-day TTL
  static Future<void> cacheSettings(AppSettings settings) async {
    await JetCache.write(
      CacheKeys.settings,
      settings.toJson(),
      ttl: CacheTTL.settings,
    );
  }

  /// Get app settings from cache
  static Future<AppSettings?> getSettings() async {
    final data = await JetCache.read(CacheKeys.settings);
    if (data == null) return null;
    return AppSettings.fromJson(data);
  }

  /// Check if settings exist in cache
  static Future<bool> settingsExist() async {
    return await JetCache.exists(CacheKeys.settings);
  }

  /// Delete settings from cache
  static Future<void> deleteSettings() async {
    await JetCache.delete(CacheKeys.settings);
  }

  /// Get cache statistics
  static Future<Map<String, dynamic>> getStats() async {
    return await JetCache.getStats();
  }

  /// Cleanup expired entries
  static Future<int> cleanupExpired() async {
    return await JetCache.cleanupExpired();
  }

  /// Clear all cache data
  static Future<void> clearAll() async {
    await JetCache.clear();
  }

  /// Cache a custom object with custom TTL
  static Future<void> cacheCustom<T>(
    String key,
    T object,
    Map<String, dynamic> Function(T) toJson, {
    Duration? ttl,
  }) async {
    await JetCache.write(
      key,
      toJson(object),
      ttl: ttl,
    );
  }

  /// Get a custom object from cache
  static Future<T?> getCustom<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final data = await JetCache.read(key);
    if (data == null) return null;
    return fromJson(data);
  }

  /// Check if a custom key exists in cache
  static Future<bool> customExists(String key) async {
    return await JetCache.exists(key);
  }

  /// Delete a custom key from cache
  static Future<void> deleteCustom(String key) async {
    await JetCache.delete(key);
  }

  /// Batch operations for multiple keys
  static Future<Map<String, dynamic?>> readMultiple(List<String> keys) async {
    final results = <String, dynamic?>{};

    for (final key in keys) {
      results[key] = await JetCache.read(key);
    }

    return results;
  }

  /// Delete multiple keys at once
  static Future<void> deleteMultiple(List<String> keys) async {
    for (final key in keys) {
      await JetCache.delete(key);
    }
  }

  /// Get all cache keys (for debugging)
  static Future<List<String>> getAllKeys() async {
    // Note: This is a simplified implementation
    // In a real scenario, you might need to track keys separately
    return [
      CacheKeys.user,
      CacheKeys.products,
      CacheKeys.settings,
    ];
  }

  /// Cache with automatic refresh
  /// If data is expired or doesn't exist, it will call the refresh function
  static Future<T?> getOrRefresh<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
    Future<Map<String, dynamic>> Function() refreshFunction, {
    Duration? ttl,
  }) async {
    // Try to get from cache first
    final cachedData = await JetCache.read(key);
    if (cachedData != null) {
      return fromJson(cachedData);
    }

    // If not in cache, refresh and cache the data
    try {
      final freshData = await refreshFunction();
      await JetCache.write(key, freshData, ttl: ttl);
      return fromJson(freshData);
    } catch (e) {
      // If refresh fails, return null
      return null;
    }
  }
}
