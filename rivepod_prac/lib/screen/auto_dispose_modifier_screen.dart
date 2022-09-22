import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivepod_prac/layout/default_layout.dart';
import 'package:rivepod_prac/riverpod/auto_dispose_modifier.dart';

class AutoDisposeModifierScreen extends ConsumerWidget {
  const AutoDisposeModifierScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(autoDisposeModifierProvider);
    return DefaultLayout(
      title: 'AutoDisposeModifierScreen',
      body: Center(
        child: state.when(
          // 항상 새로 데이터 생성(캐싱X)
          data: (List<int> data) {
            return Text(data.toString());
          },
          error: (Object error, StackTrace? stackTrace) =>
              Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
