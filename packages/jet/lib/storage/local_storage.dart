import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jet/helpers/jet_logger.dart';
import 'package:jet/session/session_manager.dart';
import 'package:jet/storage/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JetStorage {
  static final JetStorage _instance = JetStorage._();

  static const manager = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(),
  );

  factory JetStorage() => _instance;

  JetStorage._();

  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future write(String key, dynamic object) async {
    if (object is! Model) {
      await _prefs.setString(
        "${key}_runtime_type",
        object.runtimeType.toString(),
      );
      return await _prefs.setString(key, object.toString());
    }

    try {
      Map<String, dynamic> json = object.toJson();
      await _prefs.setString(key, jsonEncode(json));
    } catch (e, stackTrace) {
      dump(
        '[JetStorage.store] ${object.runtimeType.toString()} model needs to implement the toJson() method.',
        stackTrace: stackTrace,
      );
    }
  }
  static dynamic read<T>(
    String key, {
    T Function(Map<String, dynamic> json)? decoder,
    dynamic defaultValue,
  }) {
    String? data = _prefs.getString(key);

    String? runtimeType = _prefs.getString("${key}_runtime_type");

    if (data == null) {
      return defaultValue;
    }
    if (runtimeType != null && decoder == null) {
      switch (runtimeType.toLowerCase()) {
        case 'int':
          return int.parse(data);
        case 'double':
          return double.parse(data);
        case 'string':
          return data;
        case 'bool':
          return data == 'true';
        case 'json':
          try {
            return jsonDecode(data);
          } on Exception catch (e, stackTrace) {
            dump(e.toString(), stackTrace: stackTrace);
            return null;
          }
      }
    } else {
      if (T.toString() == "String") {
        return data.toString();
      }

      if (T.toString() == "int") {
        return int.parse(data.toString());
      }

      if (T.toString() == "double") {
        return double.parse(data);
      }

      if (_isInteger(data)) {
        return int.parse(data);
      }

      if (_isDouble(data)) {
        return double.parse(data);
      }
    }

    if (T.toString() != 'dynamic') {
      try {
        if (decoder != null) {
          return decoder(jsonDecode(data));
        }
        return jsonDecode(data);
      } on Exception catch (e, stackTrace) {
        dump(e.toString(), stackTrace: stackTrace);
        return null;
      }
    }
    return data;
  }

  static Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }

  static Future writeSecure(String key, dynamic object) async {
    await manager.write(key: key, value: object.toString());
  }

  static Future<dynamic> readSecure(String key) async {
    return await manager.read(key: key) ?? null;
  }

  static Future<void> deleteSecure(String key) async {
    await manager.delete(key: key);
  }

  static Future<void> clearSecure() async {
    await manager.deleteAll();
  }

  static Session? getSession() {
    return read<Session>(
      'session',
      decoder: (json) => Session.fromJson(json),
    );
  }

  static bool isLocked(){
    return read<bool>(
      'isLocked',
      defaultValue: false,
    );
  }
}

/// Checks if the value is an integer.
bool _isInteger(String? s) {
  if (s == null) {
    return false;
  }

  RegExp regExp = RegExp(
    r"^-?[0-9]+$",
    caseSensitive: false,
    multiLine: false,
  );

  return regExp.hasMatch(s);
}

/// Checks if the value is a double.
bool _isDouble(String? s) {
  if (s == null) {
    return false;
  }

  RegExp regExp = RegExp(
    r"^[0-9]{1,13}([.]?[0-9]*)?$",
    caseSensitive: false,
    multiLine: false,
  );

  return regExp.hasMatch(s);
}