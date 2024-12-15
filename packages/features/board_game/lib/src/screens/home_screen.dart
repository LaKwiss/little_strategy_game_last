// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(userProvider.notifier).fetchAndSetPlayers();
          log('Players fetched');
        },
        child: const Icon(Icons.person),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        child: NavigationBar(
          destinations: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/lobby');
              },
              icon: const Icon(Icons.list),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          const Expanded(
            child: SizedBox.shrink(),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: [Text('Some data')],
            ),
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
