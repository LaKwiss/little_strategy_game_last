import 'package:board_game/board_game.dart';
import 'package:flutter/material.dart';

/// Generate routes for the app
Route<dynamic>? generatedRoute(settings) {
  final Uri uri = Uri.parse(settings.name ?? '/');

  if (uri.path == '/') {
    MaterialPageRoute(builder: (context) => const Login());
  }

  if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'games') {
    final String gameId = uri.pathSegments[1];
    return MaterialPageRoute(
      builder: (context) => GameScreen(gameId: gameId),
    );
  }

  return MaterialPageRoute(
    builder: (context) => const NotFoundScreen(),
  );
}

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Login(),
  '/lobby': (context) => const LobbyScreen(),
  '/home': (context) => const HomeScreen(),
  '/profile': (context) => const Profile(),
  '/create_game': (context) => const CreateGameScreen(),
  '/open_lootbox': (context) => const OpenLootboxScreen(),
  '/admin_create_loot': (context) => const CreateLootFormScreen(),
};
