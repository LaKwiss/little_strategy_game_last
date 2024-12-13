import 'package:board_game/board_game.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:little_strategy/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );

  //TODO: Supprimer les champs "Informatif" de la classe ExplodingAtoms et ajouter une référence à ExplodingAtomsInfos
  //Réfléchir à la jouabilité du jeu
  //Implémenter la logique de jeu via le provider
  //À chaque action, renvoyer la nouvelle instance du jeu, en gardant l'id
  //Les explosions doivent être gérées par le client avant d'envoyer la nouvelle instance du jeu
  //Implémenter les lootboxes
  //Comme dans Clash Royale, les lootboxes sont des coffres qui contiennent des loots divers
  //Les loot box sont des objets que l'on peut acheter ou gagner
  //Les loot box contiennent des objets aléatoires
  //Les objets peuvent être des cartes, des skins, des ressources, des bonus, etc.
  //Les lootboxes ont une rareté qui détermine la qualité des objets qu'elles contiennent
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1A1A1A),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF3B82F6),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3B82F6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white54),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1A1A1A),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF1A1A1A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: NoTransitionPageTransitionsBuilder(),
            TargetPlatform.iOS: NoTransitionPageTransitionsBuilder(),
            TargetPlatform.linux: NoTransitionPageTransitionsBuilder(),
            TargetPlatform.macOS: NoTransitionPageTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionPageTransitionsBuilder(),
          },
        ),
      ),
      title: 'Little Strategy Game',
      routes: {
        '/': (context) => const Login(),
        '/lobby': (context) => const LobbyScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const Profile(),
      },
      onGenerateRoute: (settings) {
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
      },
    );
  }
}

class NoTransitionPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
