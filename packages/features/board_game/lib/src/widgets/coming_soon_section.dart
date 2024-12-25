import 'package:flutter/material.dart';

class ComingSoonSection extends StatelessWidget {
  const ComingSoonSection({
    super.key,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.icon,
  });

  final String title;
  final String description;
  final String releaseDate;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 800, // Vous pouvez ajuster cette largeur ou la rendre responsive
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF292524),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Étire verticalement
              children: [
                // Section Gauche : Texte
                Expanded(
                  flex: 1, // Prend 1/2 de l'espace
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: Colors.grey[400],
                            height: 1.4,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Expected Release: $releaseDate',
                          style: const TextStyle(
                            color: Color(0xFFA855F7),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Section Droite : Icône
                Expanded(
                  flex: 1, // Prend 1/2 de l'espace
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF1C1917),
                      borderRadius: BorderRadius.only(
                        // Modification ici
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      // Centre l'icône à la fois verticalement et horizontalement
                      child: Icon(
                        icon,
                        size: 48,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
