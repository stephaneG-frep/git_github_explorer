import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/visual_concept.dart';
import '../widgets/section_title.dart';
import '../widgets/visual_concept_card.dart';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  String _filter = 'Tous';
  int _autoPlaySignal = 0;

  @override
  Widget build(BuildContext context) {
    final filtered = _filterConcepts(visualConcepts, _filter);

    return Scaffold(
      appBar: AppBar(title: const Text('Visualiser')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle(title: 'Concepts Git en schema anime'),
                  const SizedBox(height: 8),
                  Text(
                    '${filtered.length} schema(s) affiches',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
                  ),
                  const SizedBox(height: 10),
                  const _LegendRow(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Tous', 'Historique', 'Branches/Fusion', 'Remote/Collab']
                .map(
                  (item) => ChoiceChip(
                    label: Text(item),
                    selected: _filter == item,
                    onSelected: (_) => setState(() => _filter = item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => setState(() => _autoPlaySignal += 1),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Animer tout'),
            ),
          ),
          const SizedBox(height: 6),
          ...filtered.map(
            (concept) => VisualConceptCard(
              concept: concept,
              categoryLabel: _categoryLabel(concept),
              autoPlaySignal: _autoPlaySignal,
            ),
          ),
        ],
      ),
    );
  }

  List<VisualConcept> _filterConcepts(List<VisualConcept> source, String filter) {
    if (filter == 'Tous') {
      return source;
    }

    return source.where((concept) {
      final category = _categoryLabel(concept);
      return category == filter;
    }).toList();
  }

  String _categoryLabel(VisualConcept concept) {
    final title = concept.title.toLowerCase();
    if (title.contains('commit') || title.contains('historique')) {
      return 'Historique';
    }
    if (title.contains('branch') || title.contains('merge') || title.contains('conflit')) {
      return 'Branches/Fusion';
    }
    return 'Remote/Collab';
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: const [
        _LegendPill(label: 'Noeud normal', accent: false),
        _LegendPill(label: 'Noeud cle', accent: true),
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({required this.label, required this.accent});

  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
