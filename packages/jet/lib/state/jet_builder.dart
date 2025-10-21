import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:jet/extensions/build_context.dart';
import 'package:jet/jet.dart';
import 'package:jet/widgets/feedback/jet_empty_widget.dart';
import 'package:jet/state/jet_consumer.dart';
import 'package:jet/networking/errors/errors.dart';

/// Unified state management for Jet framework
///
/// **JetBuilder** provides a simple, powerful API for handling all common state patterns:
/// - Pull to refresh
/// - Loading and error states
/// - Lists, grids, and single items
/// - Built-in error handling with custom error widgets
/// - Horizontal and vertical scrolling
/// - Scroll controller support
/// - Advanced customization (padding, spacing, separators, etc.)
/// - Pagination (see JetPaginator for infinite scroll)
///
/// ## Features
///
/// - **Empty States**: Automatic empty state handling with customization
/// - **Error Handling**: Built-in error widgets with retry functionality
/// - **Flexible Scrolling**: Horizontal/vertical with controller support
/// - **Customizable**: Padding, spacing, separators, and more
///
/// ## Basic Usage
///
/// **Simple list:**
/// ```dart
/// JetBuilder.list(
///   context: context,
///   provider: postsProvider,
///   itemBuilder: (post, index) => PostCard(post: post),
/// )
/// ```
///
///
/// **Grid with customization:**
/// ```dart
/// JetBuilder.grid(
///   context: context,
///   provider: productsProvider,
///   crossAxisCount: 2,
///   mainAxisSpacing: 10,
///   crossAxisSpacing: 10,
///   padding: EdgeInsets.all(16),
///   itemBuilder: (product, index) => ProductCard(product: product),
/// )
/// ```
///
/// **Horizontal list:**
/// ```dart
/// JetBuilder.list(
///   context: context,
///   provider: categoriesProvider,
///   scrollDirection: Axis.horizontal,
///   shrinkWrap: true,
///   itemBuilder: (category, index) => CategoryChip(category: category),
/// )
/// ```
///
/// **List with separators:**
/// ```dart
/// JetBuilder.list(
///   context: context,
///   provider: itemsProvider,
///   itemBuilder: (item, index) => ItemTile(item: item),
///   separatorBuilder: (context, index) => Divider(),
/// )
/// ```
///
/// **Single item:**
/// ```dart
/// JetBuilder.item(
///   context: context,
///   provider: userProvider,
///   builder: (user, ref) => UserProfile(user: user),
/// )
/// ```
///
/// **Custom empty and error states:**
/// ```dart
/// JetBuilder.list(
///   context: context,
///   provider: postsProvider,
///   itemBuilder: (post, index) => PostCard(post: post),
///   empty: EmptyPostsWidget(),
///   error: (error, stackTrace) => CustomErrorWidget(error: error),
/// )
/// ```
///
/// 📖 **[View Complete Documentation](../../docs/STATE_MANAGEMENT.md)**

