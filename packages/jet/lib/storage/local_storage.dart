import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/session/session_manager.dart';
import 'package:jet/storage/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A unified storage solution for the Jet framework that provides both
/// regular and secure storage capabilities.
///
/// This class uses SharedPreferences for regular data storage and
/// FlutterSecureStorage for sensitive data like tokens and passwords.
///
/// Example usage:
/// ```dart
/// // Write simple data
/// await JetStorage.write('username', 'John Doe');
///
/// // Read with type safety
/// String? username = JetStorage.read<String>('username');
///
/// // Write complex objects
/// await JetStorage.write('user', userModel);
///
/// // Read with decoder
/// User? user = JetStorage.read<User>(
///   'user',
///   decoder: (json) => User.fromJson(json),
/// );
/// ```
class JetStorage {
  static final JetStorage _instance = JetStorage._();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(),
  );

  factory JetStorage() => _instance;

  JetStorage._();

  static late final SharedPreferences _prefs;

  /// Initializes the storage system. Must be called before using any storage methods.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Writes data to regular storage.
  ///
  /// Supports primitive types (String, int, double, bool) and objects
  /// implementing the [Model] interface.
  ///
  /// For sensitive data, use [writeSecure] instead.
  static Future<bool> write(String key, dynamic value) async {
    try {
      // Handle null values
      if (value == null) {
        return await _prefs.remove(key);
      }

      // Handle primitive types
      if (value is String) {
        return await _prefs.setString(key, value);
      } else if (value is int) {
        return await _prefs.setInt(key, value);
      } else if (value is double) {
        return await _prefs.setDouble(key, value);
      } else if (value is bool) {
        return await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        return await _prefs.setStringList(key, value);
      }

      // Handle Model objects
      if (value is Model) {
        try {
          final json = value.toJson();
          return await _prefs.setString(key, jsonEncode(json));
        } catch (e, stackTrace) {
          dump(
            '[JetStorage.write] Failed to serialize ${value.runtimeType}: ${e.toString()}',
            stackTrace: stackTrace,
          );
          return false;
        }
      }

      // Handle generic objects that can be JSON encoded
      try {
        final jsonString = jsonEncode(value);
        return await _prefs.setString(key, jsonString);
      } catch (e, stackTrace) {
        dump(
          '[JetStorage.write] Unable to store value of type ${value.runtimeType}',
          stackTrace: stackTrace,
        );
        return false;
      }
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.write] Error writing to storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Reads data from regular storage with type safety.
  ///
  /// Use the generic type parameter to specify the expected return type.
  /// For complex objects, provide a [decoder] function.
  ///
  /// Returns [defaultValue] if the key doesn't exist or decoding fails.
  static T? read<T>(
    String key, {
    T Function(Map<String, dynamic> json)? decoder,
    T? defaultValue,
  }) {
    try {
      // Try to get value with the appropriate type
      final Object? value = _prefs.get(key);

      if (value == null) {
        return defaultValue;
      }

      // Direct type match
      if (value is T) {
        return value as T;
      }

      // Handle JSON decoding for complex types
      if (value is String && decoder != null) {
        try {
          final json = jsonDecode(value) as Map<String, dynamic>;
          return decoder(json);
        } catch (e) {
          dump('[JetStorage.read] Failed to decode JSON for key "$key": $e');
          return defaultValue;
        }
      }

      // Handle type conversions
      if (T == String) {
        return value.toString() as T;
      }

      // Try JSON decode for generic types
      if (value is String) {
        try {
          final decoded = jsonDecode(value);
          if (decoded is T) {
            return decoded;
          }
        } catch (_) {
          // Not valid JSON, return as is if it matches the type
        }
      }

      dump(
        '[JetStorage.read] Type mismatch for key "$key": expected $T but got ${value.runtimeType}',
      );
      return defaultValue;
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.read] Error reading from storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      return defaultValue;
    }
  }

  /// Deletes a value from regular storage.
  static Future<bool> delete(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.delete] Error deleting key "$key": ${e.toString()}',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clears all values from regular storage.
  ///
  /// Warning: This will remove all stored data. Use with caution.
  static Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.clear] Error clearing storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Writes sensitive data to secure storage.
  ///
  /// Use this for tokens, passwords, and other sensitive information.
  static Future<void> writeSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.writeSecure] Error writing to secure storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Reads sensitive data from secure storage.
  static Future<String?> readSecure(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.readSecure] Error reading from secure storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Deletes a value from secure storage.
  static Future<void> deleteSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.deleteSecure] Error deleting from secure storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Clears all values from secure storage.
  ///
  /// Warning: This will remove all secure data. Use with caution.
  static Future<void> clearSecure() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.clearSecure] Error clearing secure storage: ${e.toString()}',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // ===== Convenience Methods =====

  /// Gets the current session from storage.
  ///
  /// This is a convenience method. Consider using SessionManager.session()
  /// for session-related operations.
  static Session? getSession() {
    return read<Session>(
      'session',
      decoder: (json) => Session.fromJson(json),
    );
  }

  /// Checks if the app is currently locked.
  ///
  /// This is used by the AppLockerNotifier for app security features.
  static bool isLocked() {
    return read<bool>('isLocked') ?? false;
  }

  /// Checks if a key exists in storage.
  static bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Gets all keys from regular storage.
  ///
  /// Useful for debugging or storage management.
  static Set<String> get keys => _prefs.getKeys();
}
