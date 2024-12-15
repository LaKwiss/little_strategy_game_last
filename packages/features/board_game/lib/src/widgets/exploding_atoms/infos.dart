import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget pour présenter les informations d'un jeu [ExplodingAtomsInfos].
///
/// Utilise un [ListTile] pour une présentation compacte et cohérente
/// au sein d'une liste ou d'un [ListView].
class ExplodingAtomsInfoTile extends ConsumerStatefulWidget {
  /// Instance des informations du jeu à afficher.
  final ExplodingAtomsInfos gameInfo;

  /// Constructeur de la classe [ExplodingAtomsInfoTile].
  const ExplodingAtomsInfoTile({super.key, required this.gameInfo});

  @override
  ConsumerState<ExplodingAtomsInfoTile> createState() =>
      _ExplodingAtomsInfoTileState();
}

class _ExplodingAtomsInfoTileState
    extends ConsumerState<ExplodingAtomsInfoTile> {
  @override
  void initState() {
    if (widget.gameInfo.totalPlayers == widget.gameInfo.currentPlayer) {
      //final id = widget.gameInfo.id;
      ref.read(gameStateProvider.notifier).updateGameInfos(widget.gameInfo);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        leading: _buildLeadingImage(),
        title: Text(
          widget.gameInfo.title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('État: ${_stateToString(widget.gameInfo.state)}'),
            const SizedBox(height: 2),
            Text('Tour: ${widget.gameInfo.turn}'),
            const SizedBox(height: 2),
            Text(
                'Joueurs: ${widget.gameInfo.currentPlayer}/${widget.gameInfo.totalPlayers}'),
          ],
        ),
        trailing: _buildTrailingStatus(),
        onTap: () {
          final id = widget.gameInfo.id;
          Navigator.of(context).pushNamed('/games/$id');
        },
      ),
    );
  }

  /// Construit l'image principale affichée à gauche du [ListTile].
  Widget _buildLeadingImage() {
    return const CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage('https://picsum.photos/200'),
      backgroundColor: Colors.transparent,
    );
  }

  /// Construit un indicateur visuel à droite du [ListTile] en fonction de l'état du jeu.
  Widget _buildTrailingStatus() {
    IconData iconData;
    Color iconColor;

    switch (widget.gameInfo.state) {
      case ExplodingAtomsState.waitingForPlayers:
        iconData = Icons.hourglass_bottom;
        iconColor = Colors.orange;
        break;
      case ExplodingAtomsState.started:
        iconData = Icons.play_arrow;
        iconColor = Colors.green;
        break;
      case ExplodingAtomsState.ended:
        iconData = Icons.check_circle;
        iconColor = Colors.red;
        break;
    }

    return Icon(iconData, color: iconColor, size: 28);
  }

  /// Convertit l'état enum [ExplodingAtomsState] en une chaîne lisible.
  String _stateToString(ExplodingAtomsState state) {
    switch (state) {
      case ExplodingAtomsState.waitingForPlayers:
        return 'En attente de joueurs';
      case ExplodingAtomsState.started:
        return 'En cours';
      case ExplodingAtomsState.ended:
        return 'Terminé';
    }
  }
}
