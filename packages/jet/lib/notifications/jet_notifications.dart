import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'events/jet_notification_event_registry.dart';
import 'observers/jet_notification_observer.dart';
import 'models/notification_response_wrapper.dart';

/// Download and save a file
Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/$fileName';

  final Dio dio = Dio();
  final Response<List<int>> response = await dio.get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  if (response.data == null) {
    throw Exception("Failed to download file");
  }

  final File file = File(filePath);
  await file.writeAsBytes(response.data!);
  return filePath;
}

/// Push Notification Attachments
class _JetNotificationAttachments {
  final String url;
  final String fileName;
  final bool? showThumbnail;

  _JetNotificationAttachments(
    this.url,
    this.fileName, {
    this.showThumbnail = true,
  });
}

/// Jet Notifications - A comprehensive local notifications system
class JetNotifications {
  int? _id;
  final String _title;
  final String _body;
  String? _payload;
  String? _subtitle;
  final List<_JetNotificationAttachments> _attachments = [];
  DateTime? _sendAt;

  // iOS
  bool? _presentList;
  bool? _presentAlert;
  bool? _presentBadge;
  bool? _presentSound;
  bool? _presentBanner;
  String? _sound;
  int? _badgeNumber;
  String? _threadIdentifier;
  String? _categoryIdentifier;
  InterruptionLevel? _interruptionLevel;

  // Android
  String? _channelId;
  String? _channelName;
  String? _channelDescription;
  Importance? _importance;
  Priority? _priority;
  String? _ticker;
  String? _icon;
  bool? _playSound;
  bool? _enableVibration;
  List<int>? _vibrationPattern;
  String? _groupKey;
  bool? _setAsGroupSummary;
  GroupAlertBehavior? _groupAlertBehavior;
  bool? _autoCancel;
  bool? _ongoing;
  bool? _silent;
  Color? _color;
  String? _largeIcon;
  bool? _onlyAlertOnce;
  bool? _showWhen;
  int? _when;
  bool? _usesChronometer;
  bool? _chronometerCountDown;
  bool? _channelShowBadge;
  bool? _showProgress;
  int? _maxProgress;
  int? _progress;
  bool? _indeterminate;
  AndroidNotificationChannelAction? _channelAction;
  bool? _enableLights;
  Color? _ledColor;
  int? _ledOnMs;
  int? _ledOffMs;
  NotificationVisibility? _visibility;
  int? _timeoutAfter;
  bool? _fullScreenIntent;
  String? _shortcutId;
  List<int>? _additionalFlags;
  String? _tag;
  List<AndroidNotificationAction>? _actions;
  bool? _colorized;
  AudioAttributesUsage? _audioAttributesUsage;

  // Static instance for singleton pattern
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Static field to track initialization status
  static bool _isInitialized = false;

  // Static observer instance
  static JetNotificationObserver? _observer;

  JetNotifications({String title = "", String body = ""})
    : _title = title,
      _body = body;

  /// Check if JetNotifications is initialized
  static bool get isInitialized => _isInitialized;

  /// Set the notification observer
  static void setObserver(JetNotificationObserver observer) {
    _observer = observer;
  }

  /// Get the current notification observer
  static JetNotificationObserver? get observer => _observer;

