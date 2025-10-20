import 'package:flutter/foundation.dart';

/// Configuration class for environment variable management.
///
/// This class encapsulates all settings related to environment loading,
/// making it easy to configure environment behavior in your JetConfig.
///
/// Example usage:
/// ```dart
/// class AppConfig extends JetConfig {
///   @override
///   EnvironmentConfig? get environmentConfig => EnvironmentConfig(
///     envPath: '.env',
///     envOverridePaths: ['.env.local'],
///     mergeWithPlatformEnvironment: true,
///   );
/// }
/// ```
@immutable
class EnvironmentConfig {
  /// The primary environment file path.
  ///
  /// Defaults to '.env' in the project root.
  final String envPath;

  /// List of override environment files.
  ///
  /// These files are loaded in order after the primary file,
  /// with later files overriding values from earlier ones.
  ///
  /// Example: ['.env.local', '.env.development']
  final List<String> envOverridePaths;

  /// Whether to merge with Platform.environment variables.
  ///
  /// When true, system environment variables will be merged
  /// with loaded .env file variables.
  final bool mergeWithPlatformEnvironment;

  /// Whether to throw an error if the primary env file is missing.
  ///
  /// When false, missing files will be logged but not cause failures.
  /// Override files always fail silently.
  final bool failOnMissingEnvFile;

  /// Whether to enable debug logging for environment operations.
  final bool enableDebugLogging;

  /// Custom merge map to include additional environment variables.
  ///
  /// These values will be merged with loaded environment variables.
  final Map<String, String>? customMergeMap;

  const EnvironmentConfig({
    this.envPath = '.env',
    this.envOverridePaths = const [],
    this.mergeWithPlatformEnvironment = false,
    this.failOnMissingEnvFile = false,
    this.enableDebugLogging = true,
    this.customMergeMap,
  });

  /// Creates a development-specific configuration.
  ///
  /// Loads .env and .env.development files with debug logging enabled.
  factory EnvironmentConfig.development() {
    return const EnvironmentConfig(
      envPath: '.env',
      envOverridePaths: ['.env.development', '.env.local'],
      enableDebugLogging: true,
    );
  }

  /// Creates a production-specific configuration.
  ///
  /// Loads .env and .env.production files with debug logging disabled.
  factory EnvironmentConfig.production() {
    return const EnvironmentConfig(
      envPath: '.env',
      envOverridePaths: ['.env.production'],
      enableDebugLogging: false,
    );
  }

  /// Creates a test-specific configuration.
  ///
  /// Loads .env.test file for testing environments.
  factory EnvironmentConfig.test() {
    return const EnvironmentConfig(
      envPath: '.env.test',
      envOverridePaths: [],
      enableDebugLogging: false,
    );
  }

  /// Creates a configuration with platform environment merging enabled.
  factory EnvironmentConfig.withPlatformMerge({
    String envPath = '.env',
    List<String> envOverridePaths = const [],
  }) {
    return EnvironmentConfig(
      envPath: envPath,
      envOverridePaths: envOverridePaths,
      mergeWithPlatformEnvironment: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentConfig &&
        other.envPath == envPath &&
        listEquals(other.envOverridePaths, envOverridePaths) &&
        other.mergeWithPlatformEnvironment == mergeWithPlatformEnvironment &&
        other.failOnMissingEnvFile == failOnMissingEnvFile &&
        other.enableDebugLogging == enableDebugLogging &&
        mapEquals(other.customMergeMap, customMergeMap);
  }

  @override
  int get hashCode {
    return Object.hash(
      envPath,
      Object.hashAll(envOverridePaths),
      mergeWithPlatformEnvironment,
      failOnMissingEnvFile,
      enableDebugLogging,
      customMergeMap != null ? Object.hashAll(customMergeMap!.entries) : null,
    );
  }
}
