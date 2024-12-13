import 'dart:math';

import 'package:board_game/src/providers/game/game_notifier.dart';
import 'package:board_game/src/providers/game/game_state_provider.dart';
import 'package:board_game/src/widgets/exploding_atoms/infos.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(gameStateProvider.notifier).getAllGameInfos();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gameListState = ref.watch(gameStateProvider);

    if (gameListState.status == GameStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (gameListState.status == GameStatus.error) {
      return const Center(
        child: Text('Error loading games'),
      );
    }

    return Scaffold(
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
      body: Center(
        child: ListView(
          children: ref
              .read(gameStateProvider)
              .gameInfos
              .map((i) => ExplodingAtomsInfoTile(
                    gameInfo: i,
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () => ref.watch(gameStateProvider.notifier).createGame(
              ExplodingAtoms(
                gridRows: 8,
                gridCols: 8,
                id: Random().nextInt(40).toString(),
              ),
            ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