  /// Initialize the local notifications plugin
  static Future<bool> initialize() async {
    if (kIsWeb) {
      _observer?.onInitialization(
        message: "Local notifications are not supported on the web",
      );
      return false;
    }

    // Initialize timezone data
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    try {
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );

      _isInitialized = true;
      _observer?.onInitialization(
        message: "Jet Notifications initialized successfully",
      );

      return true;
    } catch (e) {
      _observer?.onInitializationError(
        message: "Failed to initialize local notifications: $e",
        error: e,
      );
      _isInitialized = false;
      return false;
    }
  }

  /// Handle notification response when app is in foreground
  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    _observer!.onResponse(response: response);

    try {
      final wrapper = NotificationResponseWrapper(response);
      final event = JetNotificationEventRegistry.findHandler(response);

      if (event != null) {
        _observer!.onEventHandlerFound(
          eventName: event.name,
          notificationId: response.id ?? 0,
          response: response,
        );

        if (wrapper.isAction) {
          // Handle action button press
          event.onAction(response, wrapper.actionId!);
        } else {
          // Handle notification tap
          event.onTap(response);
        }
      } else {
        _observer!.onNoEventHandler(
          notificationId: response.id ?? 0,
          response: response,
        );
      }
    } catch (e) {
      _observer!.onError(
        message: "NOTIFICATION: Error handling notification response: $e",
        error: e,
      );
    }
  }

  /// Handle notification response when app is in background
  static void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse response,
  ) {
    _observer!.onBackgroundResponse(
      response: response,
    );

    try {
      final wrapper = NotificationResponseWrapper(response);
      final event = JetNotificationEventRegistry.findHandler(response);

      if (event != null) {
        _observer!.onBackgroundEventHandlerFound(
          eventName: event.name,
          notificationId: response.id ?? 0,
          response: response,
        );

        if (wrapper.isAction) {
          // Handle action button press
          event.onAction(response, wrapper.actionId!);
        } else {
          // Handle notification tap
          event.onTap(response);
        }
      } else {
        _observer!.onNoBackgroundEventHandler(
          notificationId: response.id ?? 0,
          response: response,
        );
      }
    } catch (e) {
      _observer!.onBackgroundError(
        message:
            "NOTIFICATION: Error handling background notification response: $e",
        error: e,
      );
    }
  }

  /// Trigger onReceive event for notifications
  static void _triggerOnReceiveEvent(int id, String? payload) {
    _observer!.onReceive(
      notificationId: id,
      payload: payload,
    );

    try {
      // Create a NotificationResponse for the onReceive event
      final response = NotificationResponse(
        id: id,
        actionId: null,
        input: null,
        payload: payload,
        notificationResponseType: NotificationResponseType.selectedNotification,
      );

      final event = JetNotificationEventRegistry.findHandler(response);

      if (event != null) {
        _observer!.onReceiveHandlerFound(
          eventName: event.name,
          notificationId: id,
          payload: payload,
        );

        // Call the onReceive method
        event.onReceive(response);

        _observer!.onReceiveCompleted(
          notificationId: id,
          payload: payload,
        );
      } else {
        _observer!.onNoReceiveHandler(
          notificationId: id,
          payload: payload,
        );
      }
    } catch (e) {
      _observer!.onReceiveError(
        message: "❌ NOTIFICATION: Error triggering onReceive event: $e",
        error: e,
        notificationId: id,
        payload: payload,
      );
    }
  }

  /// Send a notification
  /// Example:
  /// ```dart
  /// JetNotifications.sendNotification(
  ///  title: "Hello",
  ///  body: "World",
  ///  );
  ///  ```
  ///  This will send a notification with the title "Hello" and the body "World"
  static Future<void> sendNotification({
    required String title,
    required String body,
    String? payload,
    DateTime? at,
    int? id,
    String? subtitle,
    int? badgeNumber,
    String? sound,
    String? channelId,
    String? channelName,
    String? channelDescription,
    Importance? importance,
    Priority? priority,
    String? ticker,
    String? icon,
    bool? playSound,
    bool? enableVibration,
    List<int>? vibrationPattern,
    String? groupKey,
    bool? setAsGroupSummary,
    GroupAlertBehavior? groupAlertBehavior,
    bool? autoCancel,
    bool? ongoing,
    bool? silent,
    Color? color,
    String? largeIcon,
    bool? onlyAlertOnce,
    bool? showWhen,
    int? when,
    bool? usesChronometer,
    bool? chronometerCountDown,
    bool? channelShowBadge,
    bool? showProgress,
    int? maxProgress,
    int? progress,
    bool? indeterminate,
    AndroidNotificationChannelAction? channelAction,
    bool? enableLights,
    Color? ledColor,
    int? ledOnMs,
    int? ledOffMs,
    NotificationVisibility? visibility,
    int? timeoutAfter,
    bool? fullScreenIntent,
    String? shortcutId,
    List<int>? additionalFlags,
    String? tag,
    List<AndroidNotificationAction>? actions,
    bool? colorized,
    AudioAttributesUsage? audioAttributesUsage,
    bool? presentList,
    bool? presentAlert,
    bool? presentBadge,
    bool? presentSound,
    bool? presentBanner,
    String? threadIdentifier,
    String? categoryIdentifier,
    InterruptionLevel? interruptionLevel,
    AndroidScheduleMode? androidScheduleMode,
  }) async {
    JetNotifications jetNotification = JetNotifications(
      title: title,
      body: body,
    );

    if (kIsWeb) {
      throw Exception("Push notifications are not supported on the web");
    }

    if (Platform.isAndroid) {
      if (channelId == null) {
        jetNotification.addChannelId("default_channel");
      }
      if (channelName == null) {
        jetNotification.addChannelName("Default Channel");
      }
      if (channelDescription == null) {
        jetNotification.addChannelDescription("Default Channel");
      }
      if (importance == null) {
        jetNotification.addImportance(Importance.max);
      }
      if (priority == null) {
        jetNotification.addPriority(Priority.high);
      }
      if (ticker == null) {
        jetNotification.addTicker("ticker");
      }
      if (icon == null) {
        jetNotification.addIcon("@mipmap/ic_launcher");
      }
      if (playSound == null) {
        jetNotification.addPlaySound(true);
      }
      if (enableVibration == null) {
        jetNotification.addEnableVibration(true);
      }
      if (groupAlertBehavior == null) {
        jetNotification.addGroupAlertBehavior(GroupAlertBehavior.all);
      }
      if (autoCancel == null) {
        jetNotification.addAutoCancel(true);
      }
      if (showWhen == null) {
        jetNotification.addShowWhen(true);
      }
      if (channelShowBadge == null) {
        jetNotification.addChannelShowBadge(true);
      }
    }

    if (payload != null) {
      jetNotification.addPayload(payload);
    }
    if (id != null) {
      jetNotification.addId(id);
    }
    if (subtitle != null) {
      jetNotification.addSubtitle(subtitle);
    }
    if (badgeNumber != null) {
      jetNotification.addBadgeNumber(badgeNumber);
    }
    if (sound != null) {
      jetNotification.addSound(sound);
    }
    if (channelId != null) {
      jetNotification.addChannelId(channelId);
    }
    if (channelName != null) {
      jetNotification.addChannelName(channelName);
    }
    if (channelDescription != null) {
      jetNotification.addChannelDescription(channelDescription);
    }
    if (importance != null) {
      jetNotification.addImportance(importance);
    }
    if (priority != null) {
      jetNotification.addPriority(priority);
    }
    if (ticker != null) {
      jetNotification.addTicker(ticker);
    }
    if (icon != null) {
      jetNotification.addIcon(icon);
    }
    if (playSound != null) {
      jetNotification.addPlaySound(playSound);
    }
    if (enableVibration != null) {
      jetNotification.addEnableVibration(enableVibration);
    }
    if (vibrationPattern != null) {
      jetNotification.addVibrationPattern(vibrationPattern);
    }
    if (groupKey != null) {
      jetNotification.addGroupKey(groupKey);
    }
    if (setAsGroupSummary != null) {
      jetNotification.addSetAsGroupSummary(setAsGroupSummary);
    }
    if (groupAlertBehavior != null) {
      jetNotification.addGroupAlertBehavior(groupAlertBehavior);
    }
    if (autoCancel != null) {
      jetNotification.addAutoCancel(autoCancel);
    }
    if (ongoing != null) {
      jetNotification.addOngoing(ongoing);
    }
    if (silent != null) {
      jetNotification.addSilent(silent);
    }
    if (color != null) {
      jetNotification.addColor(color);
    }
    if (largeIcon != null) {
      jetNotification.addLargeIcon(largeIcon);
    }
    if (onlyAlertOnce != null) {
      jetNotification.addOnlyAlertOnce(onlyAlertOnce);
    }
    if (showWhen != null) {
      jetNotification.addShowWhen(showWhen);
    }
    if (when != null) {
      jetNotification.addWhen(when);
    }
    if (usesChronometer != null) {
      jetNotification.addUsesChronometer(usesChronometer);
    }
    if (chronometerCountDown != null) {
      jetNotification.addChronometerCountDown(chronometerCountDown);
    }
    if (channelShowBadge != null) {
      jetNotification.addChannelShowBadge(channelShowBadge);
    }
    if (showProgress != null) {
      jetNotification.addShowProgress(showProgress);
    }
    if (maxProgress != null) {
      jetNotification.addMaxProgress(maxProgress);
    }
    if (progress != null) {
      jetNotification.addProgress(progress);
    }
    if (indeterminate != null) {
      jetNotification.addIndeterminate(indeterminate);
    }
    if (channelAction != null) {
      jetNotification.addChannelAction(channelAction);
    }
    if (enableLights != null) {
      jetNotification.addEnableLights(enableLights);
    }
    if (ledColor != null) {
      jetNotification.addLedColor(ledColor);
    }
    if (ledOnMs != null) {
      jetNotification.addLedOnMs(ledOnMs);
    }
    if (ledOffMs != null) {
      jetNotification.addLedOffMs(ledOffMs);
    }
    if (visibility != null) {
      jetNotification.addVisibility(visibility);
    }
    if (timeoutAfter != null) {
      jetNotification.addTimeoutAfter(timeoutAfter);
    }
    if (fullScreenIntent != null) {
      jetNotification.addFullScreenIntent(fullScreenIntent);
    }
    if (shortcutId != null) {
      jetNotification.addShortcutId(shortcutId);
    }
    if (additionalFlags != null) {
      jetNotification.addAdditionalFlags(additionalFlags);
    }
    if (tag != null) {
      jetNotification.addTag(tag);
    }
    if (actions != null) {
      jetNotification.addActions(actions);
    }
    if (colorized != null) {
      jetNotification.addColorized(colorized);
    }
    if (audioAttributesUsage != null) {
      jetNotification.addAudioAttributesUsage(audioAttributesUsage);
    }
    if (presentList != null) {
      jetNotification.addPresentList(presentList);
    }
    if (presentAlert != null) {
      jetNotification.addPresentAlert(presentAlert);
    }
    if (presentBadge != null) {
      jetNotification.addPresentBadge(presentBadge);
    }
    if (presentSound != null) {
      jetNotification.addPresentSound(presentSound);
    }
    if (presentBanner != null) {
      jetNotification.addPresentBanner(presentBanner);
    }
    if (threadIdentifier != null) {
      jetNotification.addThreadIdentifier(threadIdentifier);
    }
    if (categoryIdentifier != null) {
      jetNotification.addCategoryIdentifier(categoryIdentifier);
    }
    if (interruptionLevel != null) {
      jetNotification.addInterruptionLevel(interruptionLevel);
    }

    await jetNotification.send(
      at: at,
      androidScheduleMode: androidScheduleMode,
    );
  }

  /// Send the push notification
  Future<void> send({
    DateTime? at,
    AndroidScheduleMode? androidScheduleMode,
  }) async {
    if (kIsWeb) {
      throw Exception("Push notifications are not supported on the web");
    }

    await _requestPermissions();

    _sendAt = at;

    if (!_isInitialized) {
      throw Exception(
        "JetNotifications is not initialized please add NotificationsAdapter to your app adapters",
      );
    }

    NotificationDetails notificationDetails = await _getNotificationDetails();

    if (_sendAt != null) {
      String sendAtDateTime = at!.toString();

      _observer!.onScheduling(
        message: "Scheduling notification for: $sendAtDateTime",
        scheduledTime: at,
      );

      final scheduledTime = tz.TZDateTime.parse(tz.local, sendAtDateTime);
      _observer!.onSchedulingParsed(
        message: "Parsed scheduled time: $scheduledTime",
        parsedTime: scheduledTime,
      );

      await _localNotifications.zonedSchedule(
        _id ?? 1,
        _title,
        _body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode:
            androidScheduleMode ?? AndroidScheduleMode.exactAllowWhileIdle,
        payload: _payload,
      );

      _observer!.onSchedulingSuccess(
        message: "Notification scheduled successfully",
        scheduledTime: at,
      );
      return;
    }

    await _localNotifications.show(
      _id ?? 1,
      _title,
      _body,
      notificationDetails,
      payload: _payload,
    );

    // Trigger onReceive event for foreground notifications
    _triggerOnReceiveEvent(_id ?? 1, _payload);
  }

  /// Add an attachment to the push notification
  JetNotifications addAttachment(
    String url,
    String fileName, {
    bool? showThumbnail,
  }) {
    _attachments.add(
      _JetNotificationAttachments(url, fileName, showThumbnail: showThumbnail),
    );
    return this;
  }

  /// Add a payload to the push notification
  JetNotifications addPayload(String payload) {
    _payload = payload;
    return this;
  }

  /// Add an id to the push notification
  JetNotifications addId(int id) {
    _id = id;
    return this;
  }

  /// Add a subtitle to the push notification
  JetNotifications addSubtitle(String subtitle) {
    _subtitle = subtitle;
    return this;
  }

  /// Add the badge number to the push notification
  JetNotifications addBadgeNumber(int badgeNumber) {
    _badgeNumber = badgeNumber;
    return this;
  }

  /// Add a sound to the push notification
  JetNotifications addSound(String sound) {
    _sound = sound;
    return this;
  }

  /// Add channel Id to the push notification
  JetNotifications addChannelId(String channelId) {
    _channelId = channelId;
    return this;
  }

  /// Add channel name to the push notification
  JetNotifications addChannelName(String channelName) {
    _channelName = channelName;
    return this;
  }

  /// Add channel description to the push notification
  JetNotifications addChannelDescription(String channelDescription) {
    _channelDescription = channelDescription;
    return this;
  }

  /// Add importance to the push notification
  JetNotifications addImportance(Importance importance) {
    _importance = importance;
    return this;
  }

  /// Add priority to the push notification
  JetNotifications addPriority(Priority priority) {
    _priority = priority;
    return this;
  }

  /// Add ticker to the push notification
  JetNotifications addTicker(String ticker) {
    _ticker = ticker;
    return this;
  }

  /// Add icon to the push notification
  JetNotifications addIcon(String icon) {
    _icon = icon;
    return this;
  }

  /// Add play sound to the push notification
  JetNotifications addPlaySound(bool playSound) {
    _playSound = playSound;
    return this;
  }

  /// Add enable vibration to the push notification
  JetNotifications addEnableVibration(bool enableVibration) {
    _enableVibration = enableVibration;
    return this;
  }

  /// Add vibration pattern to the push notification
  JetNotifications addVibrationPattern(List<int> vibrationPattern) {
    _vibrationPattern = vibrationPattern;
    return this;
  }

  /// Add group key to the push notification
  JetNotifications addGroupKey(String groupKey) {
    _groupKey = groupKey;
    return this;
  }

  /// Add set as group summary to the push notification
  JetNotifications addSetAsGroupSummary(bool setAsGroupSummary) {
    _setAsGroupSummary = setAsGroupSummary;
    return this;
  }

  /// Add group alert behavior to the push notification
  JetNotifications addGroupAlertBehavior(
    GroupAlertBehavior groupAlertBehavior,
  ) {
    _groupAlertBehavior = groupAlertBehavior;
    return this;
  }

  /// Add auto cancel to the push notification
  JetNotifications addAutoCancel(bool autoCancel) {
    _autoCancel = autoCancel;
    return this;
  }

  /// Add ongoing to the push notification
  JetNotifications addOngoing(bool ongoing) {
    _ongoing = ongoing;
    return this;
  }

  /// Add silent to the push notification
  JetNotifications addSilent(bool silent) {
    _silent = silent;
    return this;
  }

  /// Add color to the push notification
  JetNotifications addColor(Color color) {
    _color = color;
    return this;
  }

  /// Add large icon to the push notification
  JetNotifications addLargeIcon(String largeIcon) {
    _largeIcon = largeIcon;
    return this;
  }

  /// Add only alert once to the push notification
  JetNotifications addOnlyAlertOnce(bool onlyAlertOnce) {
    _onlyAlertOnce = onlyAlertOnce;
    return this;
  }

  /// Add show when to the push notification
  JetNotifications addShowWhen(bool showWhen) {
    _showWhen = showWhen;
    return this;
  }

  /// Add when to the push notification
  JetNotifications addWhen(int when) {
    _when = when;
    return this;
  }

  /// Add uses chronometer to the push notification
  JetNotifications addUsesChronometer(bool usesChronometer) {
    _usesChronometer = usesChronometer;
    return this;
  }

  /// Add chronometer count down to the push notification
  JetNotifications addChronometerCountDown(bool chronometerCountDown) {
    _chronometerCountDown = chronometerCountDown;
    return this;
  }

  /// Add channel show badge to the push notification
  JetNotifications addChannelShowBadge(bool channelShowBadge) {
    _channelShowBadge = channelShowBadge;
    return this;
  }

  /// Add show progress to the push notification
  JetNotifications addShowProgress(bool showProgress) {
    _showProgress = showProgress;
    return this;
  }

  /// Add max progress to the push notification
  JetNotifications addMaxProgress(int maxProgress) {
    _maxProgress = maxProgress;
    return this;
  }

  /// Add progress to the push notification
  JetNotifications addProgress(int progress) {
    _progress = progress;
    return this;
  }

  /// Add indeterminate to the push notification
  JetNotifications addIndeterminate(bool indeterminate) {
    _indeterminate = indeterminate;
    return this;
  }

  /// Add channel action to the push notification
  JetNotifications addChannelAction(
    AndroidNotificationChannelAction channelAction,
  ) {
    _channelAction = channelAction;
    return this;
  }

  /// Add enable lights to the push notification
  JetNotifications addEnableLights(bool enableLights) {
    _enableLights = enableLights;
    return this;
  }

  /// Add led color to the push notification
  JetNotifications addLedColor(Color ledColor) {
    _ledColor = ledColor;
    return this;
  }

  /// Add led on ms to the push notification
  JetNotifications addLedOnMs(int ledOnMs) {
    _ledOnMs = ledOnMs;
    return this;
  }

  /// Add led off ms to the push notification
  JetNotifications addLedOffMs(int ledOffMs) {
    _ledOffMs = ledOffMs;
    return this;
  }

  /// Add visibility to the push notification
  JetNotifications addVisibility(NotificationVisibility visibility) {
    _visibility = visibility;
    return this;
  }

  /// Add timeout after to the push notification
  JetNotifications addTimeoutAfter(int timeoutAfter) {
    _timeoutAfter = timeoutAfter;
    return this;
  }

  /// Add full screen intent to the push notification
  JetNotifications addFullScreenIntent(bool fullScreenIntent) {
    _fullScreenIntent = fullScreenIntent;
    return this;
  }

  /// Add shortcut id to the push notification
  JetNotifications addShortcutId(String shortcutId) {
    _shortcutId = shortcutId;
    return this;
  }

  /// Add additional flags to the push notification
  JetNotifications addAdditionalFlags(List<int> additionalFlags) {
    _additionalFlags = additionalFlags;
    return this;
  }

  /// Add tag to the push notification
  JetNotifications addTag(String tag) {
    _tag = tag;
    return this;
  }

  /// Add actions to the push notification
  JetNotifications addActions(List<AndroidNotificationAction> actions) {
    _actions = actions;
    return this;
  }

  /// Add colorized to the push notification
  JetNotifications addColorized(bool colorized) {
    _colorized = colorized;
    return this;
  }

  /// Add audio attributes usage to the push notification
  JetNotifications addAudioAttributesUsage(
    AudioAttributesUsage audioAttributesUsage,
  ) {
    _audioAttributesUsage = audioAttributesUsage;
    return this;
  }

  /// Add present list to the push notification
  JetNotifications addPresentList(bool presentList) {
    _presentList = presentList;
    return this;
  }

  /// Add present alert to the push notification
  JetNotifications addPresentAlert(bool presentAlert) {
    _presentAlert = presentAlert;
    return this;
  }

  /// Add present badge to the push notification
  JetNotifications addPresentBadge(bool presentBadge) {
    _presentBadge = presentBadge;
    return this;
  }

  /// Add present sound to the push notification
  JetNotifications addPresentSound(bool presentSound) {
    _presentSound = presentSound;
    return this;
  }

  /// Add present banner to the push notification
  JetNotifications addPresentBanner(bool presentBanner) {
    _presentBanner = presentBanner;
    return this;
  }

  /// Add thread identifier to the push notification
  JetNotifications addThreadIdentifier(String threadIdentifier) {
    _threadIdentifier = threadIdentifier;
    return this;
  }

  /// Add category identifier to the push notification
  JetNotifications addCategoryIdentifier(String categoryIdentifier) {
    _categoryIdentifier = categoryIdentifier;
    return this;
  }

  /// Add interruption level to the push notification
  JetNotifications addInterruptionLevel(InterruptionLevel interruptionLevel) {
    _interruptionLevel = interruptionLevel;
    return this;
  }

  /// Get the notification details
  Future<NotificationDetails> _getNotificationDetails() async {
    if (Platform.isIOS) {
      // fetch the attachments
      List<DarwinNotificationAttachment> attachments = [];
      for (_JetNotificationAttachments attachment in _attachments) {
        try {
          final String fileAttachment = await _downloadAndSaveFile(
            attachment.url,
            attachment.fileName,
          );

          attachments.add(
            DarwinNotificationAttachment(
              fileAttachment,
              identifier: attachment.fileName,
              hideThumbnail: attachment.showThumbnail ?? false,
            ),
          );
        } on Exception catch (e) {
          _observer!.onAttachmentError(
            message: e.toString(),
            error: e,
            fileName: attachment.fileName,
          );
          continue;
        }
      }

      DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentList: _presentList ?? true,
            presentAlert: _presentAlert ?? true,
            presentBadge: _presentBadge ?? true,
            presentSound: _presentSound ?? true,
            presentBanner: _presentBanner ?? true,
            sound: _sound,
            attachments: attachments,
            badgeNumber: _badgeNumber,
            subtitle: _subtitle,
            threadIdentifier: _threadIdentifier,
            categoryIdentifier: _categoryIdentifier,
            interruptionLevel: _interruptionLevel,
          );

      return NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
      );
    }

    if (Platform.isAndroid) {
      bool isSoundAUrl = _sound != null && _sound!.startsWith("http");
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            _channelId ?? "",
            _channelName ?? "",
            channelDescription: _channelDescription ?? "",
            importance: _importance ?? Importance.max,
            priority: _priority ?? Priority.high,
            ticker: _ticker ?? "",
            icon: _icon,
            playSound: _playSound ?? true,
            sound: isSoundAUrl
                ? UriAndroidNotificationSound(_sound ?? "")
                : RawResourceAndroidNotificationSound(_sound ?? ""),
            enableVibration: _enableVibration ?? true,
            vibrationPattern: _vibrationPattern == null
                ? null
                : Int64List.fromList(_vibrationPattern ?? []),
            groupKey: _groupKey,
            setAsGroupSummary: _setAsGroupSummary ?? false,
            groupAlertBehavior: _groupAlertBehavior ?? GroupAlertBehavior.all,
            autoCancel: _autoCancel ?? true,
            ongoing: _ongoing ?? false,
            silent: _silent ?? false,
            color: _color,
            largeIcon: _largeIcon == null
                ? null
                : FilePathAndroidBitmap(_largeIcon ?? ""),
            onlyAlertOnce: _onlyAlertOnce ?? false,
            showWhen: _showWhen ?? true,
            when: _when,
            usesChronometer: _usesChronometer ?? false,
            chronometerCountDown: _chronometerCountDown ?? false,
            channelShowBadge: _channelShowBadge ?? true,
            showProgress: _showProgress ?? false,
            maxProgress: _maxProgress ?? 0,
            progress: _progress ?? 0,
            indeterminate: _indeterminate ?? false,
            channelAction:
                _channelAction ??
                AndroidNotificationChannelAction.createIfNotExists,
            enableLights: _enableLights ?? false,
            ledColor: _ledColor,
            ledOnMs: _ledOnMs,
            ledOffMs: _ledOffMs,
            visibility: _visibility,
            timeoutAfter: _timeoutAfter,
            category: AndroidNotificationCategory.message,
            fullScreenIntent: _fullScreenIntent ?? false,
            shortcutId: _shortcutId,
            additionalFlags: _additionalFlags == null
                ? null
                : Int32List.fromList(_additionalFlags ?? []),
            subText: _subtitle,
            tag: _tag,
            actions: _actions,
            colorized: _colorized ?? false,
            number: _badgeNumber,
            audioAttributesUsage:
                _audioAttributesUsage ?? AudioAttributesUsage.notification,
          );

      return NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
    }

    throw Exception("Platform not supported");
  }

  /// Cancel a notification
  static Future<void> cancelNotification(int id, {String? tag}) async {
    await _localNotifications.cancel(id, tag: tag);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Request permissions
  static Future<void> requestPermissions({
    bool alert = true,
    bool badge = true,
    bool sound = true,
    bool provisional = false,
    bool critical = false,
    bool vibrate = true,
    bool enableLights = true,
    String channelId = "default_notification_channel_id",
    String channelName = "Default Notification Channel",
    String? description,
    String? groupId,
    Importance? importance,
    List<int>? vibratePattern,
    Color? ledColor,
    AudioAttributesUsage? audioAttributesUsage,
  }) async {
    if (kIsWeb) {
      throw Exception("Push notifications are not supported on the web");
    }

    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions();
      return;
    }
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return;
    }

    throw Exception("Platform not supported");
  }

  /// Request permissions (internal method)
  static Future<void> _requestPermissions() async {
    await requestPermissions();
  }

  /// Clear badge count
  static Future<void> clearBadgeCount() async {
    await _localNotifications.cancelAll();
  }
}

