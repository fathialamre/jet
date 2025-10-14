import 'package:jet/jet_framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_notifier.g.dart';

@riverpod
UserNotifier userNotifier(Ref ref, String userId) => UserNotifier(userId: userId);

class UserNotifier extends Notifier<String> {
  final String userId;

  UserNotifier({required this.userId});

  @override
  String build() {
    return userId;
  }
}