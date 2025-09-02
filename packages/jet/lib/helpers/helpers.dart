import 'package:flutter/foundation.dart';

bool get isDebugMode => kDebugMode;

extension JetSleepExtensions on int {
  Future<void> sleep() async {
    await Future.delayed(Duration(seconds: this));
  }
}
