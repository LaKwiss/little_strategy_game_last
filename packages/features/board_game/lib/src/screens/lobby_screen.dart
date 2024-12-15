import 'dart:math';

import 'package:board_game/src/providers/game/game_infos_stream_provider.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the navigation bar at the bottom of the screen
  Widget _buildBottomNavigationBar(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
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
    );
  }

  /// Builds the main body of the Lobby screen
  Widget _buildBody(BuildContext context) {
    final gameInfosAsync = ref.watch(gameInfosStreamProvider);

    return Center(
      child: gameInfosAsync.when(
        data: (gameInfos) => ListView.builder(
          itemCount: gameInfos.length,
          itemBuilder: (context, index) {
            final atomGameInfo = gameInfos[index];
            return ExplodingAtomsInfoTile(gameInfo: atomGameInfo);
          },
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => const Text('Error loading games'),
      ),
    );
  }

  /// Builds the floating action button for creating a new game
  Widget _buildFloatingActionButton() {
    return IconButton(
      onPressed: () {
        final newGame = ExplodingAtoms(
          gridRows: 8,
          gridCols: 8,
          id: Random().nextInt(40).toString(),
        );
        ref.read(gameStateProvider.notifier).createGame(newGame);
      },
      icon: const Icon(Icons.add),
    );
  }
}
