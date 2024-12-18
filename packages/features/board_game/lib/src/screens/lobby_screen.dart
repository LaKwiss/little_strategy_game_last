import 'package:board_game/board_game.dart';
import 'package:board_game/src/providers/game/game_infos_stream_provider.dart';
import 'package:board_game/src/widgets/infos.dart';
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
    // Écoute de l'état d'authentification pour rediriger si l'utilisateur est déconnecté
    ref.listen(authProvider, (previous, next) {
      if (next.value == null &&
          ModalRoute.of(context)?.settings.name != '/login') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed('/login');
        });
      }
    });

    return Scaffold(
      bottomNavigationBar: customBottomNavigationBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(),
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
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/create_game');
      },
      child: const Icon(Icons.add),
    );
  }
}
