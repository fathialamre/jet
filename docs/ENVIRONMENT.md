# Environment Configuration Documentation

Complete guide to managing environment variables in Jet applications using JetEnv.

## Overview

JetEnv is a powerful environment configuration wrapper around flutter_dotenv that provides type-safe static methods to access environment variables. It's integrated into the Jet framework using the adapter pattern for seamless initialization.

**Architecture:**
- **Adapter Pattern** - Automatic initialization during app boot
- **Type-Safe Access** - Strongly typed getters with default values
- **Configuration-Based** - Centralized config via EnvironmentConfig class
- **Multi-File Support** - Base + override files for different environments

**Key Benefits:**
- ✅ Type-safe access to environment variables
- ✅ Support for multiple environment files with overrides
- ✅ Default values for missing keys
- ✅ Graceful error handling
- ✅ Hot reload support
- ✅ Platform environment merging
- ✅ Test-friendly with string loading

## Basic Usage

### 1. Configure Environment in JetConfig

Add environment configuration to your app's JetConfig:

```dart
class AppConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig(
    envPath: '.env',
    envOverridePaths: ['.env.local'],
    mergeWithPlatformEnvironment: false,
  );
  
  // Other config properties...
}
```

### 2. Create .env File

Create a `.env` file in your project root (same directory as `pubspec.yaml`):

```bash
# API Configuration
API_URL=https://api.example.com
API_TIMEOUT=30
API_KEY=your_secret_key_here

# Feature Flags
ENABLE_DEBUG=true
ENABLE_ANALYTICS=false
MAX_RETRIES=3

# Numeric Values
MAX_FILE_SIZE=10.5
CACHE_DURATION=3600
```

### 3. Access Environment Variables

```dart
import 'package:jet/jet_framework.dart';

// Get string values
final apiUrl = JetEnv.getString('API_URL', defaultValue: 'http://localhost');

// Get integer values
final timeout = JetEnv.getInt('API_TIMEOUT', defaultValue: 30);

// Get boolean values
final debugMode = JetEnv.getBool('ENABLE_DEBUG', defaultValue: false);

// Get double values
final maxSize = JetEnv.getDouble('MAX_FILE_SIZE', defaultValue: 5.0);

// Get raw value (returns String?)
final apiKey = JetEnv.get('API_KEY');

// Check if key exists
if (JetEnv.has('API_KEY')) {
  // Use the API key
}
```

## Advanced Usage

### Environment Configuration Options

The `EnvironmentConfig` class provides various options:

```dart
class AppConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig(
    envPath: '.env',                          // Primary env file
    envOverridePaths: ['.env.local'],         // Override files
    mergeWithPlatformEnvironment: true,       // Merge with system env
    failOnMissingEnvFile: false,              // Fail if .env missing
    enableDebugLogging: true,                 // Enable debug logs
    customMergeMap: {'CUSTOM': 'value'},      // Additional vars
  );
}
```

### Manual Initialization

While the EnvironmentAdapter handles initialization automatically, you can also initialize manually:

```dart
// Initialize with custom settings
await JetEnv.init(
  fileName: 'config/production.env',
  overrideFiles: ['.env.local'],
  mergeWith: {'CUSTOM_VAR': 'value'},
);

// Reload environment (useful for testing)
await JetEnv.reload(
  fileName: '.env.test',
);
```

### Environment-Specific Configuration

Use factory constructors for different environments:

```dart
class AppConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig {
    if (kDebugMode) {
      return EnvironmentConfig.development();
    } else {
      return EnvironmentConfig.production();
    }
  }
}
```

Or use the pre-built factory constructors:

```dart
// Development environment
EnvironmentConfig.development()
// Loads: .env, .env.development, .env.local

// Production environment
EnvironmentConfig.production()
// Loads: .env, .env.production

// Test environment
EnvironmentConfig.test()
// Loads: .env.test

// With platform merge
EnvironmentConfig.withPlatformMerge(
  envPath: '.env',
  envOverridePaths: ['.env.staging'],
)
```

