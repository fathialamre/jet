import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// A logger utility for structured and environment-aware logging.
class JetLogger {
  /// Logs a debug [message] to the console.
  ///
  /// Only logs in debug mode unless [alwaysPrint] is set to `true`.
  static void debug(dynamic message, {bool alwaysPrint = false}) {
    _log(message, type: 'debug', alwaysPrint: alwaysPrint);
  }

  /// Logs an error [message] to the console.
  ///
  /// Only logs in debug mode unless [alwaysPrint] is set to `true`.
  static void error(dynamic message, {bool alwaysPrint = false}) {
    final errorMessage = message is Exception ? message.toString() : message;
    _log(errorMessage, type: 'error', alwaysPrint: alwaysPrint);
  }

  /// Logs an informational [message] to the console.
  ///
  /// Only logs in debug mode unless [alwaysPrint] is set to `true`.
  static void info(dynamic message, {bool alwaysPrint = false}) {
    _log(message, type: 'info', alwaysPrint: alwaysPrint);
  }

  /// Logs a [message] with a custom [tag].
  ///
  /// Only logs in debug mode unless [alwaysPrint] is set to `true`.
  static void dump(
    dynamic message, {
    String? tag,
    bool alwaysPrint = false,
  }) {
    _log(message, type: tag, alwaysPrint: alwaysPrint);
  }

  /// Logs JSON [message] to the console.
  ///
  /// If the message is not JSON-serializable, logs an error instead.
  /// Only logs in debug mode unless [alwaysPrint] is set to `true`.
  static void json(dynamic message, {bool alwaysPrint = false}) {
    if (!_canLog(alwaysPrint)) return;
    try {
      final jsonString = jsonEncode(message);
      log(jsonString);
    } catch (e) {
      error('Failed to log JSON: $e');
    }
  }

  /// Core logging method that handles message formatting and output.
  ///
  /// - [message]: The content to log.
  /// - [type]: Optional tag or type of the log (e.g., debug, error).
  /// - [alwaysPrint]: Forces logging regardless of the environment.
  static void _log(dynamic message, {String? type, bool alwaysPrint = false}) {
    if (!_canLog(alwaysPrint)) return;

    final formattedMessage = _formatMessage(message, type);
    _outputLog(formattedMessage);
  }

  /// Determines whether logging is allowed based on the app environment.
  static bool _canLog(bool alwaysPrint) {
    return true;
    // return alwaysPrint || getEnv('APP_DEBUG', fallback: false);
  }

  /// Formats the log message with the specified [type].
  static String _formatMessage(dynamic message, String? type) {
    final typePrefix = type != null ? '[$type] ' : '';
    return '$typePrefix$message';
  }

  /// Outputs the log to the console or developer tools.
  ///
  /// If in debug mode, uses `print` for short messages and `log` for long messages.
  static void _outputLog(String message) {
    if (kDebugMode) {
      if (message.length > 800) {
        log(message);
      } else {
        print(message);
      }
    }
  }

  /// Dumps a stack trace in a human-readable format with minimal emojis.
  ///
  /// Parses the stack trace and displays it with clickable file paths
  /// to make debugging easier and more efficient.
  static void dumpTrace(
    StackTrace stackTrace, {
    String? title,
    bool alwaysPrint = false,
  }) {
    if (!_canLog(alwaysPrint)) return;

    final traceTitle = title ?? 'JET STACK TRACE';
    _log('╔╣ $traceTitle ╠══');
    _log('╠══════════════');

    final lines = stackTrace.toString().split('\n');
    int frameNumber = 1;

    for (final line in lines) {
      if (line.trim().isEmpty) continue;

      // Parse stack trace line
      final parsedFrame = _parseStackTraceLine(line.trim());
      if (parsedFrame != null) {
        // Extract file name from full path
        final fileName = _extractFileName(parsedFrame['file']);

        // Create clickable file path
        final fileUrl = _formatClickableFilePath(
          parsedFrame['file'],
          parsedFrame['line'],
          parsedFrame['column'],
        );

        // Display frame in the requested format
        _log('╠╣ [ $frameNumber ] -> ${parsedFrame['method']} ╠══');
        _log(
          '╠ LINE [${parsedFrame['line'] ?? 'N/A'}] COLUMN [${parsedFrame['column'] ?? 'N/A'}]',
        );
        _log('╠ At ${fileName ?? 'unknown'}');
        _log('╠ "${fileUrl ?? 'N/A'}"');
        _log('╚════════════════════════');

        frameNumber++;
      } else {
        // If we can't parse it, show it as raw
        _log('╠╣ [ $frameNumber ] -> Unparsed Frame ╠══');
        _log('╠ $line');
        _log('╚════════════════════════');
        frameNumber++;
      }
    }

    _log('');
  }

