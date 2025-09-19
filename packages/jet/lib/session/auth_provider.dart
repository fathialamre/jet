import 'package:jet_flutter_framework/helpers/jet_faker.dart';
import 'package:jet_flutter_framework/jet_framework.dart';
import 'package:jet_flutter_framework/session/session_manager.dart';

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
      name: JetFaker.username(),
    );
    await SessionManager.authenticateAsGuest(session: session);
    state = AsyncValue.data(session);
  }
}

final authProvider = NotifierProvider<Auth, AsyncValue<Session?>>(
  Auth.new,
);
