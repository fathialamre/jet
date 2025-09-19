import 'package:flutter/material.dart';
import 'package:jet_flutter_framework/jet_framework.dart';
import 'package:jet_flutter_framework/localization/models/locale_info.dart';
import 'package:jet_flutter_framework/networking/interceptors/jet_dio_logger_config.dart';
import 'package:jet_flutter_framework/resources/components/jet_loader.dart';
import 'package:jet_flutter_framework/notifications/observers/jet_notification_observer.dart';

/// Configuration class for Jet framework that defines app-wide settings.
///
/// This abstract class provides a centralized way to configure various aspects
/// of your Flutter application including adapters, localization, and theming.
///
/// Example usage:
/// ```dart
/// class AppConfig extends JetConfig {
///   @override
///   List<JetAdapter> get adapters => [
///     RouterAdapter(),
///     DatabaseAdapter(),
///   ];
///
///   @override
///   List<Locale> get supportedLocales => [
///     const Locale('en'),
///     const Locale('es'),
///   ];
///
///   @override
///   Locale? get defaultLocale => const Locale('en');
///
///   @override
///   ThemeData? get theme => ThemeData(
///     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
///   );
/// }
/// ```
abstract class JetConfig {
  /// List of adapters that provide additional functionality to the app.
  ///
  /// Adapters can handle routing, state management, networking, etc.
  /// Example: [RouterAdapter, DatabaseAdapter, AnalyticsAdapter]
  List<JetAdapter> get adapters;

  /// The default locale for the application.
  ///
  /// This locale will be used when the system locale is not supported
  /// or when the app first launches.
  /// Example: `const Locale('en')`
  Locale? get defaultLocale;

  /// List of locales that the application supports.
  ///
  /// These locales determine which translations and regional settings
  /// are available in the app.
  /// Example: `[const Locale('en'), const Locale('es'), const Locale('fr')]`
  List<LocaleInfo> get supportedLocales;

  /// List of localization delegates for custom localization.
  ///
  /// These delegates handle loading and managing localized resources
  /// like strings, dates, and numbers.
  /// Example: `[GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate]`
  List<LocalizationsDelegate<Object>> get localizationsDelegates;

  /// The light theme configuration for the application.
  ///
  /// Returns null by default, meaning no custom light theme is applied.
  /// Example: `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue))`
  ThemeData? get theme => null;

  bool get showErrorStackTrace => true;

  /// The dark theme configuration for the application.
  ///
  /// Returns null by default, meaning no custom dark theme is applied.
  /// Example: `ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark))`
  ThemeData? get darkTheme => null;

  /// The theme mode for the application.
  ///
  /// Controls whether the app uses light, dark, or system theme.
  /// Defaults to [ThemeMode.system] which follows the system preference.
  /// Examples: [ThemeMode.light], [ThemeMode.dark], [ThemeMode.system]
  ThemeMode? get themeMode => ThemeMode.system;

  /// The loader for the application.
  ///
  /// Returns null by default, meaning no custom loader is applied.
  /// Example: `JetLoader(color: Colors.blue)`
  JetLoader get loader => JetLoader();

  /// The error handler for the application.
  ///
  /// Returns the default JetErrorHandler by default.
  /// Override this to provide custom error handling logic.
  /// Example: `MyCustomErrorHandler()`
  JetBaseErrorHandler get errorHandler => JetErrorHandler.instance;

  String get fontFamily => 'inter';

  JetDioLoggerConfig get dioLoggerConfig => JetDioLoggerConfig();

  ThemeData? getTheme() {
    return theme?.copyWith(
      textTheme: theme?.textTheme.apply(
        fontFamily: fontFamily,
      ),
    );
  }

  ThemeData? getDarkTheme() {
    return darkTheme?.copyWith(
      textTheme: darkTheme?.textTheme.apply(
        fontFamily: fontFamily,
      ),
    );
  }

  NavigatorObserversBuilder get navigatorObservers =>
      () => [];

  bool get debugShowCheckedModeBanner => false;

  /// The title of the application.
  ///
  /// This title is used by the OS to identify the application and
  /// may be displayed in places like the task switcher.
  /// Example: `'My Flutter App'`
  String get title => '';

  /// A function that generates the title dynamically based on context.
  ///
  /// This is useful for localized titles or context-dependent names.
  /// Takes precedence over [title] if provided.
  /// Example: `(context) => AppLocalizations.of(context).appTitle`
  String Function(BuildContext)? get onGenerateTitle => null;

  /// The primary color to use for the application in the operating system interface.
  ///
  /// On Android, this is the color used for the app's entry in the recent apps screen.
  /// Example: `Colors.blue`
  Color? get color => null;

  /// The app's restoration scope ID for state restoration.
  ///
  /// This allows the app to restore its state after being killed by the OS.
  /// Example: `'main_app'`
  String? get restorationScopeId => null;

  /// Custom scroll behavior for the entire application.
  ///
  /// This controls how scrollable widgets behave throughout the app.
  /// Example: `MyCustomScrollBehavior()`
  ScrollBehavior? get scrollBehavior => null;

  /// High contrast theme for accessibility.
  ///
  /// Used when the system is in high contrast mode for better visibility.
  /// Example: `ThemeData(colorScheme: ColorScheme.highContrastLight())`
  ThemeData? get highContrastTheme => null;

