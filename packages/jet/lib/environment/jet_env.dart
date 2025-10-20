import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jet/helpers/jet_logger.dart';

/// A wrapper class for flutter_dotenv that provides type-safe access
/// to environment variables with default value support.
///
/// This class provides static methods to load, access, and manage
/// environment variables throughout the application.
///
/// Example usage:
/// ```dart
/// // Initialize in main.dart or adapter
/// await JetEnv.init();
///
/// // Access variables with type safety
/// final apiUrl = JetEnv.getString('API_URL', defaultValue: 'http://localhost');
/// final timeout = JetEnv.getInt('TIMEOUT', defaultValue: 30);
/// final debugMode = JetEnv.getBool('DEBUG', defaultValue: false);
/// ```
class JetEnv {
  /// The underlying dotenv instance
  static final DotEnv _dotenv = dotenv;

  /// Whether the environment has been initialized
  static bool _isInitialized = false;

  /// Initialize the environment with the given configuration.
  ///
  /// This method loads the primary environment file and any override files
  /// specified in the configuration.
  ///
  /// [fileName] - The primary environment file to load (default: '.env')
  /// [overrideFiles] - Additional files to load that override previous values
  /// [mergeWith] - Map to merge with loaded environment variables
  static Future<void> init({
    String fileName = '.env',
    List<String> overrideFiles = const [],
    Map<String, String>? mergeWith,
  }) async {
    try {
      // Load the primary file
      if (mergeWith != null) {
        await _dotenv.load(fileName: fileName, mergeWith: mergeWith);
      } else {
        await _dotenv.load(fileName: fileName);
      }
      _isInitialized = true;

      JetLogger.debug('Loaded environment from $fileName');

      // Load override files
      for (final overrideFile in overrideFiles) {
        try {
          await _dotenv.load(fileName: overrideFile, mergeWith: _dotenv.env);
          JetLogger.debug('Loaded environment overrides from $overrideFile');
        } catch (e) {
          JetLogger.debug('Failed to load override file $overrideFile: $e');
        }
      }
    } catch (e) {
      JetLogger.error('Failed to load environment from $fileName: $e');
      _isInitialized = true; // Still mark as initialized to use defaults
    }
  }

  /// Reload the environment variables.
  ///
  /// Useful during development for hot reload scenarios.
  static Future<void> reload({
    String fileName = '.env',
    List<String> overrideFiles = const [],
    Map<String, String>? mergeWith,
  }) async {
    _dotenv.env.clear();
    await init(
      fileName: fileName,
      overrideFiles: overrideFiles,
      mergeWith: mergeWith,
    );
  }

  /// Load environment variables from a string.
  ///
  /// Useful for testing or loading from dynamic sources.
  static void loadFromString({required String input}) {
    // Clear existing env and load from string
    _dotenv.env.clear();
    final lines = input.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final parts = trimmed.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        _dotenv.env[key] = value;
      }
    }
    _isInitialized = true;
  }

  /// Get a raw environment variable value.
  ///
  /// Returns null if the key doesn't exist.
  static String? get(String key) {
    _ensureInitialized();
    return _dotenv.maybeGet(key);
  }

  /// Get a string value from the environment.
  ///
  /// Returns [defaultValue] if the key doesn't exist or is empty.
  static String getString(String key, {String defaultValue = ''}) {
    _ensureInitialized();
    return _dotenv.maybeGet(key, fallback: defaultValue) ?? defaultValue;
  }

  /// Get an integer value from the environment.
  ///
  /// Returns [defaultValue] if the key doesn't exist or cannot be parsed.
  static int getInt(String key, {int defaultValue = 0}) {
    _ensureInitialized();
    final value = _dotenv.maybeGet(key);
    if (value == null) return defaultValue;

    try {
      return int.parse(value);
    } catch (e) {
      JetLogger.debug('Failed to parse int from $key: $value');
      return defaultValue;
    }
  }

  /// Get a double value from the environment.
  ///
  /// Returns [defaultValue] if the key doesn't exist or cannot be parsed.
  static double getDouble(String key, {double defaultValue = 0.0}) {
    _ensureInitialized();
    final value = _dotenv.maybeGet(key);
    if (value == null) return defaultValue;

    try {
      return double.parse(value);
    } catch (e) {
      JetLogger.debug('Failed to parse double from $key: $value');
      return defaultValue;
    }
  }

  /// Get a boolean value from the environment.
  ///
  /// Recognizes: 'true', 'TRUE', 'True', '1' as true
  /// Recognizes: 'false', 'FALSE', 'False', '0' as false
  /// Returns [defaultValue] for any other value or if key doesn't exist.
  static bool getBool(String key, {bool defaultValue = false}) {
    _ensureInitialized();
    final value = _dotenv.maybeGet(key);
    if (value == null) return defaultValue;

    switch (value.toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
      default:
        JetLogger.debug('Invalid boolean value for $key: $value');
        return defaultValue;
    }
  }

  /// Check if an environment variable exists.
  ///
  /// Returns true if the key exists and has a non-null value.
  static bool has(String key) {
    _ensureInitialized();
    return _dotenv.maybeGet(key) != null;
  }

  /// Get all environment variables as a map.
  ///
  /// Returns a copy of the environment map to prevent external modifications.
  static Map<String, String> get all {
    _ensureInitialized();
    return Map<String, String>.from(_dotenv.env);
  }

  /// Ensure the environment has been initialized.
  ///
  /// Logs a warning if accessed before initialization.
  static void _ensureInitialized() {
    if (!_isInitialized) {
      JetLogger.debug(
        'JetEnv accessed before initialization. '
        'Call JetEnv.init() or use EnvironmentAdapter.',
      );
    }
  }

  /// Get a value or throw if it doesn't exist.
  ///
  /// Use this for required configuration values that must be present.
  static String require(String key) {
    _ensureInitialized();
    final value = _dotenv.maybeGet(key);
    if (value == null) {
      throw Exception('Required environment variable $key is not set');
    }
    return value;
  }
}
