import 'package:board_game/src/providers/article/article_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain_entities/domain_entities.dart';

part 'article_provider.g.dart';

@riverpod
class ArticleNotifier extends _$ArticleNotifier {
  @override
  ArticleState build() => ArticleState(articles: []);

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateDifficulty(String difficulty) {
    state = state.copyWith(selectedDifficulty: difficulty);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<Article> getAllArticles(List<Article> articles) {
    return articles.where((article) {
      final matchesCategory = state.selectedCategory == "All" ||
          article.category == state.selectedCategory;

      final matchesDifficulty = state.selectedDifficulty == "All" ||
          article.difficulty == state.selectedDifficulty;

      final matchesSearch = article.title
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase()) ||
          article.description
              .toLowerCase()
              .contains(state.searchQuery.toLowerCase());

      return matchesCategory && matchesDifficulty && matchesSearch;
    }).toList();
  }
}
