import 'package:domain_entities/domain_entities.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CharacterPresentation extends StatefulWidget {
  const CharacterPresentation({required this.character, super.key});

  final Character character;

  @override
  State<CharacterPresentation> createState() => _CharacterPresentationState();
}

class _CharacterPresentationState extends State<CharacterPresentation> {
  int? hoveredIndex; // Index de la section survolée

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 43.0),
          child: Transform.translate(
            offset: const Offset(-30, 0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(3.14 / 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const SizedBox(
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 310,
              width: 310,
              child: widget.character.fn(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60.0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()..scale(0.7),
                child: SizedBox(
                  height: 260,
                  width: 260,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 50, // Espace au centre
                      sections: List.generate(
                        4,
                        (index) {
                          final titles = [
                            'Common',
                            'Rare',
                            'Epic',
                            'Legendary'
                          ];
                          final colors = [
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.yellow
                          ];
                          final values = [
                            widget.character.stats[widget.character.level]
                                .probabilitySpellCommon,
                            widget.character.stats[widget.character.level]
                                .probabilitySpellRare,
                            widget.character.stats[widget.character.level]
                                .probabilitySpellEpic,
                            widget.character.stats[widget.character.level]
                                .probabilitySpellLegendary,
                          ];

                          return PieChartSectionData(
                            value: values[index],
                            color: colors[index],
                            title: hoveredIndex == index
                                ? '${(values[index] * 100)}%'
                                : titles[index],
                            radius: hoveredIndex == index ? 90 : 70,
                            showTitle: true,
                            titleStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(
                            () {
                              if (response != null &&
                                  response.touchedSection != null) {
                                hoveredIndex = response
                                    .touchedSection!.touchedSectionIndex;
                              } else {
                                hoveredIndex = null;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
