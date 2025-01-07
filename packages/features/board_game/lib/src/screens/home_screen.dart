// lib/src/screens/game_dashboard.dart
import 'package:board_game/src/providers/article/article_provider.dart';
import 'package:board_game/src/widgets/widgets.dart';
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

  int index = 0;

  @override
  Widget build(BuildContext context) {
    articles = ref.watch(articleNotifierProvider).articles;

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      backgroundColor: const Color(0xFF171717), // bg-neutral-900
      body: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                              index = (index - 1) % screens().length;
                            }),
                        icon: Icon(Icons.arrow_back)),
                  ],
                ),
                Expanded(
                  child: screens()[index],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                              index = (index + 1) % screens().length;
                            }),
                        icon: Icon(Icons.arrow_forward)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Power up your experience: Our newest heroes have arrived!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlue,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              const Text('View More'),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Centre les éléments horizontalement
                    children: [
                      HeroItem(
                        'https://cdn.midjourney.com/38428919-d7cf-4e49-b37a-40474c1239e0/0_1.png',
                      ),
                      HeroItem(
                        'https://cdn.midjourney.com/e3b2ff03-7724-4e55-ae35-1bc6926e4c11/0_0.png',
                      ),
                      HeroItem(
                        'https://cdn.midjourney.com/68594668-7262-45ac-9bd8-9aded91f806c/0_3.png',
                      ),
                      HeroItem(
                        'https://cdn.midjourney.com/804c9df1-78f9-4475-b3d2-e56432e22f3e/0_3.png',
                      ),
                    ],
                  ),
                ),
              ],
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

  List<Widget> screens() {
    return [
      _buildGameSection(),
      _buildTutorialSection(),
    ];
  }
}

class HeroItem extends StatelessWidget {
  const HeroItem(
    this.imageURL, {
    super.key,
  });

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: 324,
          height: 586,
          child: Image.network(
            imageURL,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
              onPressed: () {}, child: const Icon(Icons.upcoming)),
        ),
      ],
    );
  }
}
