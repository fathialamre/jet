import 'package:example/core/router/app_router.gr.dart';
import 'package:jet/helpers/jet_logger.dart';
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
    final auth = ref.read(authProvider);
    

    if ((auth.value?.isGuest != null && auth.value?.isGuest == false)) {
      dump(auth.value?.isGuest);
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
