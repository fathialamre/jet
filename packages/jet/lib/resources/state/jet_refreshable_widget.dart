import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/jet.dart';
import 'package:jet/resources/state/jet_consumer.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

/// A refreshable widget that handles AsyncValue states with pull-to-refresh functionality
///
/// This widget provides a complete solution for displaying async data with proper
/// loading, error, and refresh states. It uses the custom_refresh_indicator package
/// for enhanced refresh control.
///
/// **Key Features:**
/// - Automatic state management for loading, data, and error states
/// - Pull-to-refresh functionality with customizable indicators
/// - Proper handling of concurrent refresh operations
/// - Customizable loading and error widgets
/// - Built-in retry functionality
///
/// **Performance Optimizations:**
/// - Uses `skipLoadingOnReload` and `skipLoadingOnRefresh` to prevent double loading states
/// - Clamps refresh indicator values for smooth animations
/// - Minimal rebuilds during refresh operations
class JetRefreshableWidget<T> extends JetConsumerWidget {
  /// Creates a refreshable widget with the specified configuration
  const JetRefreshableWidget({
    super.key,
    required this.asyncValue,
    required this.builder,
    required this.onRefresh,
    this.loading,
    this.error,
    this.onRetry,
    this.refreshTriggerPullDistance = 100.0,
    this.refreshIndicatorExtent = 60.0,
  });

  /// Function that watches the provider and returns AsyncValue<T>
  /// This approach allows any provider type that returns AsyncValue<T>
  final AsyncValue<T> Function(WidgetRef ref) asyncValue;

  /// Builder function called when data is available
  /// Provides both the data and WidgetRef for additional provider access
  final Widget Function(T data, WidgetRef ref) builder;

  /// Callback function called when user triggers refresh
  /// Should return a Future that completes when refresh is done
  final Future<void> Function() onRefresh;

  /// Optional custom loading widget
  /// If not provided, shows a centered CircularProgressIndicator
  final Widget? loading;

  /// Optional custom error widget builder
  /// Receives error and stack trace
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  /// Optional callback for retry action in error state
  final VoidCallback? onRetry;

  /// Distance the user needs to pull to trigger refresh
  final double refreshTriggerPullDistance;

  /// Height of the refresh indicator
  final double refreshIndicatorExtent;

  @override
  Widget jetBuild(BuildContext context, WidgetRef ref, Jet jet) {
    final asyncValue = this.asyncValue(ref);

    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      triggerMode: IndicatorTriggerMode.onEdge,
      indicatorBuilder: (context, controller) {
        return SizedBox(
          height: refreshIndicatorExtent,
          child: Center(
            child: _buildRefreshIndicator(controller, asyncValue),
          ),
        );
      },
      child: asyncValue.when(
        // Performance optimization: Skip loading states during refresh operations
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        data: (data) => builder(data, ref),
        error: (err, stack) =>
            error?.call(err, stack) ??
            _buildDefaultErrorWidget(err, stack, jet, ref),
        loading: () => loading ?? _buildDefaultLoadingWidget(jet),
      ),
    );
  }

  /// Builds the refresh indicator based on the current state
  Widget _buildRefreshIndicator(
    IndicatorController controller,
    AsyncValue<T> asyncValue,
  ) {
    // Show loading indicator if refresh is in progress
    if (controller.state.isLoading || asyncValue.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
      );
    }

    // Show progress indicator based on pull distance
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

  /// Builds the default loading widget using Jet's configuration
  Widget _buildDefaultLoadingWidget(Jet jet) {
    return jet.config.loader;
  }

  /// Builds the default error widget with retry functionality
  Widget _buildDefaultErrorWidget(
    Object error,
    StackTrace? stackTrace,
    Jet jet,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints: const BoxConstraints(minHeight: 300),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(error),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Extracts a user-friendly error message from the error object
  String _getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }
}
