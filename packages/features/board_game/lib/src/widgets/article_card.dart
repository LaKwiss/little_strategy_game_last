import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  // Dimensions constantes pour une meilleure réutilisabilité
  static const double _cardWidth = 360.0;
  static const double _cardHeight = 200.0;
  static const double _padding = 24.0;
  static const double _titleFontSize = 18.0;
  static const double _descriptionFontSize = 14.0;
  static const double _tagFontSize = 12.0;
  static const double _iconSize = 24.0;
  static const double _smallIconSize = 16.0;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Ajout d'un SizedBox pour contraindre les dimensions
      width: _cardWidth,
      height: _cardHeight,
      child: Container(
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: const Color(0xFF292524),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // Hauteur fixe pour le header
              height: _iconSize,
              child: _buildHeader(),
            ),
            const SizedBox(height: 16),
            Expanded(
              // Le description prend l'espace restant
              child: _buildDescription(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              // Hauteur fixe pour le footer
              height: 24,
              child: _buildFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.article,
          color: Colors.purple[400],
          size: _iconSize,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            article.title,
            style: const TextStyle(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2, // Ajout d'un line height optimal
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      article.description,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: _descriptionFontSize,
        height: 1.5, // Meilleur espacement des lignes pour la lisibilité
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Meilleur alignement
      children: [
        _buildTag(article.category),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: _smallIconSize,
              color: Colors.grey[400],
            ),
            const SizedBox(width: 4),
            Text(
              article.readTime,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: _tagFontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.2), // Plus propre que withAlpha
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.purple[400],
          fontSize: _tagFontSize,
        ),
      ),
    );
  }
}
