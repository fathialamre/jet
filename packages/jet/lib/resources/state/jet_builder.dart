import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:jet/jet.dart';
import 'package:jet/resources/components/jet_empty_widget.dart';
import 'package:jet/resources/state/jet_consumer.dart';
import 'package:jet/networking/errors/errors.dart';

/// Unified state management for Jet framework
///
/// **JetBuilder** provides a simple, powerful API for handling all common state patterns:
/// - Pull to refresh
/// - Loading and error states
/// - Lists, grids, and single items
/// - Provider families
/// - Built-in error handling with custom error widgets
/// - Pagination (see JetPaginator for infinite scroll)
///
/// ## Basic Usage
///
/// **Simple list:**
/// ```dart
/// JetBuilder.list(
///   provider: postsProvider,
///   itemBuilder: (post, index) => PostCard(post: post),
/// )
/// ```
///
/// **Grid with family:**
/// ```dart
/// JetBuilder.familyGrid(
///   provider: productsByCategoryProvider,
///   param: 'electronics',
///   crossAxisCount: 2,
///   itemBuilder: (product, index) => ProductCard(product: product),
/// )
/// ```
///
/// **Single item:**
/// ```dart
/// JetBuilder.item(
///   provider: userProvider,
///   builder: (user, ref) => UserProfile(user: user),
/// )
/// ```

/// JetBuilder: Helpers for wiring Riverpod providers with Jet + AsyncValue
class JetBuilder {
  /// Build a ListView from an AsyncValue<List<T>>
  static Widget list<T>({
    required ProviderListenable<AsyncValue<List<T>>> provider,
    required Widget Function(T item, int index) itemBuilder,
    required BuildContext context,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget? empty,
    String? emptyTitle,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    ScrollPhysics? scrollPhysics,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      builder: (items, ref) {
        if (items.isEmpty) {
          return empty ?? JetEmptyWidget(title: emptyTitle ?? '');
        }
        return ListView.builder(
          physics: scrollPhysics,
          shrinkWrap: true,
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
    required ProviderListenable<AsyncValue<List<T>>> provider,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    required BuildContext context,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      builder: (items, ref) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, index) => itemBuilder(items[index], index),
      ),
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Build a single item widget from AsyncValue<T>
  static Widget item<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required Widget Function(T item, WidgetRef ref) builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateWidget<T>(
      provider: provider,
      builder: builder,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Build from AsyncValue<T> without forcing ListView/Grid
  static Widget builder<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required Widget Function(T data, WidgetRef ref) builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateWidget<T>(
      provider: provider,
      builder: builder,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Family: list with a parameter
  static Widget familyList<T, Param>({
    required ProviderListenable<AsyncValue<List<T>>> Function(Param) provider,
    required Param param,
    required Widget Function(T item, int index) itemBuilder,
    required BuildContext context,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateFamilyWidget<List<T>, Param>(
      provider: provider,
      param: param,
      builder: (items, ref) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) => itemBuilder(items[index], index),
      ),
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Family: grid with a parameter
  static Widget familyGrid<T, Param>({
    required ProviderListenable<AsyncValue<List<T>>> Function(Param) provider,
    required Param param,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,
    required BuildContext context,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateFamilyWidget<List<T>, Param>(
      provider: provider,
      param: param,
      builder: (items, ref) => GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, index) => itemBuilder(items[index], index),
      ),
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }

  /// Family: builder with param
  static Widget familyBuilder<T, Param>({
    required ProviderListenable<AsyncValue<T>> Function(Param) provider,
    required Param param,
    required Widget Function(T data, WidgetRef ref) builder,
    Future<void> Function()? onRefresh,
    VoidCallback? onRetry,
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
  }) {
    return _StateFamilyWidget<T, Param>(
      provider: provider,
      param: param,
      builder: builder,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
    );
  }
}

/// State widget for a single provider
class _StateWidget<T> extends JetConsumerWidget {
  const _StateWidget({
    required this.provider,
    required this.builder,
    this.onRefresh,
    this.onRetry,
    this.loading,
    this.error,
  });

  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(T data, WidgetRef ref) builder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final asyncValue = ref.watch(provider);

    return CustomMaterialIndicator(
      onRefresh:
          onRefresh ??
          () async {
            return ref.refresh(provider as Refreshable<AsyncValue<T>>);
          },
      triggerMode: IndicatorTriggerMode.onEdge,
      indicatorBuilder: (context, controller) {
        return SizedBox(
          height: 60.0,
          child: Center(
            child: _buildRefreshIndicator(controller, asyncValue),
          ),
        );
      },
      child: asyncValue.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (data) => builder(data, ref),
        error: (err, stack) =>
            error?.call(err, stack) ??
            _buildDefaultErrorWidget(err, stack, jet, ref, context),
        loading: () => loading ?? jet.config.loader,
      ),
    );
  }
}

/// State widget for provider families
class _StateFamilyWidget<T, Param> extends JetConsumerWidget {
  const _StateFamilyWidget({
    required this.provider,
    required this.param,
    required this.builder,
    this.onRefresh,
    this.onRetry,
    this.loading,
    this.error,
  });

  final ProviderListenable<AsyncValue<T>> Function(Param) provider;
  final Param param;
  final Widget Function(T data, WidgetRef ref) builder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final asyncValue = ref.watch(provider(param));

    return CustomMaterialIndicator(
      onRefresh:
          onRefresh ??
          () async {
            return ref.refresh(provider(param) as Refreshable<AsyncValue<T>>);
          },
      triggerMode: IndicatorTriggerMode.onEdge,
      indicatorBuilder: (context, controller) {
        return SizedBox(
          height: 60.0,
          child: Center(
            child: _buildRefreshIndicator(controller, asyncValue),
          ),
        );
      },
      child: asyncValue.when(
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (data) => builder(data, ref),
        error: (err, stack) =>
            error?.call(err, stack) ??
            _buildDefaultErrorWidget(err, stack, jet, ref, context),
        loading: () => loading ?? jet.config.loader,
      ),
    );
  }
}

Widget _buildRefreshIndicator<T>(
  IndicatorController controller,
  AsyncValue<T> asyncValue,
) {
  return AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      return CircularProgressIndicator(
        value: controller.isLoading ? null : controller.value,
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
          provider: null, // Not used here
          onRetry: () => ref.refresh, // fallback
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
    onPressed: isLoading ? null : onRetry,
    child: isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text("Retry"),
  );
}
