import 'package:flutter/material.dart';

class ModernBanner extends StatelessWidget {
  final String url;
  final VoidCallback onEdit;

  const ModernBanner({super.key, required this.url, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                url.isEmpty
                    ? 'https://via.placeholder.com/600x200.png?text=No+Banner'
                    : url,
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.3 * 255).round()),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withAlpha((0.7 * 255).round()),
                  Colors.purple.withAlpha((0.9 * 255).round()),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withAlpha((0.3 * 255).round()),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: 'editBtn',
              elevation: 0,
              backgroundColor: Colors.transparent,
              onPressed: onEdit,
              child: const Icon(Icons.edit),
            ),
          ),
        ),
      ],
    );
  }
}
