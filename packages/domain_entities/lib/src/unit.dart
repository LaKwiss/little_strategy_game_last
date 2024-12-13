import 'package:equatable/equatable.dart';

class Unit extends Equatable {
  const Unit({
    required this.name,
    required this.attack,
    required this.defense,
  });

  final String name;
  final int attack;
  final int defense;

  @override
  List<Object?> get props => [
        name,
        attack,
        defense,
      ];

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      name: json['name'],
      attack: json['attack'],
      defense: json['defense'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'attack': attack,
      'defense': defense,
    };
  }
}