  /// Extracts just the file name from a full file path.
  static String? _extractFileName(String? filePath) {
    if (filePath == null) return null;

    // Handle package: paths and regular file paths
    final segments = filePath.split('/');
    return segments.isNotEmpty ? segments.last : filePath;
  }

  /// Formats a clickable file path for IDE integration.
  static String? _formatClickableFilePath(
    String? file,
    String? line,
    String? column,
  ) {
    if (file == null) return null;

    final lineStr = line ?? '1';
    final columnStr = column ?? '1';

    // Format: file.dart:line:column for IDE clickability
    return '$file:$lineStr:$columnStr';
  }

  /// Parses a single stack trace line to extract method, file, line, and column information.
  static Map<String, String?>? _parseStackTraceLine(String line) {
    // Common patterns for Dart stack traces:
    // #0      method (file:line:column)
    // #0      method (package:package_name/file.dart:line:column)

    final regex = RegExp(r'#\d+\s+(.+?)\s+\((.+?):(\d+):(\d+)\)');
    final match = regex.firstMatch(line);

    if (match != null) {
      return {
        'method': match.group(1)?.trim(),
        'file': match.group(2)?.trim(),
        'line': match.group(3)?.trim(),
        'column': match.group(4)?.trim(),
      };
    }

    // Try alternative pattern: method (file:line)
    final altRegex = RegExp(r'#\d+\s+(.+?)\s+\((.+?):(\d+)\)');
    final altMatch = altRegex.firstMatch(line);

    if (altMatch != null) {
      return {
        'method': altMatch.group(1)?.trim(),
        'file': altMatch.group(2)?.trim(),
        'line': altMatch.group(3)?.trim(),
        'column': null,
      };
    }

    return null;
  }

  static void logWithBrackets(
    dynamic title,
    dynamic message,
    dynamic details, {
    bool alwaysPrint = false,
    StackTrace? stackTrace,
  }) {
    _log('╔══════╣ $title ╠═');
    _log('║ $message ');
    if (details != '') {
      _log('║ $details ');
    }
    if (stackTrace != null) {
      dumpTrace(
        stackTrace,
        title: 'Error Stack Trace',
        alwaysPrint: alwaysPrint,
      );
    }
    _log('╚═══════ ');
  }
}

dd(dynamic value, {String? tag, bool alwaysPrint = false}) {
  JetLogger.logWithBrackets(
    tag,
    value,
    '',
    alwaysPrint: alwaysPrint,
  );
  exit(0);
}

void dump(
  dynamic message, {
  dynamic details,
  String? tag,
  bool alwaysPrint = false,
  StackTrace? stackTrace,
}) {
  JetLogger.logWithBrackets(
    tag ?? 'Dump',
    message,
    details ?? '',
    alwaysPrint: alwaysPrint,
    stackTrace: stackTrace,
  );
}

/// Global function to dump a stack trace with human-readable format and emojis.
void dumpTrace(
  StackTrace stackTrace, {
  String? title,
  bool alwaysPrint = false,
}) {
  JetLogger.dumpTrace(stackTrace, title: title, alwaysPrint: alwaysPrint);
}

extension StackTraceExt on StackTrace {
  /// Logs the stack trace using the new human-readable format with emojis.
  void dump({String? title, bool alwaysPrint = false}) {
    JetLogger.dumpTrace(this, title: title, alwaysPrint: alwaysPrint);
  }

  /// Legacy method for backwards compatibility.
  void log({String? tag, bool alwaysPrint = false}) {
    JetLogger.dumpTrace(
      this,
      title: tag ?? 'StackTrace',
      alwaysPrint: alwaysPrint,
    );
  }
}
