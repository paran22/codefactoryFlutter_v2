import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_prac/screen/home_screen.dart';
import 'package:go_router_prac/screen/one_screen.dart';
import 'package:go_router_prac/screen/three_screen.dart';
import 'package:go_router_prac/screen/two_screen.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  GoRouter get _router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, state) => HomeScreen(),
            routes: [
              GoRoute(path: 'one', builder: (_, state) => OneScreen(), routes: [
                GoRoute(
                    path: 'two',
                    builder: (_, state) => TwoScreen(),
                    routes: [
                      GoRoute(
                        path: 'three',
                        name: 'three',
                        builder: (_, state) => ThreeScreen(),
                      ),
                    ]),
              ]),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
