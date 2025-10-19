import 'package:jet/jet_framework.dart';
import 'package:jet/session/session_manager.dart';

class Auth extends Notifier<AsyncValue<Session?>> {
  @override
  AsyncValue<Session?> build() {
    final Session? session = JetStorage.getSession();
    return AsyncValue.data(session);
  }

  bool get isGuest => state.value?.isGuest ?? false;

  bool get isAuthenticated => state.value?.token != null;

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    await SessionManager.clear();
    state = AsyncValue.data(null);
  }

  Future<void> login(Session session) async {
    await SessionManager.authenticateAsUser(
      session: session,
    );
    state = AsyncValue.data(session);
  }

  Future<void> loginAsGuest() async {
    final session = Session(
      token: 'guest',
      isGuest: true,
      name: 'user_${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
    await SessionManager.authenticateAsGuest(session: session);
    state = AsyncValue.data(session);
  }
}

final authProvider = NotifierProvider<Auth, AsyncValue<Session?>>(
  Auth.new,
);
