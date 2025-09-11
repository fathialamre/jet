import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/storage/local_storage.dart';

class AppLockNotifier extends Notifier<bool>{

  bool get isLocked => state;

  static const String _key = 'isLocked';

  @override
  bool build() {
    _load();
   return false;
  }

  Future<void> _load() async{
    final isLocked = await JetStorage.read(_key);
    state = isLocked;
  }

  Future<void> toggle() async {
    final newValue = !state;
    state = newValue;


    await JetStorage.write(_key, newValue);
  }

  Future<void> setLock(bool enabled) async {
    state = enabled;

    await JetStorage.write(_key, enabled);
  }

}

final appLockProvider = NotifierProvider<AppLockNotifier, bool>(() => AppLockNotifier());
