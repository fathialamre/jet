import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isDebugMode => kDebugMode;

bool get isProductionMode => kReleaseMode;

bool get isDevelopmentMode => kDebugMode;

bool get isIos => Platform.isIOS;

bool get isAndroid => Platform.isAndroid;

bool get isWindows => Platform.isWindows;

bool get isLinux => Platform.isLinux;

bool get isMacOS => Platform.isMacOS;
