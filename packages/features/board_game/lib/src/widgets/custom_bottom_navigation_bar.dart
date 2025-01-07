import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/home'),
            icon: Icon(Icons.home),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/lobby'),
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/profile'),
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
