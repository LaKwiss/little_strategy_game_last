import 'package:domain_entities/src/characters/stat.dart';
import 'package:flutter/material.dart';

class Character {
  final String name;
  final String description;
  final int level;
  final List<Stat> stats;
  final Function fn;

  Character({
    required this.name,
    required this.description,
    required this.level,
    required this.stats,
    required this.fn,
  });

  static final Character chicken = Character(
    name: 'Chicken',
    description: 'A chicken that lays eggs',
    level: 0,
    stats: [Stat.defaultStat, Stat.advancedStat, Stat.eliteStat],
    fn: () =>
        Image.asset('packages/domain_entities/assets/images/chicken_2.png'),
  );

  Character upgrade() {
    if (level < stats.length) {
      return Character(
        name: name,
        description: description,
        level: level + 1,
        stats: stats,
        fn: fn,
      );
    }
    return this;
  }

  Character reset() {
    return Character(
      name: name,
      description: description,
      level: 0,
      stats: stats,
      fn: fn,
    );
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      description: json['description'],
      level: json['level'],
      stats: json['stats'].map((e) => Stat.fromJson(e)).toList(),
      fn: json['fn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'level': level,
      'stats': stats.map((e) => e.toJson()).toList(),
      'fn': fn,
    };
  }
}
