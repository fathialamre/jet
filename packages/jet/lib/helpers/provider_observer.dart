import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jet/helpers/jet_logger.dart';

base class LoggerObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    dump(
      '${context.provider.name ?? context.provider.runtimeType} '
      'from $previousValue to $newValue',
      tag: '[Provider Updated]',
    );
    super.didUpdateProvider(context, previousValue, newValue);
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    dump(
      '${context.provider.name ?? context.provider.runtimeType} = $value',
      tag: '[Provider Added]',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    dump(
      '${context.provider.name ?? context.provider.runtimeType}',
      tag: '[Provider Disposed]',
    );
  }
}
