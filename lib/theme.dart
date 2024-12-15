import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
);

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
