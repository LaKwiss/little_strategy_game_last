import 'package:equatable/equatable.dart';

//TODO: Add more stats with part / part of

class Stat extends Equatable {
  final double probabilitySpellType1;
  final double probabilitySpellType2;
  final double probabilitySpellType3;
  final double probabilitySpellType4;

  final double probabilitySpellCommon;
  final double probabilitySpellRare;
  final double probabilitySpellEpic;
  final double probabilitySpellLegendary;

  static const String type1 = 'Bonus';
  static const String type2 = 'Malus';
  static const String type3 = 'Multiplier';
  static const String type4 = 'Extra';

  const Stat({
    required this.probabilitySpellType1,
    required this.probabilitySpellType2,
    required this.probabilitySpellType3,
    required this.probabilitySpellType4,
    required this.probabilitySpellCommon,
    required this.probabilitySpellRare,
    required this.probabilitySpellEpic,
    required this.probabilitySpellLegendary,
  });

  @override
  List<Object?> get props => [
        probabilitySpellType1,
        probabilitySpellType2,
        probabilitySpellType3,
        probabilitySpellType4,
        probabilitySpellCommon,
        probabilitySpellRare,
        probabilitySpellEpic,
        probabilitySpellLegendary,
      ];

  static const Stat defaultStat = Stat(
    probabilitySpellType1: 0.25,
    probabilitySpellType2: 0.25,
    probabilitySpellType3: 0.25,
    probabilitySpellType4: 0.25,
    probabilitySpellCommon: 0.5,
    probabilitySpellRare: 0.3,
    probabilitySpellEpic: 0.15,
    probabilitySpellLegendary: 0.05,
  );

  static const Stat advancedStat = Stat(
    probabilitySpellType1: 0.1,
    probabilitySpellType2: 0.3,
    probabilitySpellType3: 0.3,
    probabilitySpellType4: 0.3,
    probabilitySpellCommon: 0.4,
    probabilitySpellRare: 0.3,
    probabilitySpellEpic: 0.2,
    probabilitySpellLegendary: 0.1,
  );

  static const Stat eliteStat = Stat(
    probabilitySpellType1: 0.05,
    probabilitySpellType2: 0.15,
    probabilitySpellType3: 0.3,
    probabilitySpellType4: 0.5,
    probabilitySpellCommon: 0.3,
    probabilitySpellRare: 0.3,
    probabilitySpellEpic: 0.3,
    probabilitySpellLegendary: 0.1,
  );

  factory Stat.fromJson(Map<String, dynamic> json) {
    return Stat(
      probabilitySpellType1: json['probabilitySpellType1'],
      probabilitySpellType2: json['probabilitySpellType2'],
      probabilitySpellType3: json['probabilitySpellType3'],
      probabilitySpellType4: json['probabilitySpellType4'],
      probabilitySpellCommon: json['probabilitySpellCommon'],
      probabilitySpellRare: json['probabilitySpellRare'],
      probabilitySpellEpic: json['probabilitySpellEpic'],
      probabilitySpellLegendary: json['probabilitySpellLegendary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'probabilitySpellType1': probabilitySpellType1,
      'probabilitySpellType2': probabilitySpellType2,
      'probabilitySpellType3': probabilitySpellType3,
      'probabilitySpellType4': probabilitySpellType4,
      'probabilitySpellCommon': probabilitySpellCommon,
      'probabilitySpellRare': probabilitySpellRare,
      'probabilitySpellEpic': probabilitySpellEpic,
      'probabilitySpellLegendary': probabilitySpellLegendary,
    };
  }
}
