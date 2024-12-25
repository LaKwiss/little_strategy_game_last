// lib/src/widgets/tutorial_filters.dart
import 'package:flutter/material.dart';
import 'modern_dropdown.dart';

class TutorialFilters extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final String selectedDifficulty;
  final ValueChanged<String?> onDifficultyChanged;
  final List<String> categories;
  final List<String> difficulties;

  const TutorialFilters({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    required this.categories,
    required this.difficulties,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF292524),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                hintText: 'Search tutorials...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1C1917),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.purple),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ModernDropdown(
            value: selectedCategory,
            items: categories,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(width: 16),
          ModernDropdown(
            value: selectedDifficulty,
            items: difficulties,
            onChanged: onDifficultyChanged,
          ),
        ],
      ),
    );
  }
}
