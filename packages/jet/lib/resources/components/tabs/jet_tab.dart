import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A customizable tab widget with extensive styling options.
///
/// Supports both simple widget-based tabs and AutoRoute-based navigation.
///
/// For simple tabs with widgets:
/// ```dart
/// JetTab.simple(
///   tabs: ['Home', 'Profile', 'Settings'],
///   children: [
///     HomeView(),
///     ProfileView(),
///     SettingsView(),
///   ],
///   indicatorColor: Colors.blue,
///   labelColor: Colors.blue,
/// )
/// ```
///
/// For AutoRoute integration:
/// ```dart
/// JetTab.router(
///   routes: [
///     HomeRoute(),
///     ProfileRoute(),
///     SettingsRoute(),
///   ],
///   tabs: ['Home', 'Profile', 'Settings'],
///   indicatorColor: Colors.blue,
///   labelColor: Colors.blue,
/// )
/// ```
class JetTab extends HookWidget {
  const JetTab._({
    super.key,
    required this.tabs,
    this.children,
    this.routes,
    this.initialLength,
    this.initialIndex = 0,
    this.controller,
    this.builder,
    this.isScrollable = false,
    this.tabAlignment,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.indicatorSize,
    this.indicatorPadding,
    this.dividerColor,
    this.dividerHeight,
    this.onTap,
    this.tabBarHeight,
    this.physics,
    this.animationDuration,
    this.customTabs,
    this.useAutoRoute = false,
  });

  /// Creates a simple tab widget with widget children.
  const JetTab.simple({
    Key? key,
    required List<String> tabs,
    required List<Widget> children,
    int? initialLength,
    int initialIndex = 0,
    TabController? controller,
    bool isScrollable = false,
    TabAlignment? tabAlignment,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    TabBarIndicatorSize? indicatorSize,
    EdgeInsetsGeometry? indicatorPadding,
    Color? dividerColor,
    double? dividerHeight,
    ValueChanged<int>? onTap,
    double? tabBarHeight,
    ScrollPhysics? physics,
    Duration? animationDuration,
    List<Widget>? customTabs,
  }) : this._(
         key: key,
         tabs: tabs,
         children: children,
         initialLength: initialLength ?? children.length,
         initialIndex: initialIndex,
         controller: controller,
         isScrollable: isScrollable,
         tabAlignment: tabAlignment,
         indicatorColor: indicatorColor,
         labelColor: labelColor,
         unselectedLabelColor: unselectedLabelColor,
         labelStyle: labelStyle,
         unselectedLabelStyle: unselectedLabelStyle,
         indicatorSize: indicatorSize,
         indicatorPadding: indicatorPadding,
         dividerColor: dividerColor,
         dividerHeight: dividerHeight,
         onTap: onTap,
         tabBarHeight: tabBarHeight,
         physics: physics,
         animationDuration: animationDuration,
         customTabs: customTabs,
         useAutoRoute: false,
       );

  /// Creates a tab widget integrated with AutoRoute.
  const JetTab.router({
    Key? key,
    required List<PageRouteInfo> routes,
    required List<String> tabs,
    Widget Function(BuildContext context, Widget child)? builder,
    bool isScrollable = false,
    TabAlignment? tabAlignment,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    TabBarIndicatorSize? indicatorSize,
    EdgeInsetsGeometry? indicatorPadding,
    Color? dividerColor,
    double? dividerHeight,
    ValueChanged<int>? onTap,
    double? tabBarHeight,
    ScrollPhysics? physics,
    Duration? animationDuration,
    List<Widget>? customTabs,
  }) : this._(
         key: key,
         tabs: tabs,
         routes: routes,
         builder: builder,
         isScrollable: isScrollable,
         tabAlignment: tabAlignment,
         indicatorColor: indicatorColor,
         labelColor: labelColor,
         unselectedLabelColor: unselectedLabelColor,
         labelStyle: labelStyle,
         unselectedLabelStyle: unselectedLabelStyle,
         indicatorSize: indicatorSize,
         indicatorPadding: indicatorPadding,
         dividerColor: dividerColor,
         dividerHeight: dividerHeight,
         onTap: onTap,
         tabBarHeight: tabBarHeight,
         physics: physics,
         animationDuration: animationDuration,
         customTabs: customTabs,
         useAutoRoute: true,
       );

  /// List of tab titles (required if customTabs is not provided).
  final List<String> tabs;

  /// List of widgets to display in each tab's content area (simple mode only).
  final List<Widget>? children;

  /// List of tab routes to navigate between (router mode only).
  final List<PageRouteInfo>? routes;

  /// Initial index of the selected tab (defaults to 0).
  final int initialIndex;

  /// Total number of tabs (should match tabs.length and children.length).
  final int? initialLength;

  /// External tab controller (optional). If provided, will use this instead of creating a new one.
  final TabController? controller;

  /// Builder function that receives the context and active tab content (router mode only).
  final Widget Function(BuildContext context, Widget child)? builder;

  /// Internal flag to determine if using AutoRoute or simple mode.
  final bool useAutoRoute;

  /// Whether tabs can be scrolled horizontally when they overflow.
  final bool isScrollable;

  /// How tabs are aligned when isScrollable is true.
  final TabAlignment? tabAlignment;

  /// Color of the tab indicator line.
  final Color? indicatorColor;