### Using with Network Services

```dart
class ApiService extends JetApiService {
  ApiService(super.ref);

  @override
  String get baseUrl => JetEnv.getString('API_URL');

  @override
  Duration get connectTimeout => Duration(
    seconds: JetEnv.getInt('API_TIMEOUT', defaultValue: 30),
  );

  @override
  List<Interceptor> get interceptors {
    final interceptors = <Interceptor>[];
    
    // Add API key if available
    if (JetEnv.has('API_KEY')) {
      interceptors.add(BearerTokenInterceptor(
        token: JetEnv.getString('API_KEY'),
      ));
    }
    
    return interceptors;
  }
}
```

### Configuration Class Pattern

Create a centralized configuration class:

```dart
class AppEnvironment {
  // API Configuration
  static String get apiUrl => JetEnv.getString('API_URL');
  static String get apiKey => JetEnv.getString('API_KEY', defaultValue: '');
  static int get apiTimeout => JetEnv.getInt('API_TIMEOUT', defaultValue: 30);
  
  // Feature Flags
  static bool get debugEnabled => JetEnv.getBool('ENABLE_DEBUG');
  static bool get analyticsEnabled => JetEnv.getBool('ENABLE_ANALYTICS', defaultValue: true);
  
  // App Settings
  static String get appVersion => JetEnv.getString('APP_VERSION', defaultValue: '1.0.0');
  static int get cacheMaxAge => JetEnv.getInt('CACHE_MAX_AGE', defaultValue: 3600);
  
  // Computed Properties
  static bool get isProduction => !debugEnabled;
  static bool get shouldCache => cacheMaxAge > 0;
}
```

## Type Conversion

JetEnv automatically converts string values to the requested type:

### Boolean Conversion
- `true`, `TRUE`, `True` → `true`
- `false`, `FALSE`, `False` → `false`
- `1` → `true`
- `0` → `false`
- Any other value returns the default

### Numeric Conversion
- Valid integers and doubles are parsed correctly
- Invalid values return the default
- Error messages are printed to console in debug mode

## Best Practices

### 1. Use Default Values

Always provide sensible defaults for optional configuration:

```dart
// Good
final timeout = JetEnv.getInt('TIMEOUT', defaultValue: 30);

// Risky - returns 0 if not found
final timeout = JetEnv.getInt('TIMEOUT');
```

### 2. Check Required Keys

For required configuration, check existence and fail fast:

```dart
void validateEnvironment() {
  final requiredKeys = ['API_KEY', 'DATABASE_URL', 'SECRET_KEY'];
  
  for (final key in requiredKeys) {
    if (!JetEnv.has(key)) {
      throw Exception('Required environment variable $key is not set');
    }
  }
}
```

### 3. Don't Commit .env Files

Add `.env` files to `.gitignore`:

```gitignore
# Environment files
.env
.env.local
.env.production
.env.development
```

Create an example file for reference:

```bash
# Create env.example with dummy values
cp .env env.example
# Edit env.example to replace secrets with placeholders
```

### 4. Document Environment Variables

Keep a list of all environment variables your app uses:

```markdown
## Required Environment Variables

- `API_URL` - Base URL for the API
- `API_KEY` - Authentication key for API access

## Optional Environment Variables

- `ENABLE_DEBUG` - Enable debug mode (default: false)
- `CACHE_DURATION` - Cache duration in seconds (default: 3600)
```

## Complete Example

```dart
// 1. Define your configuration
class AppConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig(
    envPath: '.env',
    envOverridePaths: ['.env.local'],
    mergeWithPlatformEnvironment: false,
  );

  @override
  List<JetAdapter> get adapters => [
    // EnvironmentAdapter is included by default
    // Your other adapters...
  ];
}

// 2. In your main.dart
void main() async {
  final jet = await Boot.start(AppConfig());
  await Boot.finished(jet, AppConfig());
}

// 3. Use environment variables anywhere
class ApiService {
  final String baseUrl = JetEnv.getString('API_URL');
  final int timeout = JetEnv.getInt('API_TIMEOUT', defaultValue: 30);
  final bool debugMode = JetEnv.getBool('DEBUG_MODE');
}
```

