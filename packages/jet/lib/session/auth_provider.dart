import 'package:jet/helpers/jet_faker.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/session/session_manager.dart';

class Auth extends StateNotifier<AsyncValue<Session?>> {
  Auth(super.state);

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
      name: JetFaker.username(),
    );
    await SessionManager.authenticateAsGuest(session: session);
    state = AsyncValue.data(session);
  }
}

final authProvider = StateNotifierProvider<Auth, AsyncValue<Session?>>(
  (ref) {
    final Session? session = JetStorage.getSession();
    final state = AsyncValue.data(session);
    return Auth(state);
  },
);
