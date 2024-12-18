import 'package:equatable/equatable.dart';

class Loot extends Equatable {
  final String id;
  final String type;
  final String name;
  final String reference;
  final double weight;

  const Loot({
    required this.id,
    required this.type,
    required this.name,
    required this.reference,
    required this.weight,
  });

  @override
  List<Object> get props => [id, type, name, reference, weight];

  @override
  bool get stringify => true;

  Loot copyWith({
    String? id,
    String? type,
    String? name,
    String? reference,
    double? weight,
  }) {
    return Loot(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      reference: reference ?? this.reference,
      weight: weight ?? this.weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'reference': reference,
      'weight': weight,
    };
  }

  factory Loot.fromJson(Map<String, dynamic> json, id) {
    return Loot(
      id: id,
      type: json['type'] as String,
      name: json['name'] as String,
      reference: json['reference'] as String,
      weight: json['weight'] as double,
    );
  }
}
