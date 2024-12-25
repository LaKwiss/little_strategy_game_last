// lib/src/widgets/side_navigation.dart
import 'package:flutter/material.dart';

class SideNavigation extends StatelessWidget {
  final String currentSection;
  final ValueChanged<String> onSectionSelected;

  const SideNavigation({
    Key? key,
    required this.currentSection,
    required this.onSectionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'key': 'game',
        'icon': Icons.person,
        'tooltip': 'Game',
      },
      {
        'key': 'tutorials',
        'icon': Icons.book,
        'tooltip': 'Tutorials',
      },
      {
        'key': 'achievements',
        'icon': Icons.emoji_events,
        'tooltip': 'Achievements',
      },
      {
        'key': 'settings',
        'icon': Icons.shield,
        'tooltip': 'Settings',
      },
      {
        'key': 'stats',
        'icon': Icons.bar_chart,
        'tooltip': 'Statistics',
      },
    ];

    return Container(
      width: 64,
      color: const Color(0xFF1C1917),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.purple[500],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 32),
          ...sections.map(
            (section) => _buildNavButton(
              section['key'] as String,
              section['icon'] as IconData,
              section['tooltip'] as String,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String section, IconData icon, String tooltip) {
    final isSelected = currentSection == section;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(
            icon,
            color: isSelected ? Colors.purple[400] : Colors.grey[400],
          ),
          onPressed: () => onSectionSelected(section),
          style: IconButton.styleFrom(
            backgroundColor: isSelected ? const Color(0xFF292524) : null,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }
}
