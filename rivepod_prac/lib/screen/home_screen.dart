import 'package:flutter/material.dart';
import 'package:rivepod_prac/layout/default_layout.dart';
import 'package:rivepod_prac/screen/auto_dispose_modifier_screen.dart';
import 'package:rivepod_prac/screen/family_modifier_screen.dart';
import 'package:rivepod_prac/screen/future_provider_screen.dart';
import 'package:rivepod_prac/screen/listen_provider_screen.dart';
import 'package:rivepod_prac/screen/provider_screen.dart';
import 'package:rivepod_prac/screen/select_provider_screen.dart';
import 'package:rivepod_prac/screen/state_notifier_provider_screen.dart';
import 'package:rivepod_prac/screen/state_provider_screen.dart';
import 'package:rivepod_prac/screen/stream_provider_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: 'HomeScreen',
        body: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const StateProviderScreen()));
              },
              child: const Text('State Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const StateNotifierProviderScreen()));
              },
              child: const Text('State Notifier Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const FutureProviderScreen()));
              },
              child: const Text('Future Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const StreamProviderScreen()));
              },
              child: const Text('Stream Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const FamilyModifierScreen()));
              },
              child: const Text('Family Modifier Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const AutoDisposeModifierScreen()));
              },
              child: const Text('Auto Dispose Modifier Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ListenProviderScreen()));
              },
              child: const Text('Listen Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const SelectProviderScreen()));
              },
              child: const Text('Select Provider Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ProviderScreen()));
              },
              child: const Text('Provider Screen'),
            ),
          ],
        ));
  }
}
