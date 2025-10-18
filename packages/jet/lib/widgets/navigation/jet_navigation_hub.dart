import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jet/extensions/build_context.dart';

class JetNavigationHub extends StatelessWidget {
  final AnimatedIndexedStackTransitionBuilder? transitionBuilder;
  final List<PageRouteInfo>? routes;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool lazyLoad;
  final List<Widget> destinations;
  final NavigatorObserversBuilder navigatorObservers;
  final bool inheritNavigatorObservers;
  final Widget? floatingActionButton;
  final FloatingActionButtonBuilder? floatingActionButtonBuilder;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final AppBarBuilder? appBarBuilder;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final int homeIndex;

  const JetNavigationHub({
    super.key,
    required this.destinations,
    this.routes,
    this.lazyLoad = true,
    this.homeIndex = -1,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.ease,
    this.transitionBuilder,
    this.inheritNavigatorObservers = true,
    this.navigatorObservers =
        AutoRouterDelegate.defaultNavigatorObserversBuilder,
    this.floatingActionButton,
    this.floatingActionButtonBuilder,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.drawerScrimColor,
    this.backgroundColor,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.appBarBuilder,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: routes,
      lazyLoad: lazyLoad,
      homeIndex: homeIndex,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      transitionBuilder: transitionBuilder,
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: context.theme.secondaryHeaderColor,
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: context.theme.colorScheme.surface,
            destinations: destinations,
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: (index) {
              tabsRouter.setActiveIndex(index);
            },
          ),
        );
      },
      inheritNavigatorObservers: inheritNavigatorObservers,
      navigatorObservers: navigatorObservers,
      floatingActionButton: floatingActionButton,
      floatingActionButtonBuilder: floatingActionButtonBuilder,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      drawerScrimColor: drawerScrimColor,
      backgroundColor: backgroundColor,
      bottomSheet: bottomSheet,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBarBuilder: appBarBuilder,
      scaffoldKey: scaffoldKey,
    );
  }
}
