import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      (icon: Icons.home, route: '/home'),
      (icon: Icons.list, route: '/lobby'),
      (icon: Icons.person, route: '/profile'),
    ];

    return NavigationBarTheme(
      data: NavigationBarThemeData(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          height: 68,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          indicatorColor: Colors.transparent),
      child: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) =>
            Navigator.pushNamed(context, destinations[index].route),
        destinations: destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  label: '',
                ))
            .toList(),
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '';
    return ['/home', '/lobby', '/profile'].indexOf(route);
  }
}
