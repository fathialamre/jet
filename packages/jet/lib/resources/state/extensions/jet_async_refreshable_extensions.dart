import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Extension to make it easier to create refresh widgets with providers
extension ProviderRefreshExtension on WidgetRef {
  /// Creates a simple refresh callback that invalidates the provider
  Future<void> Function() refreshByInvalidating<T>(
    ProviderBase<AsyncValue<T>> provider,
  ) {
    return () async {
      invalidate(provider);
      // The widget will automatically rebuild when the provider state changes
    };
  }

  /// Creates a refresh callback for family providers
  Future<void> Function() refreshFamilyByInvalidating<T, Param>(
    ProviderBase<AsyncValue<T>> Function(Param) provider,
    Param param,
  ) {
    return () async {
      invalidate(provider(param));
      // The widget will automatically rebuild when the provider state changes
    };
  }

  /// Creates a refresh callback for FutureProvider that waits for completion
  /// This is the recommended approach for FutureProvider as per Riverpod docs
  Future<void> Function() refreshFutureProvider<T>(
    FutureProvider<T> provider,
  ) {
    return () => refresh(provider.future);
  }

  /// Creates a refresh callback for AutoDisposeFutureProvider that waits for completion
  Future<void> Function() refreshAutoDisposeFutureProvider<T>(
    AutoDisposeFutureProvider<T> provider,
  ) {
    return () => refresh(provider.future);
  }

  /// Creates a refresh callback for FutureProvider.family that waits for completion
  Future<void> Function() refreshFutureProviderFamily<T, Param>(
    FutureProvider<T> Function(Param) provider,
    Param param,
  ) {
    return () => refresh(provider(param).future);
  }

  /// Creates a refresh callback for AutoDisposeFutureProvider.family that waits for completion
  Future<void> Function() refreshAutoDisposeFutureProviderFamily<T, Param>(
    AutoDisposeFutureProvider<T> Function(Param) provider,
    Param param,
  ) {
    return () => refresh(provider(param).future);
  }
}

/// Builder function type for creating refresh widgets
typedef RefreshWidgetBuilder<T> =
    Widget Function(
      T data,
      WidgetRef ref,
    );
