import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// A cache entry that includes data and expiration timestamp
class _CacheEntry {
  final Map<String, dynamic> data;
  final DateTime expiresAt;

  _CacheEntry({
    required this.data,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'data': data,
    'expiresAt': expiresAt.millisecondsSinceEpoch,
  };

  factory _CacheEntry.fromJson(Map<String, dynamic> json) {
    return _CacheEntry(
      data: Map<String, dynamic>.from(json['data']),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expiresAt']),
    );
  }
}

/// A lightweight cache implementation with TTL support
///
/// This class provides a simple caching mechanism using Hive for persistence
/// with built-in TTL (Time To Live) functionality for automatic expiration.
class JetCache {
  static const String boxName = 'jet_cache';
  static bool _initialized = false;

  /// Initializes the cache system
  ///
  /// This method must be called before using any cache operations.
  /// It initializes Hive and opens the cache box.
  static Future<void> init() async {
    if (_initialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
      await Hive.openBox(boxName);
      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize JetCache: $e');
    }
  }

  /// Writes data to cache with optional TTL
  ///
  /// [key] - The cache key
  /// [data] - The data to cache
  /// [ttl] - Time to live duration (optional, defaults to no expiration)
  static Future<void> write(
    String key,
    Map<String, dynamic> data, {
    Duration? ttl,
  }) async {
    _ensureInitialized();

    try {
      final entry = _CacheEntry(
        data: data,
        expiresAt: ttl != null
            ? DateTime.now().add(ttl)
            : DateTime.now().add(const Duration(days: 365 * 100)), // Far future
      );

      await Hive.box(boxName).put(key, entry.toJson());
    } catch (e) {
      throw Exception('Failed to write to cache: $e');
    }
  }

  /// Reads data from cache
  ///
  /// Returns null if the key doesn't exist or if the entry has expired.
  /// Automatically removes expired entries.
  static Future<Map<String, dynamic>?> read(String key) async {
    _ensureInitialized();

    try {
      final entryData = Hive.box(boxName).get(key);
      if (entryData == null) return null;

      final entry = _CacheEntry.fromJson(Map<String, dynamic>.from(entryData));

      if (entry.isExpired) {
        await delete(key);
        return null;
      }

      return entry.data;
    } catch (e) {
      // If deserialization fails, remove the corrupted entry
      await delete(key);
      return null;
    }
  }

  /// Deletes a specific cache entry
  static Future<void> delete(String key) async {
    _ensureInitialized();

    try {
      await Hive.box(boxName).delete(key);
    } catch (e) {
      throw Exception('Failed to delete from cache: $e');
    }
  }

  /// Clears all cache entries
  static Future<void> clear() async {
    _ensureInitialized();

    try {
      await Hive.box(boxName).clear();
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  /// Cleans up expired entries
  ///
  /// This method should be called periodically to remove expired entries
  /// and free up storage space.
  static Future<int> cleanupExpired() async {
    _ensureInitialized();

    try {
      final box = Hive.box(boxName);
      final keys = box.keys.toList();
      int removedCount = 0;

      for (final key in keys) {
        try {
          final entryData = box.get(key);
          if (entryData == null) continue;

          final entry = _CacheEntry.fromJson(
            Map<String, dynamic>.from(entryData),
          );
          if (entry.isExpired) {
            await box.delete(key);
            removedCount++;
          }
        } catch (e) {
          // Remove corrupted entries
          await box.delete(key);
          removedCount++;
        }
      }

      return removedCount;
    } catch (e) {
      throw Exception('Failed to cleanup expired entries: $e');
    }
  }

  /// Gets cache statistics
  ///
  /// Returns information about cache size, expired entries, etc.
  static Future<Map<String, dynamic>> getStats() async {
    _ensureInitialized();

    try {
      final box = Hive.box(boxName);
      final keys = box.keys.toList();
      int totalEntries = keys.length;
      int expiredEntries = 0;
      int validEntries = 0;

      for (final key in keys) {
        try {
          final entryData = box.get(key);
          if (entryData == null) continue;

          final entry = _CacheEntry.fromJson(
            Map<String, dynamic>.from(entryData),
          );
          if (entry.isExpired) {
            expiredEntries++;
          } else {
            validEntries++;
          }
        } catch (e) {
          expiredEntries++; // Count corrupted entries as expired
        }
      }

      return {
        'totalEntries': totalEntries,
        'validEntries': validEntries,
        'expiredEntries': expiredEntries,
        'boxName': boxName,
        'isInitialized': _initialized,
      };
    } catch (e) {
      throw Exception('Failed to get cache stats: $e');
    }
  }

  /// Checks if a key exists and is not expired
  static Future<bool> exists(String key) async {
    final data = await read(key);
    return data != null;
  }

  /// Ensures the cache is initialized before operations
  static void _ensureInitialized() {
    if (!_initialized) {
      throw Exception('JetCache not initialized. Call JetCache.init() first.');
    }
  }
}
