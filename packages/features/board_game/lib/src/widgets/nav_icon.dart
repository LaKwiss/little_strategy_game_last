import 'package:flutter/material.dart';

class NavIcon extends StatelessWidget {
  const NavIcon({this.color, this.gradient, super.key});

  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
