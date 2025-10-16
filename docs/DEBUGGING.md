# Debugging Documentation

Complete guide to debugging tools in the Jet framework.

## Overview

Jet provides enhanced debugging tools for better development experience with stack trace formatting and comprehensive logging utilities. The debugging system is built on top of Dart's native debugging capabilities with enhanced visualization and filtering.

**Packages Used:**
- **stack_trace** - ^1.11.1 - [pub.dev](https://pub.dev/packages/stack_trace) - Enhanced stack trace parsing and formatting
- Dart SDK - Native debugging and logging support

**Key Benefits:**
- ✅ Enhanced stack trace formatting with clickable file paths
- ✅ Structured logging with tags and levels
- ✅ JSON serialization for complex objects
- ✅ Environment-aware logging (debug mode only by default)
- ✅ Colored console output for better visibility
- ✅ Customizable log levels and filtering
- ✅ Performance profiling support
- ✅ Integration with DevTools

## Stack Trace Debugging

Enhanced stack trace formatting with clickable file paths.

### Using dumpTrace

```dart
try {
  riskyOperation();
} catch (error, stackTrace) {
  // Dump stack trace with custom title
  dumpTrace(
    stackTrace,
    title: 'Operation Failed',
    alwaysPrint: true,
  );
}
```

### Using Stack Trace Extension

```dart
void problematicFunction() {
  try {
    complexOperation();
  } catch (error, stackTrace) {
    // Enhanced stack trace logging
    stackTrace.dump(title: 'Complex Operation Error');
    
    // Legacy logging (still supported)
    stackTrace.log(tag: 'Error');
  }
}
```

### Stack Trace Output Example

```
╔╣ JET STACK TRACE ╠══
╠══════════════
╠╣ [ 1 ] -> main.<anonymous closure> ╠══
╠ LINE [23] COLUMN [5]
╠ At example_test.dart
╠ "example_test.dart:23:5"
╚════════════════════════
```

## Enhanced Logging

Comprehensive logging utilities for debugging.

### Basic Logging

```dart
// Debug message
JetLogger.debug('Debug message');

// Info message
JetLogger.info('Information message');

// Error message
JetLogger.error('Error occurred');

// Warning message
JetLogger.warning('Warning message');
```

### Custom Tagged Logging

```dart
// Log with custom tag
JetLogger.dump('Custom data', tag: 'API_RESPONSE');
JetLogger.dump('User action', tag: 'USER_EVENT');
```

### JSON Logging

```dart
// Log JSON data
final userData = {'name': 'John', 'age': 30};
JetLogger.json(userData);

// Log complex objects
final response = {'status': 'success', 'data': {...}};
JetLogger.json(response, tag: 'API');
```

### Global Helpers

```dart
// Quick debug message
dump('Quick debug message', tag: 'DEBUG');

// Debug and die (exits after logging)
dd('Debug and die', tag: 'FATAL');
```

## Logging Features

- ✅ **Environment-aware logging** - Debug mode only by default
- ✅ **Structured output** - Timestamps and tags
- ✅ **JSON serialization** - For complex objects
- ✅ **Stack trace integration** - Clickable file paths
- ✅ **Customizable log levels** - Control verbosity
- ✅ **Colored output** - Visual distinction

## Best Practices

### 1. Use Appropriate Log Levels

```dart
// Good - use specific log levels
JetLogger.debug('Variable value: $value');
JetLogger.info('User logged in');
JetLogger.error('Failed to load data');
JetLogger.warning('API response slow');

// Avoid - using print everywhere
print('Some message');
```

### 2. Tag Your Logs

```dart
// Good - tagged logs
dump('API call started', tag: 'API');
dump('User clicked button', tag: 'UI');
dump('Database query: $query', tag: 'DB');

// Avoid - untagged logs
dump('Some message');
```

### 3. Log Errors with Stack Traces

```dart
// Good - include stack trace
try {
  await operation();
} catch (error, stackTrace) {
  JetLogger.error('Operation failed: $error');
  stackTrace.dump(title: 'Operation Error');
}

// Avoid - ignoring stack traces
try {
  await operation();
} catch (error) {
  dump('Error: $error');
}
```

### 4. Disable Logging in Production

```dart
// Good - conditional logging
if (kDebugMode) {
  dump('Debug info');
}

// JetLogger already handles this internally
JetLogger.debug('Only shown in debug mode');
```

## Network Logging

Configure network logging separately:

```dart
class AppConfig extends JetConfig {
  @override
  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig(
    request: true,
    requestHeader: true,
    requestBody: kDebugMode,
    responseBody: kDebugMode,
    error: true,
    enabled: kDebugMode,
  );
}
```

## See Also

- [Error Handling Documentation](ERROR_HANDLING.md)
- [Networking Documentation](NETWORKING.md)
- [Configuration Documentation](CONFIGURATION.md)

