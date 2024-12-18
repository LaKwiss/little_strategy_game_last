import 'package:flutter/material.dart';

Widget customBottomNavigationBar(BuildContext context) {
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
