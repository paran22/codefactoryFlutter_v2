import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivepod_prac/layout/default_layout.dart';
import 'package:rivepod_prac/riverpod/family_modifier.dart';

class FamilyModifierScreen extends ConsumerWidget {
  const FamilyModifierScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(familyModifierProvider(3));

    return DefaultLayout(
      title: 'FamilyModifierScreen',
      body: Center(
        child: state.when(
          data: (List<int> data) => Text(data.toString()),
          error: (Object error, StackTrace? stackTrace) =>
              Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
