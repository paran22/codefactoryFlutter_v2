import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_prac/model/user_model.dart';
import 'package:go_router_prac/screen/error_screen.dart';
import 'package:go_router_prac/screen/home_screen.dart';
import 'package:go_router_prac/screen/login_screen.dart';
import 'package:go_router_prac/screen/one_screen.dart';
import 'package:go_router_prac/screen/three_screen.dart';
import 'package:go_router_prac/screen/two_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateProvider = AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error.toString());
    },
    routes: authStateProvider._routes,
    //router 실행될 때 마다 실행됨
    redirect: authStateProvider._redirectLogic,
    //authStateProvider의 상태가 변경될때마다 redirect실행
    refreshListenable: authStateProvider,
  );
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({required this.ref}) {
    ref.listen<UserModel?>(userProvider, (previous, next) {
      if (previous != next) {
        //AuthNotifier 상태가 변경됨
        notifyListeners();
      }
    });
  }

  String? _redirectLogic(BuildContext context, GoRouterState state) {
    final user = ref.read(userProvider);

    final loggingIn = state.location == '/login';

    if (user == null) {
      return loggingIn ? null : '/login';
    }

    if (loggingIn) {
      return '/';
    }

    // 원래 가려던 페이지로 이동
    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'one',
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: 'two',
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    GoRoute(
                      path: 'three',
                      name: ThreeScreen.routeName,
                      builder: (_, state) => ThreeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(path: '/login', builder: (_, state) => LoginScreen()),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
    (ref) => UserStateNotifier());

class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  logout() {
    state = null;
  }
}
