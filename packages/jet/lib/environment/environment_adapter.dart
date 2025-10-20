import 'dart:io';

import 'package:jet/adapters/jet_adapter.dart';
import 'package:jet/environment/jet_env.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/jet.dart';

/// Adapter for initializing environment variables during app boot.
///
/// This adapter reads the environment configuration from JetConfig
/// and initializes JetEnv with the specified settings.
///
/// The adapter is automatically included in the default adapters list,
/// so you don't need to manually add it unless you want to customize
/// the initialization order.
///
/// Example usage:
/// ```dart
/// class AppConfig extends JetConfig {
///   @override
///   EnvironmentConfig? get environmentConfig => EnvironmentConfig(
///     envPath: '.env',
///     envOverridePaths: ['.env.local'],
///   );
/// }
/// ```
class EnvironmentAdapter extends JetAdapter {
  @override
  Future<Jet?> boot(Jet jet) async {
    try {
      final config = jet.config.environmentConfig;

      // Skip initialization if no config is provided
      if (config == null) {
        JetLogger.debug(
          'EnvironmentAdapter: No environment configuration provided, skipping initialization',
        );
        return jet;
      }

      // Build merge map
      Map<String, String>? mergeMap;
      if (config.mergeWithPlatformEnvironment ||
          config.customMergeMap != null) {
        mergeMap = {};

        // Add platform environment if requested
        if (config.mergeWithPlatformEnvironment) {
          mergeMap.addAll(Platform.environment);
        }

        // Add custom merge map if provided
        if (config.customMergeMap != null) {
          mergeMap.addAll(config.customMergeMap!);
        }
      }

      // Initialize JetEnv
      try {
        await JetEnv.init(
          fileName: config.envPath,
          overrideFiles: config.envOverridePaths,
          mergeWith: mergeMap,
        );

        if (config.enableDebugLogging) {
          JetLogger.debug(
            'EnvironmentAdapter: Successfully loaded environment from ${config.envPath}',
          );

          if (config.envOverridePaths.isNotEmpty) {
            JetLogger.debug(
              'EnvironmentAdapter: Applied overrides from ${config.envOverridePaths.join(', ')}',
            );
          }
        }
      } catch (e) {
        if (config.failOnMissingEnvFile) {
          throw Exception(
            'EnvironmentAdapter: Failed to load required environment file ${config.envPath}: $e',
          );
        } else {
          JetLogger.error(
            'EnvironmentAdapter: Failed to load environment file ${config.envPath}: $e',
          );
        }
      }

      return jet;
    } catch (e) {
      JetLogger.error(
        'EnvironmentAdapter: Failed to initialize environment: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> afterBoot(Jet jet) async {
    // Optional: Log loaded environment variables in debug mode
    final config = jet.config.environmentConfig;
    if (config?.enableDebugLogging == true) {
      final envCount = JetEnv.all.length;
      JetLogger.debug(
        'EnvironmentAdapter: Loaded $envCount environment variables',
      );
    }
  }
}
