import 'package:flutter/material.dart';

class TitleTwoSlot extends StatelessWidget {
  const TitleTwoSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
          ),
        ),
      ],
    );
  }
}
