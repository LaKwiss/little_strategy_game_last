// lib/src/screens/game_dashboard.dart
import 'package:board_game/src/providers/article/article_provider.dart';
import 'package:board_game/src/widgets/coming_soon_section.dart';
import 'package:board_game/src/widgets/match_history.dart';
import 'package:board_game/src/widgets/overview_card.dart';
import 'package:board_game/src/widgets/widgets.dart';
import 'package:board_game/src/widgets/side_navigation.dart';
import 'package:board_game/src/widgets/tutorial_filters.dart'; // Import du widget TutorialFilters
import 'package:domain_entities/domain_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String currentSection = 'game';
  String selectedCategory = "All";
  String selectedDifficulty = "All";
  String searchQuery = "";

  final categories = ["All", "Basics", "Strategy", "Advanced", "Tips & Tricks"];
  final difficulties = ["All", "Beginner", "Intermediate", "Advanced"];

  late List<Article> articles;

  @override
  Widget build(BuildContext context) {
    articles = ref.watch(articleNotifierProvider).articles;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      backgroundColor: const Color(0xFF171717), // bg-neutral-900
      body: Row(
        children: [
          SideNavigation(
            currentSection: currentSection,
            onSectionSelected: (section) {
              setState(() {
                currentSection = section;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Route le contenu principal en fonction de la section actuelle
  Widget _buildMainContent() {
    switch (currentSection) {
      case 'game':
        return _buildGameSection();
      case 'tutorials':
        return _buildTutorialSection();
      case 'achievements':
        return ComingSoonSection(
          title: 'Achievements Coming Soon',
          description:
              'Track your progress and earn special rewards as you master Exploding Atoms! The achievement system will feature unique challenges, progression milestones, and exclusive rewards. Complete missions, unlock badges, and showcase your accomplishments.',
          releaseDate: 'January 2025',
          icon: Icons.emoji_events,
        );
      case 'stats':
        return ComingSoonSection(
          title: 'Advanced Statistics',
          description:
              'Dive deep into your gameplay performance with detailed analytics! Track your improvement over time with advanced metrics, view heat maps of your successful moves, and analyze your playing patterns to become a better player.',
          releaseDate: 'February 2025',
          icon: Icons.bar_chart,
        );
      case 'settings':
        return ComingSoonSection(
          title: 'Settings & Customization',
          description:
              'Personalize your Exploding Atoms experience! Customize your game interface, adjust sound settings, modify controls, and choose from various themes to make the game truly yours. More customization options coming soon.',
          releaseDate: 'March 2025',
          icon: Icons.shield,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Section "Game"
  Widget _buildGameSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                OverviewCard(),
                const SizedBox(height: 32),
                StatsSection(),
              ],
            ),
          ),
          const SizedBox(width: 32),
          SizedBox(
            width: 384,
            child: MatchHistory(
              matches: [],
            ),
          ),
        ],
      ),
    );
  }

  // Section "Tutorials"
  Widget _buildTutorialSection() {
    final List<Article> articles = _getFilteredArticles();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const Text(
                'Learn Exploding Atoms',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Master the game with our detailed tutorials and guides',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 32),
              // Utilisation du widget TutorialFilters
              TutorialFilters(
                searchQuery: searchQuery,
                onSearchChanged: (value) => setState(() => searchQuery = value),
                selectedCategory: selectedCategory,
                onCategoryChanged: (value) =>
                    setState(() => selectedCategory = value!),
                selectedDifficulty: selectedDifficulty,
                onDifficultyChanged: (value) =>
                    setState(() => selectedDifficulty = value!),
                categories: categories,
                difficulties: difficulties,
              ),
              const SizedBox(height: 32),
              articles.isEmpty
                  ? const Center(
                      child: Text(
                        'No tutorials found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return ArticleCard(article: article);
                      },
                    ),
            ]),
          ),
        ),
      ],
    );
  }

  // Méthode pour filtrer les articles
  List<Article> _getFilteredArticles() {
    return articles.where((article) {
      final matchesCategory =
          selectedCategory == "All" || article.category == selectedCategory;
      final matchesDifficulty = selectedDifficulty == "All" ||
          article.difficulty == selectedDifficulty;
      final matchesSearch = article.title
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          article.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesDifficulty && matchesSearch;
    }).toList();
  }
}
