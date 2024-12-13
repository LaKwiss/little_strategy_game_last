import 'package:board_game/src/providers/game/game_stream_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain_entities/domain_entities.dart';

class GameScreen extends ConsumerWidget {
  /// Identifiant unique du jeu à afficher.
  final String gameId;

  /// Constructeur de la classe [GameScreen].
  const GameScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute le `StreamProvider` pour le jeu spécifié par `gameId`.
    final gameAsyncValue = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Exploding Atoms - Jeu $gameId'),
      ),
      body: gameAsyncValue.when(
        // Lorsque les données sont disponibles, affiche le jeu.
        data: (game) {
          return ExplodingAtomsGameView(game: game);
        },
        // Affiche un indicateur de chargement pendant l'attente des données.
        loading: () => const Center(child: CircularProgressIndicator()),
        // Affiche un message d'erreur en cas de problème.
        error: (error, stack) => Center(child: Text('Erreur : $error')),
      ),
    );
  }
}

/// Widget dédié à l'affichage et à l'interaction avec le jeu [ExplodingAtoms].
/// Reçoit l'état actuel du jeu via le paramètre [game].
class ExplodingAtomsGameView extends StatelessWidget {
  /// Instance actuelle du jeu [ExplodingAtoms].
  final ExplodingAtoms game;

  /// Constructeur de la classe [ExplodingAtomsGameView].
  const ExplodingAtomsGameView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Exemple de représentation simple du jeu.
    // Remplacez ceci par votre logique d'affichage spécifique.
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Titre du Jeu : ${game.title}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          // Affiche les détails principaux du jeu.
          Text('Score Actuel : ${game.totalAtoms}'),
          const SizedBox(height: 20),
          // Ajoutez ici d'autres éléments UI pertinents,
          // comme le plateau de jeu, les joueurs, etc.
          Expanded(
            child: Center(
              child: Text(
                'État du Jeu : ${game.state}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          /// [GameWidget] se place ici pour afficher le plateau de jeu.
          GameWidget(game: game),
        ],
      ),
    );
  }
}
