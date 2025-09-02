import 'package:example/core/router/app_router.gr.dart';
import 'package:jet/jet_framework.dart';
import 'package:jet/session/auth_provider.dart';

class AuthGuard extends AutoRouteGuard {
  final Ref ref;

  AuthGuard({required this.ref});

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final jet = ref.read(jetProvider);

    final auth = ref.read(authProvider);

    if ((auth.value?.isGuest != null && auth.value?.isGuest == false)) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(
        LoginRoute(
          onResult: (result) {
            if (result) {
              resolver.next(true);
            }
          },
        ),
      );
    }
  }
}
