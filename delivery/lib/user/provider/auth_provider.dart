import 'package:delivery/common/view/root_tab.dart';
import 'package:delivery/common/view/splash_screen.dart';
import 'package:delivery/restaurant/view/restaurant_detail_screen.dart';
import 'package:delivery/user/model/user_model.dart';
import 'package:delivery/user/provider/user_me_provider.dart';
import 'package:delivery/user/view/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (_, __) => RootTab(),
          routes: [
            GoRoute(
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routerName,
                builder: (_, state) =>
                    RestaurantDetailScreen(id: state.params['rid']!)),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (_, __) => SplashScreen(),
        ),
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            builder: (_, __) => LoginScreen())
      ];

  logout() {
    ref.read(userMeProvider.notifier).logout();
  }

  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);
    final loggingIn = state.location == '/login';

    if (user == null) {
      return loggingIn ? null : '/login';
    }

    if (user is UserModel) {
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    return null;
  }
}
