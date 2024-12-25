// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// États pour gérer les différentes vues
final lobbyStateProvider =
    StateProvider<LobbyState>((ref) => LobbyState.gameSelection);

enum LobbyState { gameSelection, gameList, createGame }

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentState = ref.watch(lobbyStateProvider);

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      backgroundColor: Color(0xFF2C1518),
      floatingActionButton: currentState == LobbyState.gameList
          ? FloatingActionButton(
              onPressed: () => ref.read(lobbyStateProvider.notifier).state =
                  LobbyState.createGame,
              backgroundColor: Colors.purple,
              child: Icon(Icons.add),
            )
          : null,
      body: Row(
        children: [
          const Expanded(child: SizedBox.shrink()),
          Expanded(
            flex: 3,
            child: switch (currentState) {
              LobbyState.gameSelection => GameModeSelectionScreen(),
              LobbyState.gameList => GameListScreen(),
              LobbyState.createGame => ModernCreateGameView(),
            },
          ),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