  /// High contrast dark theme for accessibility.
  ///
  /// Used when the system is in high contrast dark mode.
  /// Example: `ThemeData(colorScheme: ColorScheme.highContrastDark())`
  ThemeData? get highContrastDarkTheme => null;

  /// Duration for theme change animations.
  ///
  /// Controls how long it takes to animate between theme changes.
  /// Example: `Duration(milliseconds: 300)`
  Duration get themeAnimationDuration => kThemeAnimationDuration;

  /// Animation curve for theme transitions.
  ///
  /// Controls the easing function used for theme animations.
  /// Example: `Curves.easeInOut`
  Curve get themeAnimationCurve => Curves.linear;

  /// Global shortcuts for the application.
  ///
  /// Defines keyboard shortcuts that work throughout the app.
  /// Example: `{LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN): NewDocumentIntent()}`
  Map<ShortcutActivator, Intent>? get shortcuts => null;

  /// Global actions for the application.
  ///
  /// Defines actions that can be triggered by shortcuts or other means.
  /// Example: `{NewDocumentIntent: NewDocumentAction()}`
  Map<Type, Action<Intent>>? get actions => null;

  /// Builder function to wrap the entire app.
  ///
  /// Useful for adding global overlays, performance monitoring, or other wrappers.
  /// The child parameter is the entire MaterialApp.
  /// Example: `(context, child) => MyGlobalWrapper(child: child)`
  Widget Function(BuildContext, Widget?)? get builder => null;

  /// Whether to show performance overlay for debugging.
  ///
  /// Displays performance metrics in debug mode.
  /// Should typically only be enabled in debug builds.
  bool get showPerformanceOverlay => false;

  /// Whether to show semantics debugger for accessibility testing.
  ///
  /// Highlights semantic information for screen readers and other assistive technologies.
  /// Should typically only be enabled in debug builds.
  bool get showSemanticsDebugger => false;

  /// Whether to checkerboard raster cache images for debugging.
  ///
  /// Shows a checkerboard pattern on cached images to help identify performance issues.
  /// Should typically only be enabled in debug builds.
  bool get checkerboardRasterCacheImages => false;

  /// Whether to checkerboard layers rendered to offscreen bitmaps.
  ///
  /// Shows a checkerboard pattern on offscreen layers to help identify performance issues.
  /// Should typically only be enabled in debug builds.
  bool get checkerboardOffscreenLayers => false;

  /// List of notification events to register.
  ///
  /// These events will be automatically registered when the app starts
  /// and will handle notification taps, receives, and actions.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// List<JetNotificationEvent> get notificationEvents => [
  ///   OrderNotificationEvent(),
  ///   MessageNotificationEvent(),
  ///   SystemNotificationEvent(),
  /// ];
  /// ```
  List<JetNotificationEvent> get notificationEvents => [];

  /// Global notification tap handler.
  ///
  /// This handler is called for all notification taps after the specific
  /// event handler has been called. It's useful for logging, analytics,
  /// or common processing that should happen for all notifications.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Future<void> Function(NotificationResponse)? get globalNotificationHandler => (response) async {
  ///   // Log notification tap
  ///   analytics.track('notification_tapped', {'id': response.id});
  ///
  ///   // Update app state
  ///   ref.read(notificationProvider.notifier).markAsTapped(response.id);
  /// };
  /// ```
  Future<void> Function(NotificationResponse)? get globalNotificationHandler =>
      null;

  /// Background notification handler.
  ///
  /// This handler is called when a notification is tapped while the app
  /// is in the background or terminated. It must be a top-level function
  /// and is used for background processing.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// @pragma('vm:entry-point')
  /// static void Function(NotificationResponse)? get backgroundNotificationHandler => (response) async {
  ///   // Background processing
  ///   await database.updateNotificationStatus(response.id);
  /// };
  /// ```
  @pragma('vm:entry-point')
  static void Function(NotificationResponse)?
  get backgroundNotificationHandler => null;

  /// Notification event configuration.
  ///
  /// This allows you to configure specific settings for notification events,
  /// such as channel settings, priority, and platform-specific options.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Map<int, NotificationEventConfig> get notificationEventConfigs => {
  ///   1: NotificationEventConfig.highPriority(OrderNotificationEvent()),
  ///   2: NotificationEventConfig.lowPriority(MessageNotificationEvent()),
  /// };
  /// ```
  Map<int, NotificationEventConfig> get notificationEventConfigs => {};

  /// Whether to enable notification event logging.
  ///
  /// When enabled, detailed logs will be written for notification events
  /// including registration, handling, and errors.
  bool get enableNotificationEventLogging => true;

  /// Notification event timeout duration.
  ///
  /// The maximum time to wait for a notification event handler to complete
  /// before timing out. This prevents handlers from blocking the app.
  Duration get notificationEventTimeout => const Duration(seconds: 30);

  /// Notification observer for handling notification events.
  ///
  /// This observer will be used to handle all notification-related events
  /// including initialization, responses, errors, and background processing.
  /// By default, it uses the JetNotificationObserver which logs events.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// JetNotificationObserver get notificationObserver => MyCustomObserver();
  /// ```
  JetNotificationObserver get notificationObserver => JetNotificationObserver();
}
