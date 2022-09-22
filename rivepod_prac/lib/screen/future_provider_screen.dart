import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivepod_prac/layout/default_layout.dart';
import 'package:rivepod_prac/riverpod/future_provider.dart';

class FutureProviderScreen extends ConsumerWidget {
  const FutureProviderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiplesFutureProvider);

    return DefaultLayout(
      title: 'FutureProvider',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          state.when(
              // 캐싱이 되기 때문에 로딩 후 다시 들어오면 데이터가 바로 보임
              data: (List<int> data) {
                return Text(
                  data.toString(),
                  textAlign: TextAlign.center,
                );
              },
              error: (Object error, StackTrace? stackTrace) {
                return Text(error.toString());
              },
              loading: () => const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
