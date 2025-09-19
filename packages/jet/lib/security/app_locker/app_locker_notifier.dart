import 'package:flutter/material.dart';
import 'package:guardo/guardo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet_flutter_framework/extensions/build_context.dart';
import 'package:jet_flutter_framework/storage/local_storage.dart';

class AppLockerNotifier extends Notifier<bool> {
  static const String _key = 'isLocked';

  @override
  bool build() {
    return JetStorage.read(_key) ?? false;
  }

  void toggle(BuildContext context, {bool forceLock = false}) {
    context.guardoActionWithResult(
      onSuccess: () async {
        state = !state;
        await JetStorage.write(_key, state);
        if (forceLock) {
          if (context.mounted) {
            context.lockApp();
          }
        }
      },
      onFailure: (e) {
        context.showToast(e.toString());
      },
    );
  }
}

final appLockProvider = NotifierProvider<AppLockerNotifier, bool>(
  AppLockerNotifier.new,
);
