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
  String _query = '';
  int _autoPlaySignal = 0;

  @override
  Widget build(BuildContext context) {
    final filtered = _filterConcepts(visualConcepts, _filter, _query);

    return Scaffold(
      appBar: AppBar(title: const Text('Visualiser')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1B3357),
                  Color(0xFF3C2A85),
                  Color(0xFF0D6879),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Visualiser pour mieux retenir',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Lis un schema et avance etape par etape pour comprendre le flux Git sans te noyer.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _LegendRow(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un schema (merge, conflit, pull...)',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
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
          if (filtered.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text('Aucun schema trouve avec ce filtre.'),
              ),
            )
          else
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

  List<VisualConcept> _filterConcepts(
    List<VisualConcept> source,
    String filter,
    String query,
  ) {
    final q = query.trim().toLowerCase();
    return source.where((concept) {
      final category = _categoryLabel(concept);
      final categoryMatch = filter == 'Tous' || category == filter;
      final searchable = [
        concept.title,
        concept.description,
        ...concept.nodes,
      ].join(' ').toLowerCase();
      final queryMatch = q.isEmpty || searchable.contains(q);
      return categoryMatch && queryMatch;
    }).toList();
  }

  String _categoryLabel(VisualConcept concept) {
    final title = concept.title.toLowerCase();
    if (title.contains('commit') || title.contains('historique')) {
      return 'Historique';
    }
    if (title.contains('branch') ||
        title.contains('merge') ||
        title.contains('conflit')) {
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