/// JetBuilder: Helpers for wiring Riverpod providers with Jet + AsyncValue
class JetBuilder {
  /// Build a ListView from an AsyncValue<List<T>>
  static Widget list<T>({
    required BuildContext context,
    required ProviderBase<AsyncValue<List<T>>> provider,
    required Widget Function(T item, int index) itemBuilder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget? empty,
    String? emptyTitle,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    ScrollController? controller,
    ScrollPhysics? scrollPhysics,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    Widget Function(BuildContext, int)? separatorBuilder,
    Key? key,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      context: context,
      wrapInScroll: false, // ListView is already scrollable
      builder: (items, ref) {
        if (items.isEmpty) {
          return _buildEmptyState(context, empty, emptyTitle);
        }

        if (separatorBuilder != null) {
          return ListView.separated(
            key: key,
            controller: controller,
            physics: scrollPhysics,
            shrinkWrap: shrinkWrap,
            padding: padding,
            scrollDirection: scrollDirection,
            itemCount: items.length,
            itemBuilder: (ctx, index) => itemBuilder(items[index], index),
            separatorBuilder: separatorBuilder,
          );
        }

        return ListView.builder(
          key: key,
          controller: controller,
          physics: scrollPhysics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          scrollDirection: scrollDirection,
          itemCount: items.length,
          itemBuilder: (ctx, index) => itemBuilder(items[index], index),
        );
      },
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Build a GridView from an AsyncValue<List<T>>
  static Widget grid<T>({
    required BuildContext context,
    required ProviderBase<AsyncValue<List<T>>> provider,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget? empty,
    String? emptyTitle,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    ScrollController? controller,
    ScrollPhysics? scrollPhysics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Axis scrollDirection = Axis.vertical,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    Key? key,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      context: context,
      wrapInScroll: false, // GridView is already scrollable
      builder: (items, ref) {
        if (items.isEmpty) {
          return _buildEmptyState(context, empty, emptyTitle);
        }

        return GridView.builder(
          key: key,
          controller: controller,
          physics: scrollPhysics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          scrollDirection: scrollDirection,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (ctx, index) => itemBuilder(items[index], index),
        );
      },
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Build a single item widget from AsyncValue<T>
  static Widget item<T>({
    required BuildContext context,
    required ProviderBase<AsyncValue<T>> provider,
    required Widget Function(T item, WidgetRef ref) builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateWidget<T>(
      provider: provider,
      context: context,
      wrapInScroll: true, // Enable scrolling for single items
      builder: builder,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Build from AsyncValue<T> without forcing ListView/Grid
  static Widget builder<T>({
    required BuildContext context,
    required ProviderBase<AsyncValue<T>> provider,
    required Widget Function(T data, WidgetRef ref) builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loadingBuilder,
    Widget Function(Object error, StackTrace? stackTrace)? errorBuilder,
  }) {
    return _StateWidget<T>(
      provider: provider,
      context: context,
      wrapInScroll: true, // Enable scrolling for custom builders
      builder: builder,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loadingBuilder,
      error: errorBuilder,
    );
  }
}

/// State widget for a single provider
class _StateWidget<T> extends JetConsumerWidget {
  const _StateWidget({
    required this.provider,
    required this.context,
    required this.builder,
    this.onRefresh,
    this.onRetry,
    this.loading,
    this.error,
    this.wrapInScroll = false,
  });

  final ProviderBase<AsyncValue<T>> provider;
  final BuildContext context;
  final Widget Function(T data, WidgetRef ref) builder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;
  final bool wrapInScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref, Jet jet) {
    final providerListenable = provider as ProviderListenable<AsyncValue<T>>;
    final asyncValue = ref.watch(providerListenable);

    Widget content = asyncValue.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (data) => builder(data, ref),
      error: (err, stack) =>
          error?.call(err, stack) ??
          _buildDefaultErrorWidget(
            err,
            stack,
            jet,
            ref,
            this.context,
            onRetry,
            providerListenable,
          ),
      loading: () => loading ?? jet.config.loader,
    );

    // Wrap in SingleChildScrollView if needed for pull-to-refresh
    if (wrapInScroll) {
      content = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: content,
      );
    }

    return CustomMaterialIndicator(
      onRefresh: onRefresh ?? () => _defaultRefresh(ref, provider),
      triggerMode: IndicatorTriggerMode.onEdge,
      indicatorBuilder: (context, controller) {
        return SizedBox(
          height: 60.0,
          child: Center(
            child: _buildRefreshIndicator(controller),
          ),
        );
      },
      child: content,
    );
  }
}

/// Helper method to build empty state widget
Widget _buildEmptyState(
  BuildContext context,
  Widget? empty,
  String? emptyTitle,
) {
  return empty ??
      JetEmptyWidget(title: emptyTitle ?? context.jetI10n.noItemsFound);
}

/// Default refresh handler
Future<void> _defaultRefresh<T>(
  WidgetRef ref,
  ProviderBase<AsyncValue<T>> provider,
) async {
  // Most providers are Refreshable, so we cast directly
  // If this fails at runtime, the developer will get a clear error
  return ref.refresh(provider as Refreshable<AsyncValue<T>>);
}

/// Optimized refresh indicator widget
Widget _buildRefreshIndicator(IndicatorController controller) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return CircularProgressIndicator(
        value: controller.isLoading ? null : controller.value,
        strokeWidth: 2.0,
      );
    },
  );
}

Widget _buildDefaultErrorWidget<T>(
  Object error,
  StackTrace? stackTrace,
  Jet jet,
  WidgetRef ref,
  BuildContext context,
  VoidCallback? customOnRetry,
  ProviderListenable<AsyncValue<T>>? provider,
) {
  final jetError = JetError(
    message: error.toString(),
    stackTrace: stackTrace,
  );
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          jetError.message,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildRetryButton(
          jetError: jetError,
          ref: ref,
          provider: provider,
          onRetry:
              customOnRetry ??
              (provider != null
                  ? () => ref.refresh(provider as Refreshable<AsyncValue<T>>)
                  : null),
        ),
      ],
    ),
  );
}

Widget _buildRetryButton<T>({
  required JetError jetError,
  required WidgetRef ref,
  required VoidCallback? onRetry,
  ProviderListenable<AsyncValue<T>>? provider,
}) {
  final isLoading = provider != null ? ref.watch(provider).isLoading : false;
  return FilledButton(
    onPressed: isLoading || onRetry == null ? null : onRetry,
    child: isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text("Retry"),
  );
}
