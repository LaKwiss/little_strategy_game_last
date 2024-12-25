// lib/src/state/article_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart'; // Pour utiliser Icons
import 'package:domain_entities/domain_entities.dart'; // Assurez-vous que Article est défini ici.

part 'article_state.freezed.dart';

@freezed
class ArticleState with _$ArticleState {
  const factory ArticleState({
    @Default("All") String selectedCategory,
    @Default("All") String selectedDifficulty,
    @Default("") String searchQuery,
    @Default(["All", "Basics", "Strategy", "Advanced", "Tips & Tricks"])
    List<String> categories,
    @Default(["All", "Beginner", "Intermediate", "Advanced"])
    List<String> difficulties,
    required List<Article> articles, // Champ ajouté pour les articles
  }) = _ArticleState;

  // Constructeur initial avec une liste d'articles par défaut
  factory ArticleState.initial() => ArticleState(
        articles: [
          Article(
            id: '1',
            title: "Getting Started with Exploding Atoms",
            description:
                "Learn the basic rules and mechanics of Exploding Atoms. Perfect for new players wanting to understand how atoms move and explode.",
            category: "Basics",
            readTime: "5 min",
            tags: ["basics", "rules", "mechanics"],
            difficulty: "Beginner",
            iconName: Icons.science.toString(),
          ),
          Article(
            id: '2',
            title: "Advanced Chain Reaction Strategies",
            description:
                "Master the art of creating and controlling chain reactions. Learn how to predict explosion patterns and dominate the board.",
            category: "Strategy",
            readTime: "10 min",
            tags: ["strategy", "advanced", "chain-reactions"],
            difficulty: "Advanced",
            iconName: Icons.psychology.toString(),
          ),
          Article(
            id: '3',
            title: "Corner Control Techniques",
            description:
                "Understanding the importance of corners in Exploding Atoms. Learn essential techniques to secure and defend corner positions.",
            category: "Strategy",
            readTime: "8 min",
            tags: ["strategy", "positioning", "defense"],
            difficulty: "Intermediate",
            iconName: Icons.gamepad.toString(),
          ),
          Article(
            id: '4',
            title: "Winning End-Game Scenarios",
            description:
                "Analysis of common end-game situations. Learn how to convert advantageous positions into victories.",
            category: "Advanced",
            readTime: "12 min",
            tags: ["endgame", "strategy", "winning"],
            difficulty: "Advanced",
            iconName: Icons.bolt.toString(),
          ),
        ],
      );
}
