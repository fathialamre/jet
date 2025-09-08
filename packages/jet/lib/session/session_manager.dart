import 'package:jet/storage/local_storage.dart';
import 'package:jet/storage/model.dart';

class SessionManager {
  static Future<void> authenticate() async {}

  static Future<Session?> session() async {
    final result = await JetStorage.read<Session>(
      'session',
      decoder: (json) => Session.fromJson(json),
    );
    return result;
  }

  static Future<void> clear() async {
    await JetStorage.delete('session');
  }

  static Future<String?> token() async {
    final result = await session();
    return result?.token;
  }

  static Future<bool?> isGuest() async {
    final result = await session();
    return result?.isGuest ?? false;
  }

  static Future<bool> authenticateAsGuest({required Session session}) async {
    try {
      await JetStorage.write(
        'session',
        session,
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> authenticateAsUser({
    required Session session,
  }) async {
    try {
      await JetStorage.write(
        'session',
        session,
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

class Session implements Model {
  final String token;
  final String name;
  final bool isGuest;
  final String? phone;

  Session({
    required this.token,
    required this.name,
    required this.isGuest,
    this.phone,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'token': token, 'name': name, 'is_guest': isGuest, 'phone': phone};
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      name: json['name'],
      isGuest: json['is_guest'],
      phone: json['phone'],
    );
  }
}
