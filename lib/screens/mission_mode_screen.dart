import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/mission_scenario.dart';
import '../state/app_state_scope.dart';

class MissionModeScreen extends StatefulWidget {
  const MissionModeScreen({super.key});

  @override
  State<MissionModeScreen> createState() => _MissionModeScreenState();
}

class _MissionModeScreenState extends State<MissionModeScreen> {
  String _difficulty = 'Tous';
  int _index = 0;
  int? _selected;
  bool _validated = false;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final filtered = _filteredMissions(missionScenarios, _difficulty);
    final safeScenarios = filtered.isEmpty ? missionScenarios : filtered;
    if (_index >= safeScenarios.length) {
      _index = 0;
      _selected = null;
      _validated = false;
    }
    final scenario = safeScenarios[_index];
    final completedCount = appState.completedMissionIds.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Missions Reelles Git')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mission ${_index + 1}/${safeScenarios.length}'),
                      const SizedBox(height: 8),
                      Text(
                        '$completedCount/${missionScenarios.length} missions valides',
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: appState.missionProgress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Tous', 'Debutant', 'Intermediaire', 'Avance']
                    .map(
                      (item) => ChoiceChip(
                        label: Text(item),
                        selected: _difficulty == item,
                        onSelected: (_) {
                          setState(() {
                            _difficulty = item;
                            _index = 0;
                            _selected = null;
                            _validated = false;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              _MissionCard(
                scenario: scenario,
                selected: _selected,
                validated: _validated,
                onSelect: (value) {
                  if (_validated) {
                    return;
                  }
                  setState(() => _selected = value);
                },
              ),
              const SizedBox(height: 10),
              if (_validated)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selected == scenario.correctIndex ? 'Bonne decision' : 'Decision risquee',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _selected == scenario.correctIndex
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(scenario.explanation),
                        const SizedBox(height: 8),
                        Text(
                          'Commande cle: ${scenario.keyCommand}',
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  FilledButton(
                    onPressed: () {
                      if (_selected == null || _validated) {
                        return;
                      }
                      final ok = _selected == scenario.correctIndex;
                      if (ok) {
                        appState.markMissionDone(scenario.id);
                      }
                      setState(() => _validated = true);
                    },
                    child: const Text('Valider choix'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _index = (_index + 1) % safeScenarios.length;
                        _selected = null;
                        _validated = false;
                      });
                    },
                    child: const Text('Mission suivante'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  List<MissionScenario> _filteredMissions(List<MissionScenario> source, String difficulty) {
    if (difficulty == 'Tous') {
      return source;
    }
    return source.where((item) => item.difficulty == difficulty).toList();
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.scenario,
    required this.selected,
    required this.validated,
    required this.onSelect,
  });

  final MissionScenario scenario;
  final int? selected;
  final bool validated;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(scenario.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Niveau: ${scenario.difficulty}')),
              ],
            ),
            const SizedBox(height: 6),
            Text(scenario.context),
            const SizedBox(height: 10),
            ...List.generate(scenario.options.length, (index) {
              final isSelected = selected == index;
              final isCorrect = scenario.correctIndex == index;

              Color? color;
              if (validated && isCorrect) {
                color = Colors.green.withValues(alpha: 0.20);
              } else if (validated && isSelected && !isCorrect) {
                color = Colors.red.withValues(alpha: 0.16);
              }

              return Card(
                color: color,
                child: ListTile(
                  onTap: () => onSelect(index),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(scenario.options[index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
