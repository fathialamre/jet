import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Simple state to track notification interactions
class NotificationState {
  final int tapCount;
  final int receiveCount;
  final String? lastOrderId;
  final DateTime? lastInteraction;

  const NotificationState({
    this.tapCount = 0,
    this.receiveCount = 0,
    this.lastOrderId,
    this.lastInteraction,
  });

  NotificationState copyWith({
    int? tapCount,
    int? receiveCount,
    String? lastOrderId,
    DateTime? lastInteraction,
  }) {
    return NotificationState(
      tapCount: tapCount ?? this.tapCount,
      receiveCount: receiveCount ?? this.receiveCount,
      lastOrderId: lastOrderId ?? this.lastOrderId,
      lastInteraction: lastInteraction ?? this.lastInteraction,
    );
  }
}

/// Notifier for managing notification state
class NotificationStateNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    return const NotificationState();
  }

  void incrementTapCount(String orderId) {
    state = state.copyWith(
      tapCount: state.tapCount + 1,
      lastOrderId: orderId,
      lastInteraction: DateTime.now(),
    );
  }

  void incrementReceiveCount(String orderId) {
    state = state.copyWith(
      receiveCount: state.receiveCount + 1,
      lastOrderId: orderId,
      lastInteraction: DateTime.now(),
    );
  }

  void reset() {
    state = const NotificationState();
  }
}

/// Provider for notification state
final notificationStateProvider =
    NotifierProvider<NotificationStateNotifier, NotificationState>(
      NotificationStateNotifier.new,
    );
