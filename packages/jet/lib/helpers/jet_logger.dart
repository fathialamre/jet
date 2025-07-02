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
      dump(stackTrace);
      _log('╠══════╣ Error Files ╠═══');
      // final lines = stackTrace.toString().split('\n');
      // for (final line in lines) {
      //   if (line.trim().isNotEmpty) {
      //     _log('║ $line');
      //   }
      // }
      _log('╚═══════ ');
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

dump(
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

extension StackTraceExt on StackTrace {
  void log({String? tag, bool alwaysPrint = false}) {
    JetLogger.logWithBrackets(
      tag ?? 'StackTrace',
      toString(), // Ensure StackTrace is converted to a string
      '',
      alwaysPrint: alwaysPrint,
    );
  }
}
