import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:jet/jet.dart';
import 'package:jet/resources/state/jet_consumer.dart';
import 'package:jet/networking/errors/errors.dart';
import 'package:jet/widgets/widgets/buttons/jet_button.dart';

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
class JetBuilder {
  JetBuilder._();

  // ==========================================================================
  // LIST WIDGETS
  // ==========================================================================

  /// Creates a refreshable list widget
  ///
  /// Perfect for displaying lists of items with pull-to-refresh functionality.
  /// Works with any provider that returns `List<T>`.
  static Widget list<T>({
    required AutoDisposeFutureProvider<List<T>> provider,
    required Widget Function(T item, int index) itemBuilder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (items, ref) {
        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  /// Creates a refreshable list widget with family support
  ///
  /// Use this when your provider takes parameters.
  static Widget familyList<T, Param>({
    required AutoDisposeFutureProvider<List<T>> Function(Param) provider,
    required Param param,
    required Widget Function(T item, int index) itemBuilder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateFamilyWidget<List<T>, Param>(
      provider: provider,
      param: param,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (items, ref) {
        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  // ==========================================================================
  // GRID WIDGETS
  // ==========================================================================

  /// Creates a refreshable grid widget
  ///
  /// Perfect for displaying items in a grid layout with pull-to-refresh.
  static Widget grid<T>({
    required AutoDisposeFutureProvider<List<T>> provider,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,

    // Grid customization
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
    double childAspectRatio = 1.0,

    // General customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateWidget<List<T>>(
      provider: provider,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (items, ref) {
        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  /// Creates a refreshable grid widget with family support
  static Widget familyGrid<T, Param>({
    required AutoDisposeFutureProvider<List<T>> Function(Param) provider,
    required Param param,
    required Widget Function(T item, int index) itemBuilder,
    required int crossAxisCount,

    // Grid customization
    double crossAxisSpacing = 8.0,
    double mainAxisSpacing = 8.0,
    double childAspectRatio = 1.0,

    // General customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateFamilyWidget<List<T>, Param>(
      provider: provider,
      param: param,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (items, ref) {
        return GridView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(items[index], index),
        );
      },
    );
  }

  // ==========================================================================
  // SINGLE ITEM WIDGETS
  // ==========================================================================

  /// Creates a refreshable single item widget
  ///
  /// Perfect for displaying a single item (like user profile, product details)
  /// with pull-to-refresh functionality.
  static Widget item<T>({
    required AutoDisposeFutureProvider<T> provider,
    required Widget Function(T item, WidgetRef ref) builder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateWidget<T>(
      provider: provider,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (item, ref) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          child: builder(item, ref),
        );
      },
    );
  }

  /// Creates a refreshable single item widget with family support
  static Widget familyItem<T, Param>({
    required AutoDisposeFutureProvider<T> Function(Param) provider,
    required Param param,
    required Widget Function(T item, WidgetRef ref) builder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,
    EdgeInsets? padding,
    ScrollPhysics? physics,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateFamilyWidget<T, Param>(
      provider: provider,
      param: param,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: (item, ref) {
        return SingleChildScrollView(
          padding: padding,
          physics: physics ?? const AlwaysScrollableScrollPhysics(),
          child: builder(item, ref),
        );
      },
    );
  }

  // ==========================================================================
  // CUSTOM BUILDER WIDGET
  // ==========================================================================

  /// Creates a refreshable widget with custom builder
  ///
  /// Use this when you need full control over the widget structure
  /// while still getting pull-to-refresh and error handling.
  static Widget builder<T>({
    required AutoDisposeFutureProvider<T> provider,
    required Widget Function(T data, WidgetRef ref) builder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateWidget<T>(
      provider: provider,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: builder,
    );
  }

  /// Creates a refreshable widget with custom builder and family support
  static Widget familyBuilder<T, Param>({
    required AutoDisposeFutureProvider<T> Function(Param) provider,
    required Param param,
    required Widget Function(T data, WidgetRef ref) builder,

    // Customization
    Widget? loading,
    Widget Function(Object error, StackTrace? stackTrace)? error,

    // Callbacks
    VoidCallback? onRetry,
    Future<void> Function()? onRefresh,
  }) {
    return _StateFamilyWidget<T, Param>(
      provider: provider,
      param: param,
      onRefresh: onRefresh,
      onRetry: onRetry,
      loading: loading,
      error: error,
      builder: builder,
    );
  }
}

// =============================================================================
// ERROR HANDLING HELPER FUNCTIONS
// =============================================================================

/// Build a retry button with loading state management
Widget _buildRetryButton<T>({
  required JetError jetError,
  required WidgetRef ref,
  required VoidCallback? onRetry,
  required AutoDisposeFutureProvider<T> provider,
}) {
  return JetConsumer(
    builder: (context, ref, jet) {
      final isLoading = ref.watch(provider).isLoading;
      final loader = jet.config.loader;
      return ElevatedButton(
        onPressed: isLoading ? null : onRetry,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: loader,
              )
            : Text(_getRetryButtonText(jetError)),
      );
    },
  );
}

/// Build error icon based on JetError type
Widget _buildErrorIcon(JetError jetError) {
  IconData iconData;
  Color color;

  switch (jetError.type) {
    case JetErrorType.noInternet:
      iconData = Icons.wifi_off;
      color = Colors.orange;
      break;
    case JetErrorType.server:
      iconData = Icons.dns;
      color = Colors.red;
      break;
    case JetErrorType.client:
      iconData = Icons.error_outline;
      color = Colors.red;
      break;
    case JetErrorType.validation:
      iconData = Icons.warning;
      color = Colors.amber;
      break;
    case JetErrorType.timeout:
      iconData = Icons.access_time;
      color = Colors.orange;
      break;
    case JetErrorType.cancelled:
      iconData = Icons.cancel;
      color = Colors.grey;
      break;
    case JetErrorType.unknown:
      iconData = Icons.error_outline;
      color = Colors.red;
      break;
  }

  return Icon(iconData, size: 48, color: color);
}

/// Get error title based on JetError type
String _getErrorTitle(JetError jetError) {
  switch (jetError.type) {
    case JetErrorType.noInternet:
      return 'No Internet Connection';
    case JetErrorType.server:
      return 'Server Error';
    case JetErrorType.client:
      return 'Request Error';
    case JetErrorType.validation:
      return 'Validation Error';
    case JetErrorType.timeout:
      return 'Request Timeout';
    case JetErrorType.cancelled:
      return 'Request Cancelled';
    case JetErrorType.unknown:
    default:
      return 'Something went wrong';
  }
}

/// Get retry button text based on JetError type
String _getRetryButtonText(JetError jetError) {
  switch (jetError.type) {
    case JetErrorType.noInternet:
      return 'Check Connection';
    case JetErrorType.cancelled:
      return 'Restart';
    default:
      return 'Retry';
  }
}

/// Build validation errors widget
Widget _buildValidationErrors(Map<String, List<String>> errors) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      border: Border.all(color: Colors.red.shade300),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: errors.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            '${entry.key}: ${entry.value.join(', ')}',
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// =============================================================================
// INTERNAL IMPLEMENTATION WIDGETS
// =============================================================================

/// Internal widget that handles state management for regular providers
class _StateWidget<T> extends JetConsumerWidget {
  const _StateWidget({
    required this.provider,
    required this.builder,
    this.onRefresh,
    this.onRetry,
    this.loading,
    this.error,
  });

  final AutoDisposeFutureProvider<T> provider;
  final Widget Function(T data, WidgetRef ref) builder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final asyncValue = ref.watch(provider);

    return CustomMaterialIndicator(
      onRefresh: onRefresh ?? () => ref.refresh(provider.future),
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

  Widget _buildRefreshIndicator(
    IndicatorController controller,
    AsyncValue<T> asyncValue,
  ) {
    if (controller.state.isLoading || asyncValue.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }

    final progress = controller.value.clamp(0.0, 1.0);
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 2.0,
      ),
    );
  }

  Widget _buildDefaultErrorWidget(
    Object error,
    StackTrace? stackTrace,
    Jet jet,
    WidgetRef ref,
    BuildContext context,
  ) {
    // Use the error handler to process the error
    final jetError = jet.config.errorHandler.handle(error, stackTrace);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildErrorIcon(jetError),
                    const SizedBox(height: 16),
                    Text(
                      _getErrorTitle(jetError),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jetError.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (jetError.isValidation && jetError.errors != null) ...[
                      const SizedBox(height: 12),
                      _buildValidationErrors(jetError.errors!),
                    ],
                    const SizedBox(height: 16),

                    _buildRetryButton(
                      jetError: jetError,
                      ref: ref,
                      onRetry: onRetry ?? () => ref.invalidate(provider),
                      provider: provider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Internal widget that handles state management for family providers
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

  final AutoDisposeFutureProvider<T> Function(Param) provider;
  final Param param;
  final Widget Function(T data, WidgetRef ref) builder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final familyProvider = provider(param);
    final asyncValue = ref.watch(familyProvider);

    return CustomMaterialIndicator(
      onRefresh: onRefresh ?? () => ref.refresh(familyProvider.future),
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

  Widget _buildRefreshIndicator(
    IndicatorController controller,
    AsyncValue<T> asyncValue,
  ) {
    if (controller.state.isLoading || asyncValue.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }

    final progress = controller.value.clamp(0.0, 1.0);
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        value: progress,
        strokeWidth: 2.0,
      ),
    );
  }

  Widget _buildDefaultErrorWidget(
    Object error,
    StackTrace? stackTrace,
    Jet jet,
    WidgetRef ref,
    BuildContext context,
  ) {
    final familyProvider = provider(param);

    // Use the error handler to process the error
    final jetError = jet.config.errorHandler.handle(error, stackTrace);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildErrorIcon(jetError),
                    const SizedBox(height: 16),
                    Text(
                      _getErrorTitle(jetError),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      jetError.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (jetError.isValidation && jetError.errors != null) ...[
                      const SizedBox(height: 12),
                      _buildValidationErrors(jetError.errors!),
                    ],
                    const SizedBox(height: 16),

                    _buildRetryButton<T>(
                      jetError: jetError,
                      ref: ref,
                      onRetry: onRetry ?? () => ref.invalidate(familyProvider),
                      provider: familyProvider,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
