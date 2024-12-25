import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:little_strategy/firebase_options.dart';
import 'package:little_strategy/route.dart';
import 'package:little_strategy/scroll_behavior.dart';
import 'package:little_strategy/theme.dart';
import 'package:logging/logging.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        Logger('main').severe('Erreur d\'initialisation Firebase : $e');
      }
      runApp(
        const ProviderScope(
          child: MainApp(),
        ),
      );
    },
    (error, stackTrace) {
      Logger('main').severe('Erreur non gérée : $error', error, stackTrace);
    },
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scrollBehavior: scrollBehavior,
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Little Strategy Game',
      routes: routes,
      onGenerateRoute: generatedRoute,
    );
  }
}
