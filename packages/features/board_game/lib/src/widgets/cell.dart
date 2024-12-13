import 'package:flutter/material.dart';

class Cell extends StatefulWidget {
  const Cell({super.key});

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: ClipRRect(
          child: Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'X',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