/// Jet notification helper
JetNotifications jetNotification(String title, String body) =>
    JetNotifications(title: title, body: body);

/// Background notification tap handler
///
/// This function is called when a notification is tapped while the app
/// is in the background or terminated. It must be a top-level function
/// and marked with @pragma('vm:entry-point') to be accessible from
/// the background isolate.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  JetNotifications.observer?.onBackgroundTap(
    response: notificationResponse,
  );

  try {
    final wrapper = NotificationResponseWrapper(notificationResponse);
    final event = JetNotificationEventRegistry.findHandler(
      notificationResponse,
    );

    if (event != null) {
      JetNotifications.observer?.onBackgroundTapHandlerFound(
        eventName: event.name,
        notificationId: notificationResponse.id ?? 0,
        response: notificationResponse,
      );

      if (wrapper.isAction) {
        // Handle action button press
        event.onAction(notificationResponse, wrapper.actionId!);
      } else {
        // Handle notification tap
        event.onTap(notificationResponse);
      }
    } else {
      JetNotifications.observer?.onNoBackgroundTapHandler(
        notificationId: notificationResponse.id ?? 0,
        response: notificationResponse,
      );
    }
  } catch (e) {
    JetNotifications.observer?.onBackgroundTapError(
      message: "NOTIFICATION: Error in background tap handler: $e",
      error: e,
      response: notificationResponse,
    );
  }
}
