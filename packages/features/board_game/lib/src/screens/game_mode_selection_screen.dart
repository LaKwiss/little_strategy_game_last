import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameModeSelectionScreen extends ConsumerWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const List<String> gameModesUrl = [
      'https://cdn.midjourney.com/0228aa62-5820-476a-a178-71de52bf615a/0_0.png',
      'https://cdn.midjourney.com/02084055-964a-410a-b0ca-835e2bcab84d/0_3.png',
      'https://cdn.midjourney.com/6e5548a5-ddc3-4297-9ad6-caea11f09f3c/0_2.png',
      'https://cdn.midjourney.com/5231d011-3b33-4be0-9823-3d463d18870f/0_0.png',
    ];

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 192),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final isMedium = constraints.maxWidth > 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Select Game Mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 48),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWide
                          ? 1200
                          : isMedium
                              ? 600
                              : 300,
                    ),
                    child: GridView.count(
                      crossAxisCount: isWide
                          ? 4
                          : isMedium
                              ? 2
                              : 1,
                      childAspectRatio: 1.5,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ModernBuildModeCard(
                          title: 'Classic Mode',
                          color: Colors.purple,
                          onTap: () => ref
                              .read(lobbyStateProvider.notifier)
                              .state = LobbyState.gameList,
                          constraints: constraints,
                          photoUrl: gameModesUrl[0],
                        ),
                        ModernBuildModeCard(
                          title: 'Team Battle',
                          color: Colors.red,
                          onTap: () => ref
                              .read(lobbyStateProvider.notifier)
                              .state = LobbyState.gameList,
                          constraints: constraints,
                          photoUrl: gameModesUrl[1],
                        ),
                        ModernBuildModeCard(
                          title: 'Tournament',
                          color: Colors.green,
                          onTap: () => ref
                              .read(lobbyStateProvider.notifier)
                              .state = LobbyState.gameList,
                          constraints: constraints,
                          photoUrl: gameModesUrl[2],
                        ),
                        ModernBuildModeCard(
                          title: 'Training',
                          color: Colors.orange,
                          onTap: () => ref
                              .read(lobbyStateProvider.notifier)
                              .state = LobbyState.gameList,
                          constraints: constraints,
                          photoUrl: gameModesUrl[3],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
