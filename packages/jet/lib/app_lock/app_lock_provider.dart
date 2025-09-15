import 'package:flutter/material.dart';
import 'package:guardo/guardo.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/storage/local_storage.dart';

class AppLockNotifier extends StateNotifier<bool> {
  AppLockNotifier() : super(false) {
    _load();
  }

  static const String _key = 'isLocked';

  void _load() {
    state = JetStorage.read(_key);
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
        onFailure: (e){
            context.showToast(e.toString());
        }
      );
    }
  }

final appLockProvider = StateNotifierProvider<AppLockNotifier, bool>(
  (ref) => AppLockNotifier(),
);