## Error Handling

JetEnv and EnvironmentAdapter handle errors gracefully:

- **Missing .env file**: Logs warning, continues with defaults (unless `failOnMissingEnvFile` is true)
- **Invalid type conversion**: Returns default value, logs debug message
- **Override file errors**: Silently fails, logs debug message
- **File read errors**: Catches exceptions, logs error
- **Required variables**: Use `JetEnv.require()` to throw if a variable is missing

## Performance Considerations

- **Boot-Time Loading**: Environment is loaded once during app initialization via adapter
- **Cached Values**: flutter_dotenv stores parsed values in memory
- **Synchronous Access**: No async overhead when reading values after initialization
- **Minimal Memory**: Only stores key-value pairs as strings
- **Override Efficiency**: Override files are loaded sequentially, later values replace earlier ones

## Testing

Mock environment values in tests:

```dart
// Option 1: Load from string
setUpAll(() {
  JetEnv.loadFromString(input: '''
API_URL=http://localhost:8080
ENABLE_DEBUG=true
API_KEY=test_key_123
  ''');
});

// Option 2: Use test configuration
class TestConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig.test();
  
  // Other test config...
}

// Option 3: Manual initialization with test file
setUpAll(() async {
  await JetEnv.init(
    fileName: '.env.test',
    mergeWith: {
      'TEST_MODE': 'true',
      'API_URL': 'http://localhost:8080',
    },
  );
});

// In your tests
test('API service uses correct URL', () {
  expect(JetEnv.getString('API_URL'), equals('http://localhost:8080'));
});
```

## Working with the Adapter

The EnvironmentAdapter is automatically included in the default adapters and initializes during app boot:

```dart
class AppConfig extends JetConfig {
  @override
  EnvironmentConfig? get environmentConfig => EnvironmentConfig(
    envPath: '.env',
    envOverridePaths: ['.env.local'],
  );
  
  @override
  List<JetAdapter> get adapters => [
    // EnvironmentAdapter is included by default
    // Add your custom adapters here
  ];
}
```

### Adapter Initialization Order

1. StorageAdapter (initializes secure storage)
2. EnvironmentAdapter (loads environment variables)
3. Your custom adapters

This ensures environment variables are available to all subsequent adapters.

## Migration from flutter_dotenv

JetEnv wraps flutter_dotenv, so migration is straightforward:

```dart
// Direct flutter_dotenv usage
await dotenv.load();
final apiUrl = dotenv.env['API_URL'] ?? '';

// With JetEnv (automatic initialization via adapter)
final apiUrl = JetEnv.getString('API_URL', defaultValue: '');
```

## Troubleshooting

### Environment variables not loading

1. Check file location - should be in project root
2. Verify file name - default is `.env`
3. Check file permissions
4. Look for console error messages

### Type conversion failing

1. Check the value format in .env file
2. Ensure no extra quotes or spaces
3. Use appropriate getter method
4. Provide sensible defaults

### Changes not reflecting

1. Hot reload may not reload .env files
2. Call `JetEnv.reload()` after changes
3. Restart the app for production builds

## See Also

- [Configuration Documentation](CONFIGURATION.md) - App configuration with JetConfig
- [Adapters Documentation](ADAPTERS.md) - Understanding the adapter pattern in Jet
- [Networking Documentation](NETWORKING.md) - Using environment variables with API services
- [Security Documentation](SECURITY.md) - Best practices for handling secrets
- [flutter_dotenv Package](https://pub.dev/packages/flutter_dotenv) - The underlying package used by JetEnv