  /// Color of the selected tab label.
  final Color? labelColor;

  /// Color of unselected tab labels.
  final Color? unselectedLabelColor;

  /// Text style for selected tab labels.
  final TextStyle? labelStyle;

  /// Text style for unselected tab labels.
  final TextStyle? unselectedLabelStyle;

  /// Size of the tab indicator (tab or label width).
  final TabBarIndicatorSize? indicatorSize;

  /// Padding around the tab indicator.
  final EdgeInsetsGeometry? indicatorPadding;

  /// Color of the divider line below the tabs.
  final Color? dividerColor;

  /// Height of the divider line below the tabs.
  final double? dividerHeight;

  /// Callback when a tab is tapped.
  final ValueChanged<int>? onTap;

  /// Fixed height for the tab bar area.
  final double? tabBarHeight;

  /// Scroll physics for the tab view content.
  final ScrollPhysics? physics;

  /// Animation duration for tab transitions.
  final Duration? animationDuration;

  /// Custom tab widgets (overrides tabs parameter if provided).
  final List<Widget>? customTabs;

  @override
  Widget build(BuildContext context) {
    if (useAutoRoute) {
      return _buildRouterTabs();
    } else {
      return _buildSimpleTabs();
    }
  }

  Widget _buildSimpleTabs() {
    // Use external controller if provided, otherwise create a new one
    final tabController =
        controller ??
        useTabController(
          initialLength: initialLength!,
          initialIndex: initialIndex,
          animationDuration: animationDuration,
        );

    // Use custom tabs if provided, otherwise create from text
    final tabWidgets = customTabs ?? tabs.map((tab) => Tab(text: tab)).toList();

    return Column(
      children: [
        SizedBox(
          height: tabBarHeight,
          child: TabBar(
            controller: tabController,
            tabs: tabWidgets,
            isScrollable: isScrollable,
            tabAlignment: tabAlignment,
            indicatorColor: indicatorColor,
            labelColor: labelColor,
            unselectedLabelColor: unselectedLabelColor,
            labelStyle: labelStyle,
            unselectedLabelStyle: unselectedLabelStyle,
            indicatorSize: indicatorSize,
            indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
            dividerColor: dividerColor,
            dividerHeight: dividerHeight,
            onTap: onTap,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: physics,
            children: children!,
          ),
        ),
      ],
    );
  }

  Widget _buildRouterTabs() {
    return AutoTabsRouter.tabBar(
      routes: routes!,
      builder: (context, child, controller) {
        final tabsRouter = AutoTabsRouter.of(context);

        // Create JetTab with AutoRoute's controller
        final jetTabBar = _buildJetTabBar(controller, tabsRouter);

        // Default builder that wraps in Column if no custom builder provided
        if (builder == null) {
          return Column(
            children: [
              jetTabBar,
              Expanded(child: child),
            ],
          );
        }

        // Custom builder - user handles layout
        return builder!(
          context,
          Column(
            children: [
              jetTabBar,
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJetTabBar(TabController controller, TabsRouter tabsRouter) {
    // Use custom tabs if provided, otherwise create from text
    final tabWidgets = customTabs ?? tabs.map((tab) => Tab(text: tab)).toList();

    return SizedBox(
      height: tabBarHeight,
      child: TabBar(
        controller: controller,
        tabs: tabWidgets,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        indicatorColor: indicatorColor,
        labelColor: labelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        indicatorSize: indicatorSize,
        indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
        dividerColor: dividerColor,
        dividerHeight: dividerHeight,
        physics: physics,
        onTap: (index) {
          // Handle both custom onTap and route navigation
          onTap?.call(index);
          tabsRouter.setActiveIndex(index);
        },
      ),
    );
  }
}

/// Helper extension for creating JetTab.router with common configurations.
extension JetTabRouterExtension on List<PageRouteInfo> {
  /// Creates a JetTab.router with bottom navigation style.
  JetTab toJetBottomTabs({
    required List<String> tabs,
    Widget Function(
      BuildContext context,
      Widget child,
      BottomNavigationBar bottomNav,
    )?
    builder,
    List<BottomNavigationBarItem>? bottomNavItems,
    Color? indicatorColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return JetTab.router(
      routes: this,
      tabs: tabs,
      indicatorColor: indicatorColor,
      labelColor: selectedItemColor,
      unselectedLabelColor: unselectedItemColor,
      builder: builder != null && bottomNavItems != null
          ? (context, child) {
              final tabsRouter = AutoTabsRouter.of(context);
              final bottomNav = BottomNavigationBar(
                currentIndex: tabsRouter.activeIndex,
                onTap: tabsRouter.setActiveIndex,
                selectedItemColor: selectedItemColor,
                unselectedItemColor: unselectedItemColor,
                items: bottomNavItems,
              );
              return builder(context, child, bottomNav);
            }
          : null,
    );
  }

  /// Creates a JetTab.router with scrollable tabs.
  JetTab toJetScrollableTabs({
    required List<String> tabs,
    TabAlignment? tabAlignment = TabAlignment.center,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    Widget Function(BuildContext context, Widget child)? builder,
  }) {
    return JetTab.router(
      routes: this,
      tabs: tabs,
      isScrollable: true,
      tabAlignment: tabAlignment,
      indicatorColor: indicatorColor,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      builder: builder,
    );
  }
}
